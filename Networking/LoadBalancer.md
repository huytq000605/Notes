# Load Balancer

## L4 Load Balancer
- Traditional way:
  - Client make a request
  - LB receives, selects a backend, makes request to that backend
  - LB receives response from backend, foward it to client
- Operates only at the level of the L4 TCP/UDP connection.
- Make sure that bytes from the same session wind up at the same backend

## Example for L4 vs L7
- L4 load balancing is simple and still sees wide use. What are the shortcomings of L4 load balancing that warrant investment in L7 (application) load balancing? Take the following L4 specific case as an example:

  - Two gRPC/HTTP2 clients want to talk to a backend so they connect through an L4 load balancer.
  - The L4 load balancer makes a single outgoing TCP connection for each incoming TCP connection, resulting in two incoming and two outgoing connections.
  - However, client A sends 1 request per minute (RPM) over its connection, while client B sends 50 requests per second (RPS) over its connection.
  - In the previous scenario, the backend selected to handle client A will be handling approximately 3000x less load then the backend selected to handle client B! This is a large problem and generally defeats the purpose of load balancing in the first place

## L7 Load Balancer
- L7, described by the OSI model, encompasses multiple discrete layers of load balancing abstraction:
  - Optional Transport Layer Security (TLS). Note that networking people argue about which OSI layer TLS falls into. For the sake of this discussion we will consider TLS L7.
  - Physical HTTP protocol (HTTP/1 or HTTP/2).
  - Logical HTTP protocol (headers, body data, and trailers).
  - Messaging protocol (gRPC, REST, etc.).
