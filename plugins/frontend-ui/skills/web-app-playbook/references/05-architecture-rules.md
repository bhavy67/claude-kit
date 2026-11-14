## 5. Architecture rules

### State
- **MUST: The URL is state** for anything shareable or refresh-worthy (search, filters, selected items, modes). Seed state from the URL **lazily in `useState(() => …)`**, then mirror back with `setSearchParams(…, { replace: true })`, preserving unrelated params.
  **[lesson]** The journey planner lost its result on refresh; shared links only worked via a button.
- **MUST:** Persisted user data (favourites, settings) goes through a tiny hook that wraps `localStorage` in `try/catch` and validates what it reads (old shapes, missing fields → sane defaults).
- **SHOULD:** Module-level caches for expensive one-time work (e.g. geolocation result, precomputed lookups) so navigating away and back is instant.
- **AVOID:** `setState` inside effects to "sync" values you could derive or initialise directly.

### Time, live data, animation
- **MUST:** One shared clock (`useSyncExternalStore` + one 1 s interval) for the whole app. Never a timer per component.
- **MUST:** 60 fps visuals (moving markers, progress) run in `requestAnimationFrame` and write to the DOM/SVG directly — **never re-render React per frame**.
- **SHOULD:** A dev-only time override (`?clock=HH:MM:SS&day=N`) for anything time-dependent. It makes edge cases (late night, first train, weekends) testable in seconds.

### Compute on device
- **SHOULD:** If the data is small and public, ship it and compute locally (routing, ETAs, nearest-X). Works offline, no server, no privacy surface.
- **MUST:** Benchmark hot paths. Rule of thumb: per-second work < 2 ms, per-frame work < 0.1 ms.

### Hooks order
- **MUST:** No early `return` before hooks. Resolve invalid params to a placeholder, run hooks, *then* redirect. **[lesson]** Lint caught conditional hooks in a page that redirected on bad IDs.

### Checklist
- [ ] Refresh any screen → same state
- [ ] Share any URL → recipient sees the same thing
- [ ] Storage blocked (private mode) → app still works
- [ ] No component owns its own interval
- [ ] Domain logic has tests; UI has none of it

---
