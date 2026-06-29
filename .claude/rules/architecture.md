---
globs: ["src/**/*"]
---

# Architecture Rule

- Respect existing module boundaries unless the task explicitly includes redesign.
- Prefer small, local changes over cross-cutting edits.
- For cross-module changes, explain impact before implementation.
- Record non-trivial architecture decisions in an ADR or design note.
- Do not introduce new framework-level abstractions without clear repetition or pain.
