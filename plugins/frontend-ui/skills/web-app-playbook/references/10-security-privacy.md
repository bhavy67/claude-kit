## 10. Security & privacy

### Headers (`vercel.json`, applies to all routes)
```json
{ "key": "Content-Security-Policy", "value": "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob: https://tiles.example.org; font-src 'self' data:; connect-src 'self' https://tiles.example.org https://api.example.org; worker-src 'self' blob:; manifest-src 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; frame-ancestors 'none'" },
{ "key": "X-Content-Type-Options", "value": "nosniff" },
{ "key": "Referrer-Policy", "value": "strict-origin-when-cross-origin" },
{ "key": "Permissions-Policy", "value": "geolocation=(self), camera=(), microphone=(), payment=(), usb=()" },
{ "key": "X-Frame-Options", "value": "DENY" }
```
- **MUST:** **Test the CSP before shipping** on a server that applies the real headers (a 30-line Node server reading `vercel.json` works). Browse every route and collect violations. **[lesson]** Vite inlines assets < 4 KB as `data:` URLs — a font got blocked until `font-src data:` was added. MapLibre needs `worker-src blob:`.
- **MUST:** Verify the built `index.html` has no inline scripts before using `script-src 'self'`.
- **MUST:** Cache headers: `/assets/*` immutable for a year; `sw.js`, `index.html`, `manifest.webmanifest` `max-age=0, must-revalidate`.
- **MUST:** `robots.txt` as a real file (otherwise the SPA rewrite serves HTML and SEO audits fail).

### Privacy
- **MUST:** Before writing the privacy page, grep the code for every `fetch`, external URL, `localStorage` key, and analytics SDK. The page lists exactly those.
- **MUST:** Location used on-device only → say so plainly; never send it anywhere you don't name.
- **SHOULD:** Contact via the repo's Issues page instead of publishing a personal email.
- **SHOULD:** Keep a comment at the top of the privacy component: "if you add a network call, storage key or analytics, update this page".

---
