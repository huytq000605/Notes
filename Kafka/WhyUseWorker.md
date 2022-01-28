# Inmemory vs Put to Redis 

## Issue: There are some consumers stuck at an offset

When a consumer reconnect to consumer group, Kafka send all msgs in batches to the consumer and a session timeout.
If the consumer cannot consume all the msg in session timeout, it raises the error again and again (infinity loop)

Solution:
- Msg = Put message into redis worker => (Note: Sidekiq doesn't hold the original order)
- Increase session timeout
