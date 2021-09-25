TCP/IP is the Internet protocol suite
It is the abstract layer for specifying how data should be packetized, adressed, transmitted, received.

TCP and UDP are main protocols of the Internet protocol suite, it's the protocol of Transport Layer of the TCP/IP

TCP provides reliable, ordered, error-checked delivery of a stream of bytes between applications
(Reliable protocol means it will notifies to the sender that the delivery of data is succesful or not)
TCP is connection-oriented, connection must be etablished before sending data => 3way handshake
In TCP, the two parties keep track of what they have sent by using a Sequence number


TCP vs UDP

* Ordered data transfer
* Retransmission of lost packets (sequence number)
* Error-free data transfer (checksum)
* Flow control (Limit the rate the sender transfer data) (Sliding window)
* Congestion control: lost packets trigger reduction in data delivery rate
