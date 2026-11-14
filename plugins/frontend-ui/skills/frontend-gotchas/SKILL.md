---
name: frontend-gotchas
description: Real frontend bugs that recur in React/Next.js/Tailwind/Radix apps: flex and grid overflow, dialogs taller than the viewport, icon-only buttons without names, static-export limits, pnpm 11 install-script blocks. Use when building layouts, dialogs, responsive buttons, Next static exports, or when pnpm install fails on build scripts.
---

# Frontend gotchas

Each item: symptom, cause, fix. Check the relevant one before writing similar code.

## Layout
**Flex/grid item overflows instead of truncating or wrapping.** A flex or grid item's default `min-width` is `auto`, so it won't shrink below its content. Long unbreakable text (titles, file names, tags) widens the page past the viewport. `truncate` on a descendant does nothing if any ancestor up to the flex/grid boundary hasn't set `min-w-0`; each nesting level needs it. Numbered Tailwind `grid-cols-N` already uses `minmax(0, 1fr)` and is safe; a bare `grid` with an implicit single column is not. Fix: `min-w-0` on the item and each wrapper. Test with names far longer than your fixtures: short seed data never triggers it.

**Dialog taller than the viewport.** A dialog centered with `top-50% translate-y-[-50%]` and no max height renders past both edges, with the close button unreachable (short screens, soft keyboard open, many items). Fix in the base component: `max-h-[85vh] overflow-y-auto` (or `85dvh`) so every dialog inherits it. Components that set their own overflow (command palettes) need their own check.

## Accessibility
**Icon-only responsive buttons.** The `hidden sm:inline` label pattern leaves an icon with no accessible name below the breakpoint. Put `aria-label` on the button itself, or swap in short fallback text (`sm:hidden` → "Sort") instead of hiding the label.

## Components
**Radix `asChild` / `Slot`** needs exactly one React element child. "React.Children.only expected…" means something extra (text, fragment, two nodes) is inside.
**One toast host.** Style the toaster once in the providers file; a second instance duplicates toasts.
**Hand-written DB types must be `type` aliases, not `interface`.** PostgREST/Supabase generics require `Record<string, unknown>`; only type aliases get the implicit index signature. An interface silently turns every query result into `never`.

## Next.js static export (`output: "export"`)
Used when the same build ships to a CDN and into a native shell, so nothing may need a server at request time.
- No dynamic `[id]` routes for ids that exist only on-device. Use `?id=` and build links with one helper.
- No `searchParams` in server components. Read them client-side with `useSearchParams()` inside `<Suspense>`.
- Metadata routes and route handlers need `export const dynamic = "force-static"`; no `runtime = "edge"`.
- `headers()` in `next.config` is ignored by a static export; set headers in the host config (e.g. `vercel.json`).
- Newer Next versions can differ from what you remember. If the repo ships bundled docs (e.g. `node_modules/next/dist/docs/`), read the relevant guide before writing code and heed deprecation notices.

## pnpm 11
Install scripts are blocked by default for supply-chain safety. `ERR_PNPM_IGNORED_BUILDS` after adding a native package (`sharp`, `esbuild`, `unrs-resolver`) means: add it to `allowBuilds` and `onlyBuiltDependencies` in `pnpm-workspace.yaml`, then reinstall. If pnpm re-runs install before every `dev`/`build` and trips the same error, set `verify-deps-before-run=false` in `.npmrc`.

## Dev servers
`EADDRINUSE`: find the owner (`lsof -ti:3000`) before killing it. Give end-to-end tests their own port, configurable by env var, so they don't collide with `dev`.

## Data layer rule worth copying
Features import one `data` module, never a vendor SDK. New operations go in the interface first, then in every implementation (real and mock). The mock is what tests and first-run demos use, and it makes swapping the backend a second implementation, not a rewrite.
