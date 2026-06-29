# Theming Rule

## Dark/Light Mode Support

- All UI components MUST support both light and dark mode (`data-mode="light"` / `data-mode="dark"`).
- Never use hardcoded colors (hex, rgb, hsl). Use CONNECT semantic tokens exclusively (`bg-surface-*`, `text-content-*`, `border-*`, etc.).
- When adding new visual elements, verify they render correctly in both themes before marking work as done.
- Use `data-mode` attribute toggling — no ThemeProvider or CSS-in-JS theme objects.
- Test contrast ratios in both modes — text must remain readable against its background in light and dark.
- Shadows, overlays, and elevation effects must adapt to the active mode via semantic tokens, not static values.
- Icons and illustrations should use `currentColor` or semantic tokens to adapt to theme automatically.
