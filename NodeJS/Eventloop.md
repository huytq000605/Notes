Here we have a picture about phases of event loop
![img](assets/EventloopCycle.png)

Each boxes in the image above indicates a phase which is dedicated to perform some specific work. Each phase (except Idle, prepare) have a "queue" attachd to it and JS execution can be done in any of those phases.

1. Timer phase <br>
    The starting phase in event loop. This queue holds the timer callbacks (setTimeout, setInterval). The data structure in this phase is like a min heap, it maintains the timer in that min heap and executes whose timer is elapsed. <br>
    So event loop enters the timer phase and checks if anything is there in the timer queue to be executed. Well, the statement may sound very simple, but event-loop actually has to perform few steps to find the appropriate callbacks.
Actually the timer scripts are stored in a heap memory in ascending order. So it will first take the timer and calculate if now - registeredTime == delta. If yes, it will execute the callback of that timer and will check for the next timer. Whenever a timer is not found whose time is not elapsed, it will stop checking others (as timers are sorted in ascending order) and move to the next phase.

2. Pending I/O callbacks <br>
   This phases executes callsback which are there in the pending_queue of event loop. These kinds of callbacks are pushed in the previous operations. For an example when we write something in TCP handler and the work is done, then the callback will be pushed in this queue. Error callbacks can also be found here
3. Idle, Prepare phase<br>
   This phase are for internal operations of node
4. Poll phase <br>
   Maybe the most important phase of entire event loop, this phase accepts  new imcoming connections (new socket establishment) and data (file read). Can divide the work of poll in few different parts<br>
- If there is something in the **watch_queue** (attached to poll phase), they will be executed synchronously one after another, till the time the queue is empty or the system specific     max limit is reached.
- One the queue is empty, node will try to wait for new connections. If there is any task pending in **check_queue**, **pending_queue**, it will wait for zero ms. However it will then execute the first timer (if available) from **timer_heap** to decide the waiting time. If the first timer threshold is elapsed, then obviously it won't wait at all.
5. Check phase <br>
   This phase is dedicated for setImmediate() call backs.
6. Clock callbacks <br>
   Close type of callbacks (socket.on('close', () => {})) are handled here. More like a cleanup phase.
7. nextTickQueue & microTaskQueue (promises)
   Tasks in these two are not really part of event loop. They are called ASAP, whenever the boundary between C/C++ and JS is crossed. So they are supposed to be called right after currently running operation (not necessarily the current executing JS function callback)

## Workflow with examples
Hope you got an idea of how things are working. How a synchronous semi infinite while loop in C language is helping JavaScript to become asynchronous in nature. At a time, it is executing just one thing but still anything is hardly blocking.
Anyway, no matter how good we describe the theories, I believe we best understand things with examples. So let us understand the scenarios with some code snippets.

Snippet 1 - basic understanding
```
setTimeout(() => {
    console.log('setTimeout');
}, 0);
setImmediate(() => {
  console.log('setImmediate');
});
```

Can you guess the output of the above? Well, you may think setTimeout will be printed first, but it’s not something guaranteed. Why? That’s because after executing the main module when it will enter the timer phase, it may or may not find your timer exhausted. Again, why? Because, a timer script is registered with a system time and the delta time you provide. Now the moment setTimeout is called and the moment the timer script is written in the memory, may be a slight delay depending on your machine’s performance and the other operations (not node) running in it. Another point is, node sets a variable now just before entering the timer phase (on each iteration) and considers now as current time. Thus the exact calculation is a little bit buggy you can say. And that’s the reason of this uncertainty. Similar thing is expected if you try to execute the same code within a callback of a timer api (eg: setTimeout).

However, if you move this code in i/o cycle, it will give you a guarantee of setImmediate callback running ahead of setTimeout.

```
fs.readFile('my-file-path.txt', () => {
  setTimeout(() => {
    console.log('setTimeout');
  }, 0);
  setImmediate(() => {
    console.log('setImmediate');
  });
});
```

Snippet 2 - understanding timers better
```
var i = 0;
var start = new Date();
function foo () {
    i++;
    if (i < 1000) {
        setImmediate(foo);
    } else {
        var end = new Date();
        console.log("Execution time: ", (end - start));
    }
}
foo();
```

