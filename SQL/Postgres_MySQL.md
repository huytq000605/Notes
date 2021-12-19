# Postgres vs MySQL

## MySQL uses InnoDB, different index to Postgres. 
- Each row in InnoDB have only 1 clustered index (point to disk), all next index point to others index.
- All indexes point to row in disk
- When row changes, Postgres takes more cost to do it because it need to rebuild all indexes
- When row changes, MySQL just need to rebuild the index point to real data in disk
- When reading from MySQL, need to read from indirect indexes
- When reading from Postgres, read directly from index to disk

## Postgres supports more index type

## Becareful with creating indexes for columns in postgres
- How often are the columns updated
- Size of indexes


## Update/Delete
- When update/delete in postgres, it actually delete the row, and create a new role, updating all the indexes
- Postgres uses node_live_tuple, and node_dead_tuple, use **vacuum** to clear node_dead_tuple (note with vacuum: only delete information, so it can reuse space from that. If want to really delete, use **vacuum full**)
- When update/delete in mysql, it just modify the data