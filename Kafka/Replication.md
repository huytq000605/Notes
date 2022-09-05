# Replication

## Kafka use Pull-based architecture, that means followers keep sending fetch request to the leader

## ISR (In-sync Replica)
- ISR contains all followers that are still up to date with the leader.
- We need a way to commit the offset on leaders.
- When the followers send request to the leader with their current offset, the leader can decided that all followers have been caught up at that offset then commit at that offset by high watermark
## Leader Epoch
- Is included in each record, for data reconciliation

## Leader failover
- Elect a new leader from ISR
- Leader increases epoch by 1, all followers need to do data reconciliation based on last leader epoch & offset.