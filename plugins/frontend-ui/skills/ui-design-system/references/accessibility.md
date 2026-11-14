# Accessibility details

## Contrast
- WCAG AA: 4.5:1 for body text, 3:1 for large text (≥ 24 px, or ≥ 18.66 px bold), and 3:1 for UI component boundaries and focus indicators.
- Test every foreground/background token pair in each theme and mode, in code, so a palette change cannot silently fail. Compute relative luminance per WCAG and assert the ratio in a unit test.
- Placeholder, disabled and "muted" text still need to be legible; disabled text is exempt from the rule but should not be invisible.

## Focus
- Never `outline: none` without a replacement. Use `:focus-visible` with a 2-3 px ring that has 3:1 contrast against adjacent colors.
- Move focus deliberately after route changes, dialog open (into dialog) and close (back to the trigger).
- Trap focus only inside modal dialogs; use the native `<dialog>` or a vetted primitive (Radix, React Aria).

## Semantics
- Use native elements: `<button>` for actions, `<a href>` for navigation, `<label for>`, `<fieldset>/<legend>`, `<table>` with headers for tabular data, heading levels in order, landmarks (`main`, `nav`).
- Custom widgets (tabs, combobox, menu) follow the WAI-ARIA Authoring Practices keyboard patterns. Prefer a headless library over hand-rolling.
- Live updates: `aria-live="polite"` for status, `role="alert"` for errors that need immediate attention.

## Motion
- Wrap non-essential animation in `@media (prefers-reduced-motion: no-preference)` or disable it under `reduce`. Replace large movement with a fade.
- Avoid flashing more than 3 times per second.

## Text and scripts
- Use `rem` for font sizes so OS and browser text scaling works. Test at 200%.
- Set `lang` on the document and on foreign-language spans so screen readers and hyphenation use the right rules.
- Don't disable zoom (`user-scalable=no`).

## Touch
- 48 dp (Android) / 44 pt (iOS) targets, at least 8 dp apart. Larger hit area than the visible icon via padding.
- Provide an alternative to gestures (swipe, drag, long-press).

## Testing
- Automated: axe in end-to-end tests catches roughly a third of issues. It does not replace manual checks.
- Manual: keyboard-only pass, 200% zoom, reduced motion on, one screen reader flow (VoiceOver or TalkBack), high-contrast mode.
