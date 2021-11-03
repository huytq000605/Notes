# Transaction Isolation Levels

1. Read Uncommitted – Read Uncommitted is the lowest isolation level. In this level, one transaction may read not yet committed changes made by other transaction, thereby allowing dirty reads. In this level, transactions are not isolated from each other.

2. Read Committed – This isolation level guarantees that any data read is committed at the moment it is read. Thus it does not allows dirty read. The transaction holds a read or write lock on the current row, and thus prevent other transactions from reading, updating or deleting it.

3. Repeatable Read – This is the most restrictive isolation level. The transaction holds read locks on all rows it references and writes locks on all rows it inserts, updates, or deletes. Since other transaction cannot read, update or delete these rows, consequently it avoids non-repeatable read.

4. Serializable – This is the Highest isolation level. A serializable execution is guaranteed to be serializable. Serializable execution is defined to be an execution of operations in which concurrently executing transactions appears to be serially executing.

# Rollback work

If you start an explicit transaction, perform some updates, and then roll back, InnoDB restores the original state of data. It preserves the original data by storing it in an area of the database called the rollback segment. So if you roll back, it just re-copies those pages of data to replace the ones you changed.