The example above is very simple. A function foo is being invoked using setImmediate() recursively till a limit of 1000. In my macbook pro with node version 8.9.1 it is taking 6 to 8 ms to get executed.
Now let’s change the above snippet with the following where I just changed the setImmediate(foo) with setTimeout(foo, 0).

```
var i = 0;
var start = new Date();
function foo () {
    i++;
    if (i < 1000) {
        setTimeout(foo, 0);
    } else {
        var end = new Date();
        console.log("Execution time: ", (end - start));
    }
}
foo();
```

Now if I run this in my computer it takes 1400+ ms to get executed.
Why it is so? They should be very much same as there are no i/o events. In both the cases the waiting time in poll will be zero. Still why taking this much time?
Because comparing time and finding out the deviation is a CPU intensive task and takes a longer time. Registering timer scripts also does take time. At each point the timer phase has to go through some operations to determine whether a timer is elapsed and the callback should be executed or not. The longer time in execution may cause more ticks as well. However in case of setImmediate, there are no checks. It’s like if callback is there in the queue, then execute it.

Snippet 3 - understanding nextTick() & timer execution

```
var i = 0;
function foo(){
  i++;
  if(i>20){
    return;
  }
  console.log("foo");
  setTimeout(()=>{
    console.log("setTimeout");
  },0);
  process.nextTick(foo);
}   
setTimeout(foo, 2);
```

What do you think the output of the function above should be? Yes, it will first print all the foos, then print setTimeouts. Cause after 2ms, the first foo will be printed which will invoke foo() again in nextTickQueue recursively. When all nextTickQueue callbacks are executed, then it will take care of others, i.e. setTimeout callbacks.

So is it like nextTickQueue is getting checked after each callback execution? Let’s modify the code a bit and see.
```
var i = 0;
function foo(){
  i++;
  if(i>20){
    return;
  }
  console.log("foo", i);
  setTimeout(()=>{
    console.log("setTimeout", i);
  },0);
  process.nextTick(foo);
}

setTimeout(foo, 2);
setTimeout(()=>{
  console.log("Other setTimeout");
},2);
```

I’ve just added another setTimeout to print Other setTimeout with same delay time as the starting setTimeout. Though it’s not guaranteed, but chances are after one foo print, what you will find in the console is Other setTimeout. That is because the similar timers are somehow grouped and nextTickeQueue check will be done only after the ongoing group of callback execution.
## Few common questions
1. Where does the javascript get executed?
As many of us had an understanding of event-loop being spinning in a separate thread and pushing callbacks in a queue and from that queue one by one callbacks are executed; people when first read this post may get confused where exactly the JavaScript gets executed.
Well, as I said earlier as well, there is only one single thread and the javascript executions are also done from the event loop itself using the v8 (or other) engine. The execution is completely synchronous and event-loops will not propagate if the current JavaScript execution is not completed.

2. Why do we need setImmediate, we have setTimeout(fn, 0)?
First of all this is not zero. It is 1. Whenever you set a timer with any value lesser than 1 or grater than 2147483647ms, it is automatically set to 1. So whenever you try to set SetTimeout with zero, it become 1.

3. setImmediate reduces the headache of extra checking as we already discussed. So setImmediate will make things faster. It is also placed right after poll phase, so any setImmediate callback invoked from a new incoming request will be executed soon.

4. Why setImmediate is called immediate?
Well, both setImmediate and process.nextTick has been named wrongly. Actually setImmediate phase is touched only once in a tick or iteration and nextTick is called as soon as possible. So functionally setImmediate is nextTick and nextTick is immediate. :P

5. Can JavaScript be blocked?
As we already have seen, nextTickQueue doesn’t have any limit of callback execution. So if you recursively call process.nextTick(), your program will never come out of it, irrespective of what all you have in other phases.

6. What if I call setTimeout in exit callback phase?
It may initiate the timer but the callback will never be called. Cause if node is in exit callbacks, then it has already came out of the event loop. Thus no question of going back and execute.

src: https://www.voidcanvas.com/nodejs-event-loop