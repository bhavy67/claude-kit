---
name: ui-design-system
description: Build or review UI with a token-based design system, accessibility, responsive layout, motion and modern visual quality. Use when designing screens or components, setting up design tokens or theming and dark mode, reviewing UI for accessibility, or when an interface looks generic.
---

# UI design system

Two jobs: make the interface **consistent** (tokens, components) and **good** (hierarchy, accessibility, restraint). If the project has approved designs or a brief, build to them and do not invent new visual patterns. For distinctive aesthetic direction on new designs, also use Anthropic's `frontend-design` skill (see the repo README).

## Principles

1. **One primary question per screen.** Decide what the user opened it for and answer it in one glance. Details on tap.
2. **Hierarchy before decoration.** Size, weight, spacing and contrast carry meaning. Use at most two type families and a small scale.
3. **Design for the weakest user**: older people, small budget phones, slow networks, large text, one hand, bright sun.
4. **Plain language.** No internal jargon in labels. Technical terms go in help text.
5. **Motion explains.** Animate state changes (enter, exit, reorder). Never animate for decoration. Respect reduced motion.
6. **Dark mode is designed, not inverted.** Check elevation, contrast and images separately.
7. **States are part of the design:** empty, loading, error, offline, partial, long text, huge numbers. Skeletons for first load, no spinners for cached data.
8. **Show trust where it matters:** explain how a number was calculated, let users report a mismatch, make data export one tap.

## Tokens (three layers)

- **Primitive**: raw values (`blue-600`, `space-4`). 
- **Semantic**: meaning (`color-text-muted`, `color-surface-raised`, `color-danger`).
- **Component**: per-component decisions (`button-primary-bg`) that reference semantic tokens.
- Components consume **semantic or component tokens only**. No raw hex, no px font sizes, no ad-hoc durations or shadows in component code.
- Themes and dark mode swap token values. They never add per-component overrides.
- Tap targets use a min-size token (≥ 48 dp / 44 pt), not spacing-derived heights.
- Need a value that is not a token? Add it to the token file deliberately, with a contrast check, instead of hardcoding.
- Unit-test contrast for every text/background pair in both modes. See `references/accessibility.md`.

## Layout

- Mobile first, single column; add a second column when width allows (list + detail). Use fluid type and spacing (`clamp()`), container queries for components that live in different widths.
- Spacing on a 4 or 8 point scale. Align to a grid. Whitespace groups things; prefer it to borders.
- Cap line length (~60-75 characters) for reading text.
- Make scripts with tall glyphs (Devanagari, Gujarati and others) work: check line-height, font fallback, and clipping. Self-host and subset fonts.
- Format dates, numbers and times at the UI edge with `Intl.*` and an explicit time zone. Components don't compute domain data.
- All user-facing strings go through i18n. No concatenated sentences; allow text 30-50% longer.

## Accessibility checklist (every screen and component)

- [ ] Works at 200% text size without clipping or horizontal scroll
- [ ] Tap targets ≥ 48 dp, with spacing between them
- [ ] WCAG AA contrast (4.5:1 text, 3:1 large text and UI parts) in light **and** dark
- [ ] Meaning never conveyed by color alone (add text or icon)
- [ ] `prefers-reduced-motion` respected; no auto-playing motion over 5 s without a pause control
- [ ] Fully keyboard operable, visible focus ring, logical order, no traps
- [ ] Correct semantics first (`button`, `a`, `label`, headings, landmarks); ARIA only to fill gaps
- [ ] Form fields have labels, errors are announced and tied to the field
- [ ] Images have alt text or are marked decorative
- [ ] Tested with a screen reader on one real flow

## Modern visual quality, quickly

Generic UI usually has: default fonts, uniform spacing, gray-on-gray, shadows on everything, and one flat weight. Fix by:
- choosing a deliberate type pairing and scale, with strong weight contrast between headings and body;
- a restrained palette: one brand color, neutral ramp with slight tint, semantic colors for status;
- consistent radius and elevation system, used sparingly;
- real content in designs (long names, empty states), not lorem ipsum;
- one memorable detail (illustration style, motion, layout rhythm) instead of many small effects.
See `references/modern-design.md`.

## Review output

When reviewing UI, list findings as: **Blocker** (accessibility failure, broken state, raw values bypassing tokens) · **Should fix** · **Polish**, each with the location and a concrete fix.
