# Consideration before caching

## Context

When we decided to cache something, the next thing is where do we cache it?

The most common answer is to use Redis.

Let's think about it again
What's the extactly thing do we want?

I work with ATS service, it need to call GRPC to Feature Flag(FF) Service for each request.
That makes each request increases response time about 200-300ms (for network - number based on monitor system)
So I want to decrease the response time of our service, then decided to cache it, and my mindset automatically choose Redis for the question where?

But then I realize I didn't improve what I want. Why?

## Details

- Quoting a long comment from the discussion that answer all my questions:
```
It really depends on the situation and the models we are following. Caching with Redis is not a silver bullets. In some use cases, it is a perfect fit. In other use cases, it is a disaster.

For example, in Rails view, when a view rendering is costly (report or something) that requires hundred of DB queries, using Redis to cache based on a suitable cache key is a perfect solution. All the web servers share the same DB, so, the reports look the same whatever web instance a user is viewing. When the report changes, the cache key should change and the cache is invalidated automatically and a new cache is generated. Using local cache in this key is not optimal, because it requires generating multiple caching snapshot of the same set of data in each web instance, and that is costly. Moreover, a user can rotate between the web instances, so most of the time, he should miss the cache.

In our use case, I'm solving the redundant calls of the same session. In a same request, Feature Flag service can be hit multiple times (dozen or so). Half or even more then them are duplicated from the previous call in the same request. Therefore, when applying this local cache, I'm sure that the cache hit ratio are extremely high. Moreover, multiple RPC requests with the same params are extremely unlikely to change within the same session and usually change between sessions of the same user. Therefore, the result of RPC calls are one-time use, no need so share between the web instances.

If I use Redis for caching, in each request, I would end up adding a new key in Redis in each request, because the cache key is not able to generate from the caller because it has no idea about data changes in Feature Flag service. In addition, as I mentioned above, latency is a huge deal breaker here. Calling to Redis is actually calling via networking. In our deployment model, a web instance can be in a zone, like 2a; while redis is in a zone like 2c. The latency between them is not zero (up to 1 - 10ms). So, let's think this scenario:

- Request to Redis to get cache
- Cache hit. Use the data from cache
- Request to Redis to get cache (other call, other params)
- Cache missed. Call to FF service to get data

The number of requests to external services (Redis and FF) will increase, at most double the number of requests, and at least the same number of requests in case all cache are hit (extremely rare). So, using Redis here doesn't solve anything. Instead, it decreases the performance of the system, waiting for both Redis and gRPC, instead of plain gRPC. And each gRPC call is really cheap, even cheaper than Redis. I would rather use call gRPC.

We can actually use Redis to cache, but at server side of Feature Flag service. At that case, we are reducing the number of hit to DB, not the number of gRPC requests. And that's a totally different issue.
```

So to summarize:

- ATS Service POV:
  - It doesn't difference than before, but also worse (when we miss cache, we need to make 2 network call)

- FF Service POV:
  - Since it's the overload service at our company, every services are calling it. So I have release some load for it.

- Solution:
  - Replace Redis with In-memory caching sounds like a perfect usecase here

