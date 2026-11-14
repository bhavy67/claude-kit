## 3. Default stack

| Layer | Default | Notes |
|---|---|---|
| Build | **Vite** | Fast, first-class PWA plugin. |
| UI | **React + TypeScript (strict)** | React Compiler on if available. |
| Styling | **Tailwind v4** + CSS custom properties for tokens | Tokens on `:p`; utilities for layout. |
| Components | **shadcn/ui on Base UI or Radix** | Copy-in components you own; restyle the primitives once. |
| Routing | **React Router** | URL is state (see §5). |
| Icons | **Tabler / Phosphor** (tree-shaken) | One family, one stroke weight. |
| PWA | **vite-plugin-pwa** (Workbox, `generateSW`) | `registerType: 'autoUpdate'`. |
| Maps (if needed) | **MapLibre GL** + **OpenFreeMap** tiles | Free, no API key. See §9. |
| Tests | **Vitest** (+ happy-dom) | Unit-test all domain logic. |
| Lint | **oxlint** (or ESLint) | Zero errors before merge. |
| Hosting | **Vercel** (custom domain) | `vercel.json` for headers + SPA rewrites. |
| Android | **Bubblewrap (TWA)** | §13. |
| Package manager | Whatever the repo's lockfile says | **[lesson]** Don't create a second lockfile — use `npx bun …` if the repo uses `bun.lock` and bun isn't installed. |

**AVOID** adding: animation libraries for simple transitions, state-management libraries before you have shared state pain, date libraries for one format, UI kits you'll fight.

---
