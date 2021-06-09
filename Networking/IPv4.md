IPv4 uses 32-bit adress space, each 8 bit separate by "."

The popular one for LAN Network is IPv4/24. The number "24" refers to how many first bits are containted in the network. The number of bits left is for address space. That means every network has the 24 first bits is local to each other (call Network Identifier).

Example for IPv4/24: 
- 192.168.6.84
- 192.168.6.30

The subnet mask used for IPv4/24 is 255.255.255.0((24)1(8)0, 11111111111111111111111100000000), the IP AND Bit Mask = same first bits.

Because these networks have the same 24 first bits (192.168.6) so these are local.

Usually, the address space "1" is for default gateway, default gateway is the server that routing for all the local networks (DHCP), if some nodes in this network dont know where to send the package, it will send to the default gateway.

The adress space "255" is for broadcast, every node in the local network can listen to this address

The default gateway needs to connect directly (physical) to another default gateway => internet nodes