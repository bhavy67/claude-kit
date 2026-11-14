---
name: supabase
description: Supabase conventions: migrations with RLS and grants, auth redirect URLs, storage upload progress, typed queries. Use when writing Supabase migrations or policies, setting up auth or sign-up emails, handling uploads, or debugging "permission denied for table" and otp_expired errors.
---

# Supabase

## Migrations: every new table needs RLS **and** a grant
RLS policies decide which rows a role may touch. They do not decide whether the role may touch the table at all; that is a separate privilege. Without a grant, every query fails `permission denied for table …` however correct the policies are. Hosted Supabase's default privileges on `public` only cover tables created by `supabase_admin` (the dashboard editor). Migrations run as `postgres` and get none of that.

For each `create table` in the same migration:
1. `alter table … enable row level security;`
2. policies for each operation the app uses (`select`, `insert`, `update`, `delete`), scoped by `auth.uid()`
3. `grant select, insert, update, delete on … to authenticated;` (and `service_role` where needed). Never grant to `anon` unless the data is public.
4. indexes for foreign keys and policy columns (policies run per row).

It is easy to get right in the first migration and forget in the tenth. Check every time.

## RLS habits
- Default deny. Write the narrowest policy that works; test as a normal user, not as the owner or service role.
- Use `(select auth.uid())` in policies so it is evaluated once per statement, not per row.
- The `service_role` key bypasses RLS. Keep it server-side only, never in a client bundle.

## Auth setup (before the first real sign-up)
A new project's **Site URL defaults to `localhost:3000`**, and confirmation emails build their link from it. Skipping it gives a first sign-up whose link redirects to localhost and reports `otp_expired`, which looks like an expired link but is an unreachable redirect. In the dashboard (Authentication → URL Configuration) set Site URL to the real origin and add `<origin>/**` and any preview/native origins to Redirect URLs. Also pass `emailRedirectTo` explicitly in `signUp()` so each environment is correct once on the allow list.

## Storage
- `storage.upload()` uses fetch and reports no progress, so a large file sits at 0% then jumps to done. For progress, request a signed upload URL and `PUT` it via `XMLHttpRequest` (which emits `upload.onprogress`).
- Private buckets + policies on `storage.objects` scoped by path prefix (e.g. `<user_id>/…`). Serve with short-lived signed URLs.

## Types and queries
- Generate types (`supabase gen types typescript`) or hand-write them as `type` aliases, never interfaces (see `frontend-ui:frontend-gotchas`).
- Select only the columns you need; paginate with keyset ranges; use RPC/Postgres functions for multi-step atomic work instead of several client round trips.

## Local workflow
Develop against the local stack (`supabase start`), keep migrations in the repo, apply to remote through CI or `supabase db push`, never edit a shipped migration. Check the project's security advisors after schema changes.
