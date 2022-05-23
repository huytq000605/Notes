# Concurrency Parttern Web server

## Process per connection
- How it work:
  - A connection comes in to the server.
  - The main server process accepts the connection.
  - It forks a new child process which is an exact copy of the server process.
  - The child process continues to handle its connection in parallel while the server process goes back to step #1.
- Trade off:
  - \+ Simplicity, there are no edge cases to look out for, no locks or race conditions, just simple separation.
  - \- There’s no upper bound on the number of child processes it’s willing to fork. For a small number of clients this won’t be an issue, but if you’re spawning dozens or hundreds of processes then your system will quickly fall over
  - \- Forking is not a cheap operation

## Thread per connection
- How it work:
  - Same with `Process per connection` but using thread instead
- Trade off:
  - \+ Simplicity, since each thread accepts a seperate connection => no locks or race condition.
  - \+ Threads are lighter on resources, hence there can be more of them
  - \- Still, there's no upper bound on the number of thread => overwhelmed context switch

## Preforking
- How it work:
  - Main server process creates a listening socket.
  - Main server process forks a horde of child processes.
  - Each child process accepts connections on the shared socket and handles them independently.
  - Main server process keeps an eye on the child processes.
- Trade off:
  - \+ This pattern prevents too many processes from being spawned, because they’re all spawned beforehand.
  - \- More processes means that your server will consume more memory. Processes don’t come cheap. Given that each forked process gets a copy of everything, you can expect your memory usage to increase by up to 100% of the parent process size on each fork.

## Thread pool
- How it work:
  - Same with `Perforking` but using thread instead
- Trade off:
  - \+ More concurrency compare to preforking (thread is light weight compared to process)
  - \+ In programming languages like Ruby, JS, Python, there's GIL, so preforking can bring better parallelism.

## Evented (Reactor)
- How it work: (It’s at the core of libraries like Node.js, Nginx, and others)
  - The server monitors the listening socket for incoming connections.
  - Upon receiving a new connection it adds it to the list of sockets to monitor.
  - The server now monitors the active connection as well as the listening socket.
  - Upon being notified that the active connection is readable the server reads a chunk of data from that connection and dispatches the relevant callback.
  - Upon being notified that the active connection is still readable the server reads another chunk and dispatches the callback again.
  - The server receives another new connection; it adds that to the list of sockets to monitor.
  - The server is notified that the first connection is ready for writing, so the response is written out on that connection.
- Trade off:
  - \+ Handle extremely high levels of concurrency, numbering in the thousands or tens of thousands, of concurrent connections.
  - \- However, given that all this concurrency is happening inside a single thread, there’s one very important rule to follow: never block the Reactor
