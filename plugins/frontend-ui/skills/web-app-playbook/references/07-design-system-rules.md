## 7. Design system rules

- **MUST:** All colours are **tokens on `:root`** (background, foreground, card, border, primary, destructive, live/success, plus brand/category colours). Components never hard-code hex — except places that can't read CSS (SVG filters, generated icons), which import a single constants map.
- **MUST:** Dark mode is a **token swap**, not a second stylesheet. If the product is dark-only by design, say so in `index.html` (`color-scheme: dark`, `class="dark"`, `theme-color`).
- **MUST:** Animate only `transform` and `opacity`. One easing curve for the whole app (e.g. `cubic-bezier(0.32,0.72,0,1)`).
- **MUST:** `backdrop-filter` only on fixed/sticky elements, never on scrolling content (mobile GPU death).
- **SHOULD:** CSS for UI motion (keyframes, transitions, sliding indicators). For equal-width tabs, slide the indicator with `translateX(index * 100%)`; for variable widths, measure in `useLayoutEffect` and write to the element directly.
- **SHOULD:** A small set of reusable surface classes (`.bezel`, `.surface`, `.glass`, `.pill-btn`) instead of repeating 15 utilities everywhere.
- **SHOULD:** Explore 2–3 genuinely different design directions as standalone HTML first (`design-concepts/`), pick one, then implement. Cheap to compare, keeps the winner as reference.
- **AVOID:** Generic fonts (Inter/Roboto/Arial) for a brand you want remembered; pick a display + body + mono trio and self-host via `@fontsource` (works offline).
- **AVOID:** Showing internal/dev data in the UI (build IDs, cache epochs). Put diagnostics one tap away (an "About" sheet), not on the home screen. **[lesson]**

### Naming the product
- **SHOULD:** The name says what it is and where (e.g. *MetroNow*). Abstract names (*Pulse*) read as unrelated categories. **[lesson]**
- **MUST NOT:** Use an official body's name/logo alone for an unofficial app (store impersonation policy). Say "unofficial" in the listing and privacy page.
- **SHOULD:** Check the name isn't an existing app in your category and not an obvious trademark.

---
