# Process

## ID
- Each Process have an unique identifier called pid (process id) and its parent ppid (parent process id).
- We can see all processes and their pid by command `ps`, detail about a process by `ps -p <pid>`.

## File Descriptors
- Everything is a file (including devices, pipes, sockets, etc.)
- File descriptors are **NOT** shared between unrelated processes, they live and die with the process they are bound to.
- Every Unix process comes with three open resources. These are your standard input (STDIN), standard output (STDOUT), and standard error (STDERR).

## Environment
- Every process has name, environment variables, arguments, edit code

## Fork
- When forking a process, we create a new process with `ppid` is `pid` of the parent process.
- The child process inherits a copy of all of the memory in use by the parent process, as well as any open file descriptors belonging to the parent process.
- The child processes would be free to modify their copy of the memory without affecting what the parent process has in memory (Copy on Write mechanism).

## Copy on Write
- A parent process and a child process will actually share the same physical data in memory until one of them needs to modify it
- This is a big win when using fork as it saves on resources. It means that fork is fast since it doesn’t need to copy any of the physical memory of the parent. 
- It also means that child processes only get a copy of the data they need, the rest can be shared.

## Wait
- Map to `waitpid`
- We dont need to worry about race condition between parent and child, kernel queues up status information about child processes that have exited.
- Example:
``` ruby
# We create two child processes.
2.times do
  fork do
    # Both processes exit immediately.
    abort "Finished!"
  end
end

# The parent process waits for the first process, then sleeps for 5 seconds. 
# In the meantime the second child process has exited and is no 
# longer running.
puts Process.wait
sleep 5

# The parent process asks to wait once again, and amazingly enough, the second
# process' exit information has been queued up and is returned here.
puts Process.wait
```
- To not waste kernel resources (by keeping status information), we can detach the process. There's no system call for it. We could implement it as:
``` ruby
  def detach(pid)
    # The evented system does not need a loop
    Thread.new { Process.wait pid }
  end
```

## Signal
- Signals are asynchronous communication. When a process receives a signal from the kernel it can do one of the following:
1. Ignore the signal
2. Perform a specified action
3. Perform the default action
- Your process can receive a signal anytime. That’s the beauty of them! They’re asynchronous.
- Your process can be pulled out of a busy for-loop into a signal handler, or even out of a long sleep. Your process can even be pulled from one signal handler to another if it receives one signal while processing another

## Communication
- Pipes and Socket
- A pipe is a uni-directional stream of data. One process can ‘claim’ one end of it and another process can ‘claim’ the other end. Then data can be passed along the pipe but only in one direction
- A socket pair provides bi-directional communication. The parent socket can both read and write to the child socket, and vice versa.

## Spawn
- Is `fork` + `execve`
- `execve` allows you to replace the current process with a different process.
- The fork + exec combo is a common one when spawning new processes. execve is a very powerful and efficient way to transform the current process into another one; the only catch is that your current process is gone. That’s where fork comes in handy.
- At the OS level, a call to `execve` doesn’t close any open file descriptors by default. In a specific language implementation, it may.
- We can pass file descriptior through and new process can still use it in the specific language implementation context.
