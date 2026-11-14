---
name: database-design
description: Database design and review for PostgreSQL/MySQL and MongoDB: schema, constraints, indexes, query plans, transactions, migrations, pagination, document modeling. Use when creating tables or collections, writing migrations, fixing slow queries, or choosing SQL vs NoSQL.
---

# Database design

Default to a relational database (PostgreSQL) as the system of record. Choose a document store when the data is naturally read and written as one aggregate and the access patterns are known.

## Schema (relational)
- Model the domain first, normalize to the point where each fact lives once, denormalize deliberately for a measured read problem.
- Enforce rules in the database: `NOT NULL`, `UNIQUE`, `CHECK`, foreign keys. Application checks alone have races.
- Types: `timestamptz` in UTC (never naive timestamps), `numeric` or integer minor units for money (never floats), `uuid` or `bigint` identity for keys, `text` over arbitrary-length `varchar` in PostgreSQL.
- Soft delete only when the product needs it. If so, include the deleted flag in unique indexes (partial unique index).
- Name consistently: snake_case, plural table names, `<table>_id` foreign keys.

## Indexes
- Index foreign keys, columns used in `WHERE`, `JOIN` and `ORDER BY` for hot queries. Don't index everything, each index slows writes and uses memory.
- Composite index order: equality columns first, then range or sort column. An index on `(a, b)` serves `a` and `a, b`, not `b` alone.
- Partial indexes for subsets (`WHERE deleted_at IS NULL`); covering indexes (`INCLUDE`) to avoid table lookups.
- **Check with `EXPLAIN (ANALYZE, BUFFERS)`** on realistic data. Look for sequential scans on big tables, bad row estimates, sorts spilling to disk.
- In PostgreSQL create indexes on live tables with `CREATE INDEX CONCURRENTLY`.

## Queries
- N+1: loading a list and then querying per row. Fix with a join, `IN (...)`, or the ORM's eager loading. Look for it in any loop that touches the DB.
- Select only needed columns. Paginate with keyset (`WHERE (created_at, id) < (?, ?) ORDER BY created_at DESC, id DESC LIMIT n`), not large `OFFSET`.
- Push aggregation to the database. Move rarely changing expensive aggregates to a materialized view or a summary table.

## Transactions and concurrency
- Wrap multi-statement changes that must succeed together in a transaction; keep them short, no network calls inside.
- PostgreSQL defaults to read committed. For check-then-act races use a unique constraint, `SELECT … FOR UPDATE`, or `INSERT … ON CONFLICT`, not application-level checks.
- Optimistic concurrency with a `version` column when users edit the same record.
- Use a connection pool and size it to the database, not to the number of app instances times a big default. Put a pooler (e.g. PgBouncer) in front when you have many app instances.

## Migrations
- Versioned, in the repo, applied automatically in CI/CD. Never edit a migration that has shipped; add a new one.
- Make them safe to deploy while the old code runs: **expand → migrate/backfill → contract**. Add nullable column → deploy code that writes both → backfill in batches → add constraint/switch reads → remove old column in a later release.
- Adding a `NOT NULL` column with a default, creating indexes, and changing types can lock or rewrite big tables. Check the behavior for your version and test on production-sized data.
- Every migration that adds a table also adds its grants/policies/indexes in the same migration.
- Backups are only real if restores are tested.

## MongoDB / document modeling
- Model by **access pattern**. Embed data read together and bounded in size; reference data that is shared, large or changes independently.
- Avoid unbounded arrays (documents have a 16 MB limit and large arrays hurt updates). Use a separate collection or bucket pattern.
- Index to match queries: follow **Equality → Sort → Range** for compound indexes. Verify with `explain("executionStats")`.
- Use schema validation (`$jsonSchema`) for the fields that must be right. Multi-document transactions exist but cost more; design to keep related writes in one document.
- Decide on write concern and read preference deliberately for data you can't lose.

## SQL or NoSQL?
Ask: do I need joins and strong integrity across entities (→ relational)? Is the data a self-contained aggregate with flexible shape and a horizontal-scale need (→ document)? Unsure → relational. See `system-design:system-design` references for the trade-off table.

## Review checklist
- [ ] Constraints and types enforce the rules
- [ ] Hot queries have an index and a checked plan
- [ ] No N+1, bounded results, keyset pagination
- [ ] Migration is backward compatible and reversible or clearly one-way
- [ ] Transactions short; races handled by constraints or locks
- [ ] Money, time, ids use correct types
