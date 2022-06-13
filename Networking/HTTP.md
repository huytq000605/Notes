# Hyper text transfer protocol
- The protocol that web server and web client use to communicate with each other over Internet
- Generally use TCP connection to communicate with server (require reliable connection)

- stateless: (old, modern is stateful)
    - after the request from client is serviced by client, the connection is disconnected
    - each request is independently
    - why: maintaining a connection is resource intensive

- connectionless:
    - before sending request, client must establish connection with server
    - after request was served, connection is destroyed
    - reason: server resource should be shared equally by all clients.    

# Web works
- Parse the URL (protocol, resource (page))
- Check HSTS (Http Security Transport) List, if not in HSTS List. first HTTP request will get response https or not
- DNS (Browser, OS, Router, ISP's DNS Server recursive search for Root nameserver, top-level nameserver...)
- TLS Handshake
- Get Page (HTML), parse html and get CSS / JS

# TLS Handshake
- Client sends Client Hello to Server, includes Max TLS Version client support, cipher suites, client random
- Server sends Server Hello to Client, includes SSL certificate (Server's PK),  TLS version, Cipher Suites choosen, server random
- If (EDH) Digital Signature (set of previous msgs encrypted with server's SK to confirm is sending from server), Key Exchange(DH),
* (Use both RSA and DH because of if only use RSA then if later have SK, can read all msgs)
- Client verify certificate (RSA or Diffie Hellman) => pre-master secret
- Both generates session key from pre-master, server random and client random to prevent replay attack
