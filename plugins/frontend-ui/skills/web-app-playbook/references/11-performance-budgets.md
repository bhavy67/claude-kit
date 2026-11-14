## 11. Performance budgets

| Metric | Budget |
|---|---|
| Main JS (gzip) | ≤ 200 KB (heavy features lazy-loaded) |
| Lighthouse mobile | Performance ≥ 90 · Accessibility 100 · Best Practices 100 · SEO 100 |
| First Contentful Paint (mobile, simulated) | ≤ 2.5 s |
| Total Blocking Time | ≤ 100 ms |
| CLS | 0 |

- **MUST:** Lazy-load route-level heavy deps (maps, charts, editors) with `React.lazy` + `Suspense`.
- **MUST:** Measure, don't guess: build with sourcemaps and sum bytes per package; measure a library's real cost by building a one-line entry that imports it.
- **MUST:** Compare Lighthouse runs **on the same server type**. **[lesson]** A test server without compression made a faster build look 20 points slower.
- **SHOULD:** Remove unused dependencies from `package.json`, not just imports.

---
