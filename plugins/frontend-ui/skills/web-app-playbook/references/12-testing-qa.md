## 12. Testing & QA

### Layers
1. **Unit (Vitest):** every pure function in `src/lib`. Fixtures are tiny hand-built networks/datasets with known answers.
2. **Data guards:** tests that fail if data goes wrong (unique IDs, coordinates within N km of the network, required fields present). **[lesson]** Curated place coordinates were up to 11 km off; a guard now prevents regressions.
3. **Reference cross-check:** for algorithms (routing, pricing), write a slow, obviously-correct reference and compare across *all* inputs. (14,310 station pairs × 5 times → 0 mismatches.)
4. **E2E (production build):** drive real Chrome via the DevTools Protocol (CDP).
5. **Audits:** axe on every route; Lighthouse mobile; offline run; CSP run.

### E2E rules
- **MUST:** Run against `vite build && vite preview` (or a Vercel-like server with real headers), not the dev server.
- **MUST:** For every route × widths `[320, 390, 768, 1024, 1440, 1920]`, record: page exceptions, console errors, failed requests, elements overflowing the viewport, redirects.
- **MUST:** Script the core user flows with real clicks/typing (setup, search, save, share, reload-persistence, back navigation, offline).
- **MUST:** Edge cases: unknown URL, bad IDs, before/after service hours, weekend schedule, empty states, same origin/destination, offline search.

### Headless browser gotchas **[lesson]**
- Desktop Chrome has a ~500 px minimum window width → use **CDP `Emulation.setDeviceMetricsOverride`** (with `mobile: true`) for phone widths, not `--window-size`.
- `--virtual-time-budget` freezes CSS animations mid-way → entrance animations look "missing". Use real-time waits.
- Cross-origin iframes in headless throttle animations → don't use iframe harnesses for screenshots.
- `--force-prefers-reduced-motion` renders final states for layout checks.
- Always add a global timeout to scripts and kill stray headless Chromes; hung instances block later runs.

### Checklist
- [ ] Unit + data-guard tests green, coverage on `src/lib` ≥ 80 %
- [ ] Every route × width: 0 exceptions, 0 console errors, 0 overflow
- [ ] Core flows pass on the production build
- [ ] axe 0 · Lighthouse budgets met · offline works · CSP clean

---
