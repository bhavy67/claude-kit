---
name: api-design
description: Conventions for designing and reviewing REST APIs and their Node/Express or FastAPI implementation: resources, status codes, errors, pagination, idempotency, auth, validation, rate limiting. Use when adding or reviewing endpoints, error handling, auth or API contracts.
---

# API design

Apply when writing a new endpoint or reviewing one. Be consistent with the existing API first, these rules second.

## Resources and methods
- Nouns, plural, lowercase: `/orders`, `/orders/{id}/items`. Verbs only for true actions: `POST /orders/{id}/cancel`.
- `GET` safe, no side effects. `PUT` replace, `PATCH` partial update, `DELETE` remove. `PUT` and `DELETE` must be idempotent.
- Make `POST` retry-safe where duplicates hurt (payments, orders): accept an `Idempotency-Key` header, store the key with the result, return the stored result on replay.
- Don't leak storage: expose stable public ids, not auto-increment ids if enumeration is a risk.

## Status codes
`200` ok · `201` created (+ `Location`) · `204` no body · `400` malformed request · `401` not authenticated · `403` authenticated but not allowed · `404` not found (also for resources the caller must not know exist) · `409` conflict (duplicate, version mismatch) · `422` valid syntax, invalid semantics (pick 400 or 422 for validation and use it everywhere) · `429` rate limited (+ `Retry-After`) · `5xx` our fault. Never return `200` with an error body.

## Errors
One error shape across the whole API. Prefer RFC 9457 problem details (`application/problem+json`):
```json
{ "type": "https://example.com/errors/validation", "title": "Invalid input", "status": 422,
  "detail": "email must be a valid address", "errors": [{ "field": "email", "message": "invalid" }],
  "requestId": "req_123" }
```
Never expose stack traces, SQL, or internal hostnames. Log them server-side with the same `requestId`.

## Collections
- Pagination: **cursor/keyset** for large or changing lists (`?limit=50&cursor=…`, stable sort with a unique tiebreaker). Offset only for small, static lists, it gets slower and skips or repeats rows as data changes.
- Always cap `limit` server-side. Allow-list filter and sort fields.
- Return the total only if it is cheap or required.

## Concurrency and caching
- Optimistic concurrency: return `ETag` (or a `version` field), require `If-Match` on updates, answer `412` or `409` on mismatch.
- Use `Cache-Control` and `ETag` for read endpoints that can be cached.

## Validation and boundaries
- Validate all input at the edge against a schema (zod, valibot, Pydantic). Reject unknown fields or ignore them deliberately.
- Keep route handlers thin: parse → call a service → map the result. Business rules live in services, not in handlers or SQL strings built from input.
- Always use parameterized queries or the ORM's binding. Never concatenate input into SQL or Mongo operators.

## Auth
- AuthN: short-lived access tokens, rotating refresh tokens stored server-side or in `HttpOnly` `Secure` `SameSite` cookies. Sessions are simpler than JWTs for first-party web apps and can be revoked instantly. Use JWTs when you need stateless verification across services, and accept slower revocation.
- Passwords: Argon2id or bcrypt via a vetted library. Never roll your own crypto.
- **AuthZ on every object access**: check that *this caller* may touch *this record*, in the service layer, not only that they are logged in. Missing object-level checks is the most common serious API bug.
- Rate limit login and expensive endpoints per user and IP. Lock out or slow repeated failures.
- Secrets in environment or a secret manager, never in the repo or the client bundle.

## Node / Express
- Central error-handling middleware; wrap async handlers (or use Express 5 which forwards rejected promises). One place maps errors to the response shape above.
- Don't block the event loop: no sync filesystem or heavy CPU work in request handlers; use a worker or queue.
- `helmet`, a body size limit, CORS with an explicit origin allow-list, request timeouts.
- Graceful shutdown: stop accepting, finish in-flight requests, close pools.

## FastAPI
- Pydantic models for request and `response_model` for output, so internal fields never leak.
- Use `async def` only with async I/O libraries. A blocking call inside `async def` stalls every request; use plain `def` (runs in a threadpool) or an async driver.
- Dependencies (`Depends`) for auth, DB sessions and pagination params. Raise `HTTPException` or custom handlers mapped to the error shape.
- Configure settings with `pydantic-settings`, not scattered `os.environ`.

## Operations
- Every request gets an id, logged on every line and returned in errors.
- `/health` (process up) and `/ready` (dependencies ok) separate.
- Version when you must break a contract (`/v2` or a header). Prefer additive changes: new optional fields, never repurpose fields.
- Document with OpenAPI generated from the code, and keep examples current.

## Review checklist
- [ ] Right method, status code, one error shape
- [ ] Input validated; output filtered to a response schema
- [ ] Object-level authorization present and tested
- [ ] Pagination capped; filters allow-listed
- [ ] Retry-safe where duplicates hurt
- [ ] No secrets or internals in responses or logs
- [ ] Tests cover success, validation failure, unauthorized, forbidden, not found
