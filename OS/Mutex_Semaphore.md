# Mutex and Semaphore

- Definition:
  - Mutex
    1. Is a key to a toilet. One person can have the key - occupy the toilet - at the time. When finished, the person gives (frees) the key to the next person in the queue.
    2. Officially: "Mutexes are typically used to serialise access to a section of re-entrant code that cannot be executed concurrently by more than one thread. A mutex object only allows one thread into a controlled section, forcing other threads which attempt to gain access to that section to wait until the first thread has exited from that section"
  - Semaphore
    1. Is the number of free identical toilet keys. Example, say we have four toilets with identical locks and keys. The semaphore count - the count of keys - is set to 4 at beginning (all four toilets are free), then the count value is decremented as people are coming in. If all toilets are full, ie. there are no free keys left, the semaphore count is 0. Now, when eq. one person leaves the toilet, semaphore is increased to 1 (one free key), and given to the next person in the queue.
    2. Officially: "A semaphore restricts the number of simultaneous users of a shared resource up to a maximum number. Threads can request access to the resource (decrementing the semaphore), and can signal that they have finished using the resource (incrementing the semaphore)."

- Mechanism 
  - Mutex is a locking mechanism used to synchronize access to a resource. 
  - Semaphore is signaling mechanism (“I am done, you can carry on” kind of signal)


- Mutex vs Binary Semaphore
The mutex is similar to the principles of the binary semaphore with one significant difference: the principle of ownership.
Ownership is the simple concept that when a task locks (acquires) a mutex only it can unlock (release) it.
If a task tries to unlock a mutex it hasn’t locked (thus doesn’t own) then an error condition is encountered and, most importantly, the mutex is not unlocked.
If the mutual exclusion object doesn't have ownership then, irrelevant of what it is called, it is not a mutex.
