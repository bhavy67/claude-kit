## 6. Mobile UX rules

### Layout & viewport
- **MUST:** `<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">`
- **MUST:** Respect safe areas: `padding: env(safe-area-inset-top/bottom)` on fixed bars.
- **MUST:** Use `100dvh` / `min-h-[100dvh]`, never `100vh` (iOS URL bar jumps).
- **MUST:** No horizontal page scroll at 320 px. Test it; decorative glows must be clipped.
- **MUST:** Grid children that contain scrollers or long text get `min-width: 0` (`minmax(0,1fr)`). **[lesson]** Cards overflowed the right edge on mobile until this was added.
- **SHOULD:** Floating nav (top island on desktop, bottom dock on phones) over a single scroll container; give that container top/bottom padding equal to the bars + safe area.
- **[lesson] Sticky inside a padded scroll container:** `top` is measured from *inside* the padding. `top: 0` already sits below it — `top: <padding>` doubles it.

### Touch & interaction
- **MUST:** Tap targets ≥ 44×44 px. Make **whole rows/cards the link**, not just the text inside. **[lesson]** Departure rows had 23 px tap targets.
- **MUST:** Inputs ≥ 16 px font size (iOS zooms the page on focus otherwise).
- **MUST:** Press feedback (`:active` scale 0.97–0.98) on everything tappable.
- **MUST:** Back buttons go **back** (`navigate(-1)`) when there's in-app history, and to Home on a cold deep link (`location.key === 'default'`). **[lesson]** Back always went Home, losing context.
- **MUST:** A real **404 route** with a way out. **[lesson]** Unknown URLs rendered a blank black screen.
- **MUST:** Overlays (menus, sheets) close on Escape, trap/inert the background, and stop the page underneath from scrolling.
- **SHOULD:** Bottom sheets (drawers) for pickers and details on phones; centred max-width on desktop.
- **SHOULD:** Tell users *why* something failed and what still works ("Search needs a connection. Popular places below still work offline.").
- **SHOULD:** Don't offer silly options — e.g. suggest an auto/cab instead of a 50-minute walk.

### Accessibility
- **MUST:** Visible `:focus-visible` ring (2 px, offset 2 px, brand colour). Browser defaults vanish on dark themes. **[lesson]**
- **MUST:** Accessible name **contains the visible text** (axe `label-content-name-mismatch`). "Save" → `aria-label="Save to favourites"`, not "Add to favourites".
- **MUST:** `prefers-reduced-motion` turns animations into instant state changes.
- **MUST:** Colour is never the only signal (line colour + name, status colour + text).
- **SHOULD:** Bilingual/local-script labels where your users read them (e.g. Gujarati station names).

### Checklist
- [ ] 320 / 390 / 768 / 1024 / 1440 / 1920 screenshots reviewed
- [ ] No sideways scroll at any width
- [ ] Every interactive element reachable by keyboard with a visible ring
- [ ] axe: 0 violations on every route
- [ ] 404, offline, empty, error, and "no data right now" states designed

---
