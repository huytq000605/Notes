- SQL: Relational Database store data in tables are formed in row & column
- NoSQL: Key-value, graph, document

# Schema
- SQL: fixed
- NoSQL: dynamic
- Details: 
  - The main arguments in favor of the document data model are schema flexibility, better performance due to locality (receive all), and that for some applications it is closer to the data structures used by the application. The relational model counters by providing better support for joins, and many-to-one and many-to-many relationships.
# Querying
- SQL: uses SQL (structured query language)
- NoSQL: UnQL (unstructured query language).

# Scalability
- SQL: vertically scalable. Hard to horizontally scale
- NoSQL: horizontally scalable.
# Reliability or ACID Compliancy (Atomicity, Consistency, Isolation, Durability)
- SQL: ACID compliant
- NoSQL: sacrifice ACID compliance for performance and scalability.
# Simpler application code
- If the data in your application has a document-like structure (i.e., a tree of one-to-many relationships, where typically the entire tree is loaded at once), then it’s probably a good idea to use a document model.
- The poor support for joins in document databases may or may not be a problem, depending on the application. For example, many-to-many relationships may never be needed in an analytics application that uses a document database to record which events occurred at which time
- For highly interconnected data, the document model is awkward, the relational model is accept‐able, and graph models are the most natural