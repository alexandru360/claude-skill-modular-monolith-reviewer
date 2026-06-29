# Security Rule (Project-Specific)

## Injection Prevention

- NEVER interpolate runtime strings into XML/HTML that will be parsed.
- `loadFromString` accepts only raw `file.text()` content — never constructed strings.
- Error states → `setError(message)` store action, not synthesized markup.

```ts
// BLOCKED
loadFromString(`<LXFML><Error>${message}</Error></LXFML>`);

// CORRECT
useLxfmlLoaderStore.getState().setError(message);
```
