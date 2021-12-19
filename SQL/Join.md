# Join

## 3 Joins:

- Example: SELECT * FROM A.C_id = B.C_id

1. Nested Loop
    - Loop through Table1
    - Loop through Table2 for each row in Table1
    - Matched => new row
    - Cost: O(m*n) with m is A's size, n is B's size
    - Optimize: Index col C_id in table B => O(m * log(n))

2. Hash Join
    - Hash all rows of B by B.C_id as key
    - Scan through A and check if row.C_id in hash table => new row
    - Cost: O(m+n)
    - Must hash all rows of B

3. Merge Join
    - Sort both A and B by C_id
    - Do merge like merge sort
    - Cost: O(m + n + sort_cost)
    - Optmize: Index so sort_cost = 0


4. Compare

| Nested Loop      | Hash Join | Merge Join |
| :---        |    :----:   |          ---: |
| 2nd Table has index on joined fiend to have cost = O(m*log(n))       | Must hash all rows in 1 table       | Good if both tables have index so no sort cost|
| Available for all kinds of join   | Only equality        | Only equality |
| | Perform on memory | Perform on disk
