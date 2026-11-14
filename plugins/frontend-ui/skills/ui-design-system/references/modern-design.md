# Modern design notes

Principles for making an interface feel considered. Adapt to the product, do not copy a trend.

## Type
- One family is often enough; two at most. Variable fonts give weight range with one file.
- Scale with a ratio (1.2-1.333) and keep to 5-7 sizes. Body 16 px minimum on mobile.
- Large weight contrast (e.g. 700 headings, 400 body) reads as hierarchy. Tighten line-height as size grows (headings ~1.1-1.25, body ~1.5).
- Use tabular numerals for columns of numbers and times.

## Color
- Start from one brand hue. Build a 10-step ramp; pick surface, border, text and accent from it.
- Tint neutrals slightly toward the brand hue instead of pure gray.
- Semantic colors (success, warning, danger, info) are separate from brand and always paired with an icon or label.
- Define dark mode explicitly: slightly desaturated accents, surfaces lighter as elevation increases, no pure black on pure white glare.

## Space and shape
- 4/8-point spacing, bigger gaps between groups than within groups.
- One radius family (e.g. 8 for controls, 16 for cards) used consistently. Shadows or borders for separation, rarely both.
- Density is a setting for data-heavy products (compact / comfortable).

## Motion
- 150-250 ms for small state changes, 250-400 ms for larger transitions, ease-out for entering and ease-in for leaving.
- Animate `transform` and `opacity` only, they stay off the main thread layout path.
- Use the View Transitions API or a layout-animation library for shared-element and list reorder animations when supported, with graceful fallback.
- Anime.js, Motion (Framer Motion) or CSS keyframes are fine; do not add an animation library for effects CSS can do.

## Components
- Prefer an accessible primitive layer (Radix, React Aria, Base UI) styled by tokens. `shadcn/ui` follows this pattern: you own the component source. See the `shadcn` skill.
- Build the empty, loading, error and long-content version of each component before the happy path is polished.

## Avoid
- Gradients, glassmorphism and large shadows used everywhere by default.
- Icon-only buttons without a label or tooltip for non-universal icons.
- Placeholder text as the only label.
- Carousels that hide primary content, modals for things that could be a page.
- Fixed pixel layouts, hardcoded colors, text embedded in images.
