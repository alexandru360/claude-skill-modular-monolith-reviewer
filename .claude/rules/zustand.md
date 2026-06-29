---
globs: ["**/store*.ts", "**/use*.ts", "**/use*.tsx"]
---

# Zustand Rule

## Store State Design

- Store state types MUST use discriminated unions — never combine a status field with nullable data fields.
- Impossible states (e.g. `{ status: 'ready', document: null }`) must not be representable.

```ts
// WRONG
interface StoreState {
    status: 'idle' | 'loading' | 'ready' | 'error';
    data: Data | null;
    error: string | null;
}

// CORRECT
type StoreState =
    | { status: 'idle' }
    | { status: 'loading' }
    | { status: 'ready'; data: Data }
    | { status: 'error'; error: string };
```

## Hook Subscriptions

- When selecting multiple fields from a store, use `useShallow` from `zustand/react/shallow` — never multiple individual selectors.
- Multiple `useStore(s => s.field)` calls create separate subscriptions — risks batching issues (one `setState` that changes N fields may trigger N re-renders instead of 1), inconsistent intermediate state between subscriptions, and poor scalability.
- For a single primitive selector (`useStore(s => s.status)`), `useShallow` is unnecessary — `===` comparison is sufficient and `useShallow` adds overhead.

```ts
// WRONG — separate subscriptions, batching/consistency issues
export function useMyStore() {
    const status = useStore((s) => s.status);
    const data = useStore((s) => s.data);
    const load = useStore((s) => s.load);
    return { status, data, load };
}

// CORRECT — single subscription, shallow comparison per field
import { useShallow } from 'zustand/react/shallow';

export function useMyStore() {
    return useStore(
        useShallow((s) => ({ status: s.status, data: s.data, load: s.load })),
    );
}

// ALSO CORRECT — single primitive, no useShallow needed
const status = useStore((s) => s.status);
```
