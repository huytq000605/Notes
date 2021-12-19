# Transaction Isolation Levels

- Dirty Read – A Dirty read is the situation when a transaction reads a data that has not yet been committed. For example, Let’s say transaction 1 updates a row and leaves it uncommitted, meanwhile, Transaction 2 reads the updated row. If transaction 1 rolls back the change, transaction 2 will have read data that is considered never to have existed.

- Non Repeatable read – Non Repeatable read occurs when a transaction reads same row twice, and get a different value each time. For example, suppose transaction T1 reads data. Due to concurrency, another transaction T2 updates the same data and commit, Now if transaction T1 rereads the same data, it will retrieve a different value. (Example: S1 Read, S2 Modify, S1 Read again (in same trans) => different data)

- Phantom Read – Phantom Read occurs when two same queries are executed, but the rows retrieved by the two, are different. For example, suppose transaction T1 retrieves a set of rows that satisfy some search criteria. Now, Transaction T2 generates some new rows that match the search criteria for transaction T1. If transaction T1 re-executes the statement that reads the rows, it gets a different set of rows this time. (Example: S1 Read, S2 Insert, S1 Read => get more datas)


1. Read Uncommitted – Read Uncommitted is the lowest isolation level. In this level, one transaction may read not yet committed changes made by other transaction, thereby allowing dirty reads. In this level, transactions are not isolated from each other.

2. Read Committed – This isolation level guarantees that any data read is committed at the moment it is read. Thus it does not allows dirty read. The transaction holds a **read or write lock** on the current row, and thus prevent other transactions from **reading, updating or deleting it**.

Start Trans => Read Data => Wait 1 Min => Read Data again => Do not know how current data vs previous read (not repeatable read)

3. Repeatable Read – This is the most restrictive isolation level. The transaction holds **read locks on all rows it references** and **writes locks on all rows it inserts, updates, or deletes**. Since other transaction cannot read, update or delete these rows, consequently it avoids non-repeatable read.

Start Trans => Read Data => Wait 1 Min => Read Data again => Ensure get data from previous read (can also have new data => phantom read)

4. Serializable – This is the Highest isolation level. A serializable execution is guaranteed to be serializable. Serializable execution is defined to be an execution of operations in which concurrently executing transactions appears to be serially executing.

Start Trans => Read Data => Wait 1 Min => Read Data again => Ensure get data from previous and prevent inserting new data

# Rollback work

If you start an explicit transaction, perform some updates, and then roll back, InnoDB restores the original state of data. It preserves the original data by storing it in an area of the database called the rollback segment. So if you roll back, it just re-copies those pages of data to replace the ones you changed.

# Optimistic Locking

- Prevent other requests from writing data by using a version_row in database.
- Read => get version. Modify => check version => if it's dirty => cancel.

# Permistic Locking

- Prevent other requests from reading & writing data until finish.
- Careful for deadlocks.