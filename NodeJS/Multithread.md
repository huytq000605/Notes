# NodeJS "Multithread" support

## NodeJS is single-threaded runtime. Good because of event loop can handle asynchronous non-blocking IO. Bad at doing CPU-intensive task.

## Solutions that Nodejs provide
- Child processes
- Cluster
- Worker threads

## Child Proceses
- https://nodejs.org/api/child_process.html
- **spawn()**: New processes that have their own memory, method spawns the child process asynchronously, without blocking the Node.js event loop.
- **fork()**: New NodeJS process and invokes a specified module with an IPC communication.
- No child to child communication
- Use separate processes => consume resources

## Worker threads
- https://nodejs.org/api/worker_threads.html
- Worker threads vs child process is like processes vs threads
- They do share memory by transferring ArrayBuffer instances or sharing SharedArrayBuffer instances.
- Redirect stdin, stdout, stderr to parent thread
- Can create worker istances inside worker
- Parent can stop child at any point by using **worker.terminate()**
- Communicate with each other (even parent) by using **Message Port**

## Cluster
- Built on top of child_process module
- Is an Http server, use **fork()**, so they can communicate through IPC with parent



