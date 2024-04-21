# Kqueue/Kevent & Netpoll

## Kqueue/Kevent
- Create Kqueue and listen events through Kevent syscall.
- In the Netpoll codebase, they call Kevent with no filter and later call Kevent non-blocking to change the filter.
- Usually we use only 1 Kqueue for a computer, but incase we have 40+ Cores, should consider using more Kqueue.

## Netpoll
Underlying, [Netpoll](https://github.com/cloudwego/netpoll) is using Kqueue & Kevent to handle IO operations
Learnt from implementation:
- The difference between Netpoll and std net is Netpoll will handle all events in an event loop - like libuv. So when it comes to application, it doesn't need to handle IO with connection but only data in memory
- By default, Netpoll uses a goroutine pool (underlying using sync.Pool) for handling connections
- The benefit of the pool is to reuse goroutine between connections which lower the pressure to the GC (The use case they mentioned is that "net.Conn has no API to check Alive, so it is difficult to make an efficient connection pool for RPC framework, because there may be a large number of failed connections in the pool")
- The impl as follows: Each connection is corresponding to 1 task, for each task, create a worker in pool (= goroutine) => if the connection is done, move the worker to another task.

