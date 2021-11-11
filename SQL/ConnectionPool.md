# Connection Pool and Single Connection

## Database connections are costly, heavy to create and maintain by database server.

## Single connection means that we are using only 1 shared connection between all queries.
- When the user make a query, the application creates a connection to database and execute the query, then close the connection.
- The application will create a new connection for next query => slow, wasted resources.
- Query have to be simple, otherwise it will block all the other queries

## Connection pool
- A connection can be **active** connection or **available** connection
- When application requests to DB, if the pool has available connection, assign it to application
- If the pool doesn't have any available connection, create new connection and assign to the application as active connection
- After execute, the connection returns to the pool as available connection
- If a connection is corrupted, it will be removed from the pool
- When the maximum number of connections is exceeded => the newly arrived requests will be halted until a connection is avaiable

## Pool Sizing
[Original Post](https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing)

### Limited Resources

It is not quite as simple as stated above, but it's close. There are a few other factors at play. When we look at what the major bottlenecks for a database are, they can be summarized as three basic categories: CPU, Disk, Network. We could add Memory in there, but compared to Disk and Network there are several orders of magnitude difference in bandwidth.

If we ignored Disk and Network it would be simple. On a server with 8 computing cores, setting the number of connections to 8 would provide optimal performance, and anything beyond this would start slowing down due to the overhead of context switching. But we cannot ignore Disk and Network. Databases typically store data on a Disk, which traditionally is comprised of spinning plates of metal with read/write heads mounted on a stepper-motor driven arm. The read/write heads can only be in one place at a time (reading/writing data for a single query) and must "seek" to a new location to read/write data for a different query. So there is a seek-time cost, and also a rotational cost whereby the disk has to wait for the data to "come around again" on the platter to be read/written. Caching of course helps here, but the principle still applies.

During this time ("I/O wait"), the connection/query/thread is simply "blocked" waiting for the disk. And it is during this time that the OS could put that CPU resource to better use by executing some more code for another thread. So, because threads become blocked on I/O, we can actually get more work done by having a number of connections/threads that is greater than the number of physical computing cores.

How many more? We shall see. The question of how many more also depends on the disk subsystem, because newer SSD drives do not have a "seek time" cost or rotational factors to deal with. Don't be tricked into thinking, "SSDs are faster and therefore I can have more threads". That is exactly 180 degrees backwards. Faster, no seeks, no rotational delays means less blocking and therefore fewer threads [closer to core count] will perform better than more threads. More threads only perform better when blocking creates opportunities for executing.

Network is similar to disk. Writing data out over the wire, through the ethernet interface, can also introduce blocking when the send/receive buffers fill up and stall. A 10-Gig interface is going to stall less than Gigabit ethernet, which will stall less than a 100-megabit. But network is a 3rd place runner in terms of resource blocking and some people often omit it from their calculations.

### The Formula
- The formula below is provided by the PostgreSQL project as a starting point, but we believe it will be largely applicable across databases. You should test your application, i.e. simulate expected load, and try different pool settings around this starting point:

**connections = ((core_count * 2) + effective_spindle_count)**

```
A formula which has held up pretty well across a lot of benchmarks for years is that for optimal throughput the number of active connections should be somewhere near ((core_count * 2) + effective_spindle_count). 

Core count should not include HT threads, even if hyperthreading is enabled. Effective spindle count is zero if the active data set is fully cached, and approaches the actual number of spindles as the cache hit rate falls. ... There hasn't been any analysis so far regarding how well the formula works with SSDs.
```

- Guess what that means? Your little 4-Core i7 server with one hard disk should be running a connection pool of: 9 = ((4 * 2) + 1). Call it 10 as a nice round number. Seem low? Give it a try, we'd wager that you could easily handle 3000 front-end users running simple queries at 6000 TPS on such a setup. If you run load tests, you will probably see TPS rates starting to fall, and front-end response times starting to climb, as you push the connection pool much past 10 (on that given hardware).

### Axiom: You want a small pool, saturated with threads waiting for connections.
- If you have 10,000 front-end users, having a connection pool of 10,000 would be shear insanity. 1000 still horrible. Even 100 connections, overkill. You want a small pool of a few dozen connections at most, and you want the rest of the application threads blocked on the pool awaiting connections. If the pool is properly tuned it is set right at the limit of the number of queries the database is capable of processing simultaneously -- which is rarely much more than (CPU cores * 2) as noted above.

- We never cease to amaze at the in-house web applications we've encountered, with a few dozen front-end users performing periodic activity, and a connection pool of 100 connections. Don't over-provision your database.

### "Pool-locking"
The prospect of "pool-locking" has been raised with respect to single actors that acquire many connections. This is largely an application-level issue. Yes, increasing the pool size can alleviate lockups in these scenarios, but we would urge you to examine first what can be done at the application level before enlarging the pool.

The calculation of pool size in order to avoid deadlock is a fairly simple resource allocation formula:

   ```pool size = Tn x (Cm - 1) + 1```

Where Tn is the maximum number of threads, and Cm is the maximum number of simultaneous connections held by a single thread.

For example, imagine three threads (Tn=3), each of which requires four connections to perform some task (Cm=4). The pool size required to ensure that deadlock is never possible is:

   ```pool size = 3 x (4 - 1) + 1 = 10```

Another example, you have a maximum of eight threads (Tn=8), each of which requires three connections to perform some task (Cm=3). The pool size required to ensure that deadlock is never possible is:

   ```pool size = 8 x (3 - 1) + 1 = 17```

This is not necessarily the optimal pool size, but the minimum required to avoid deadlock.