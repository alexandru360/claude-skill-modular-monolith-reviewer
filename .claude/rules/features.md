---
globs: ["src/features/**/*"]
---

# Feature Rule

## Structure

- Features live in `src/features/<name>/` — each owns its slice, API, hooks, components, tests, stories.
- Features must NOT import other features directly. Cross-feature communication via Redux only.
- This constraint is enforced by `eslint-plugin-boundaries` — a lint error means an architectural violation.

## Working conventions

- Non-trivial implementation should reference a feature-id, bug-id, or debt-id when available.
- Feature work should stay within one feature slice when possible.
- If a request spans multiple features, split the work before implementation.
