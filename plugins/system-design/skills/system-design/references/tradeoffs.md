# Trade-off cheat sheet

Use as prompts for "what do I give up?", not as answers.

## SQL vs document store (NoSQL)
- **Relational (PostgreSQL, MySQL)**: strong consistency, joins, constraints, transactions, flexible ad-hoc queries. Default choice. Scales vertically a long way, reads via replicas.
- **Document (MongoDB)**: fits data read and written as one aggregate, flexible schema, easy horizontal sharding. Costs: weaker cross-document integrity, joins are awkward, data duplication to serve queries.
- **Key-value / cache (Redis)**: speed, simple structures. Not a system of record unless configured and justified.
- Choose by **access patterns and consistency needs**, not by hype. Mixed is fine: relational as source of truth, cache or search index as derived views.

## Caching
- Patterns: cache-aside (app reads cache, falls back to DB, then fills cache), write-through, write-behind. Cache-aside is the simplest default.
- Costs: staleness, invalidation bugs, cold-start stampedes (mitigate with request coalescing, TTL jitter), memory.
- Cache read-heavy, expensive, slowly changing data. Do not cache what you cannot invalidate.
- Layers: browser/CDN → app memory → shared cache → DB. Each layer multiplies the staleness questions.

## Synchronous vs asynchronous
- **Sync request/response**: simple, immediate errors. Couples availability and latency of services.
- **Queue / events**: absorbs bursts, retries, decouples. Costs: at-least-once delivery means duplicates (make consumers idempotent), ordering limits, harder debugging, eventual consistency visible to users.

## Consistency
- Strong: reads see the latest write. Simpler for users, limits availability or latency across regions.
- Eventual: replicas converge. Needs a product answer for the gap (stale read, retry, optimistic UI).
- CAP only bites during a network partition: choose between consistency and availability *then*. Normal operation is a latency vs consistency trade-off.

## Scaling
- **Vertical** first: cheap in complexity. **Horizontal** app tier is easy if stateless (sessions in a store or signed tokens).
- Database: indexes → query fixes → read replicas → caching → partitioning/sharding last (shard keys are hard to change; hot partitions).
- Load balancing: round-robin or least-connections; health checks; connection draining.
- Rate limiting: token bucket or sliding window, per user/IP/key; return 429 with `Retry-After`.

## Reliability
- Timeouts everywhere. Retries only for idempotent operations, with exponential backoff and jitter, and a cap, otherwise retries amplify outages.
- Circuit breakers and bulkheads stop one slow dependency from exhausting threads or connections.
- Backups are only real if restores are tested. State RPO (data you can lose) and RTO (time to recover).

## Monolith vs services
- Modular monolith: one deploy, clear internal boundaries, easy transactions. Best default for small teams.
- Services: independent deploy and scaling, per-team ownership. Costs: network failure modes, distributed transactions, operational overhead, versioned contracts.
- Split along a real seam (different scaling profile, team, or release cadence), never to look modern.
