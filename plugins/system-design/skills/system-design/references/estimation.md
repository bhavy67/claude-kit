# Back-of-envelope numbers

Order-of-magnitude figures for estimating. Real systems vary; use them to find which design is plausible, then measure.

## Time
- 1 day = 86,400 s ≈ 10^5 s. **Requests per day ÷ 10^5 ≈ average requests per second.**
- Peak is commonly 2-10x average. Say which factor you assume.
- 1 month ≈ 2.6 × 10^6 s. 1 year ≈ 3.15 × 10^7 s.

## Latency (rough orders of magnitude)
| Operation | Order of magnitude |
|---|---|
| CPU cache / memory reference | ~1-100 ns |
| Read 1 MB sequentially from memory | ~10s of µs |
| SSD random read | ~10-100 µs |
| Round trip inside one datacenter | ~0.5 ms |
| Read 1 MB sequentially from SSD | ~100s of µs to ~1 ms |
| Disk seek (spinning) | ~5-10 ms |
| Round trip across a continent | ~50-100 ms |
| Round trip across oceans | ~100-200 ms |

Takeaways: memory ≫ SSD ≫ network ≫ spinning disk. A network call costs thousands of memory reads. Avoid chatty remote calls in loops.

## Size
- 1 KB = 10^3 B, 1 MB = 10^6, 1 GB = 10^9, 1 TB = 10^12 (use powers of ten for estimates).
- Typical row: 100 B - 1 KB. A tweet-sized text record ~ 300 B. A compressed web image ~ 100-500 KB.
- Storage = records × bytes per record × replication factor (commonly 3) × retention.

## Throughput (very rough, single modern node)
- A well-indexed relational database: thousands to low tens of thousands of simple queries/s.
- An in-memory cache (Redis-class): tens of thousands to 100k+ ops/s.
- A single app server: hundreds to thousands of requests/s for typical CRUD, depending on work per request.
If your peak is below these for one node, you do not need a distributed design yet.

## Availability
| Target | Downtime per year |
|---|---|
| 99% | ~3.65 days |
| 99.9% | ~8.8 hours |
| 99.99% | ~52 minutes |
| 99.999% | ~5 minutes |
Each extra nine costs disproportionately more. Ask what the product actually needs.

## Worked example
10M users, 20% active daily, 10 reads/user/day, 1 write/user/day.
- Reads/day = 2M × 10 = 20M → 20M ÷ 10^5 = **200 req/s average**, peak ~ 5x = **~1,000 req/s**.
- Writes/day = 2M → **~20 writes/s average**.
- Storage: 2M writes/day × 1 KB × 365 ≈ 730 GB/year raw, ×3 replication ≈ 2.2 TB/year.
Conclusion: one primary relational database plus a read replica or cache handles this. No sharding needed.
