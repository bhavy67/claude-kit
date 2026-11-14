## 4. Project structure

```
/
├─ WEB_APP_RULES.md          ← this file
├─ index.html                ← theme-color, viewport-fit=cover, color-scheme
├─ vite.config.ts            ← PWA manifest + workbox + define() build stamps
├─ vercel.json               ← SPA rewrite + security headers + cache headers
├─ public/
│  ├─ .well-known/assetlinks.json   ← Android ownership proof (TWA)
│  ├─ robots.txt
│  └─ icons (192, 512, maskable-512, apple-touch, favicon.svg)
├─ scripts/                  ← data build + icon generation (node/bun CLIs)
├─ android/                  ← Bubblewrap project (keystore git-ignored)
├─ components/               ← shared UI primitives (Bezel, Button, Drawer…)
├─ design-concepts/          ← kept HTML design explorations (reference only)
└─ src/
   ├─ lib/<domain>/          ← PURE logic + *.test.ts (no React, no DOM)
   ├─ hooks/                 ← useX(): storage, clock, geolocation, network
   ├─ features/<area>/       ← screens + their components
   │  └─ shell/              ← AppShell, nav, footer, 404, privacy, back button
   ├─ data/generated/        ← build output of scripts/ (committed, small)
   └─ index.css              ← tokens + component classes + keyframes
```

**Rules**
- **MUST:** Domain logic lives in `src/lib`, is pure, and is unit-tested. UI never re-implements it.
- **MUST:** Generated data is produced by a script, never hand-edited, and records its **source + effective date**.
- **SHOULD:** One component per file; colocate small helpers; no barrel files.
- **SHOULD:** Keep design explorations (`design-concepts/`) in the repo — they're the visual reference when extending the UI.

---
