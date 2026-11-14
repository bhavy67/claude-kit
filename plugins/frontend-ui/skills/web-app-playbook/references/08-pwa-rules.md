## 8. PWA rules

### Manifest (via vite-plugin-pwa)
```ts
manifest: {
  id: '/',                       // stable identity
  name: 'AppName — What it is',  // full name
  short_name: 'AppName',         // ≤ 12 chars, shows under the icon
  description: '…',
  start_url: '/', scope: '/', display: 'standalone',
  theme_color: '#050507', background_color: '#050507',
  lang: 'en-IN', dir: 'ltr',
  categories: ['travel', 'navigation'],
  icons: [
    { src: '/pwa-192x192.png', sizes: '192x192', type: 'image/png', purpose: 'any' },
    { src: '/pwa-512x512.png', sizes: '512x512', type: 'image/png', purpose: 'any' },
    { src: '/pwa-maskable-512x512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
  ],
  shortcuts: [/* 2–4 deep links to top tasks */],
  // NO `orientation` lock if the layout is responsive. [lesson]
}
```
- **MUST:** Icons generated from one source mark by a script (`scripts/generate-icons.ts`) — any + maskable (content in the inner 72–80 %) + apple-touch + favicon.

### Service worker & updates
- **MUST:** `registerType: 'autoUpdate'`, `navigateFallback: '/index.html'`, precache app shell + data.
- **MUST:** An "update ready" banner, plus periodic `registration.update()` (on interval, on tab visible, on reconnect). Installed apps are *resumed*, not reloaded — without this, phones sit on old builds for weeks.
- **MUST:** A **cache epoch** ("big red button"): a number in a JSON file that, when bumped, renames Workbox caches and makes clients purge on boot. Plus a user-facing **"Clear cache & reload"**.
- **MUST:** Runtime-cache third-party assets you depend on offline (map tiles, styles, fonts) with `CacheFirst` + expiration.
- **MUST:** Offline banner when `navigator.onLine` is false — and features that need the network say so in place.

### Install UX
- **MUST:** Android/desktop: capture `beforeinstallprompt`, show an Install button.
- **MUST:** **iOS has no install prompt.** Detect iOS and show a 2-step "Share → Add to Home Screen" guide behind the same button. **[lesson]** The button was invisible on every iPhone.
- **MUST:** On phones, the install button is visible in the top bar — not buried in a menu. **[lesson]**
- **SHOULD:** In dev, force the button visible so it can be styled.

### Checklist
- [ ] Lighthouse installable; manifest has id/start_url/scope/maskable icon
- [ ] Airplane mode → reload → core features work
- [ ] New deploy → "update ready" appears on an open installed app
- [ ] Cache epoch bump purges old clients
- [ ] iOS shows install guide; Android shows native prompt

---
