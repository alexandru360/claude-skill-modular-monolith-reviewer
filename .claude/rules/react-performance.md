---
globs: ["**/*.tsx"]
---

# React Performance Rule

## Props Immutability

- Component props MUST be wrapped in `Readonly<>` — prevents accidental mutation and satisfies SonarQube S6759.

```tsx
// WRONG
function UserCard({ user }: { user: User }) { ... }

// CORRECT
function UserCard({ user }: Readonly<{ user: User }>) { ... }

// CORRECT — named interface
interface UserCardProps {
    user: User;
}
function UserCard({ user }: Readonly<UserCardProps>) { ... }
```

## Re-render Prevention

- Never define components inside other components — causes full remount on every render.
- Hoist default non-primitive props (objects, arrays, callbacks) to module level or useMemo.
- Arrays/objects computed from props or state that are passed to children MUST use `useMemo` — inline expressions create a new reference every render, breaking `React.memo` and causing cascading re-renders.

```tsx
// WRONG — new array reference on every render
const badges = [
    ...(item.force !== undefined ? [`force: ${item.force}`] : []),
    ...(item.style !== undefined ? [`style: ${item.style}`] : []),
];
return <BadgeList badges={badges} />;

// CORRECT — stable reference when deps unchanged
const badges = useMemo(() => [
    ...(item.force !== undefined ? [`force: ${item.force}`] : []),
    ...(item.style !== undefined ? [`style: ${item.style}`] : []),
], [item.force, item.style]);
return <BadgeList badges={badges} />;
```

- Derive state during render, not in useEffect — avoids an extra render cycle.
- Use functional setState (`setCount(c => c + 1)`) for stable callbacks without deps.
- Use `useRef` for transient high-frequency values (mouse position, scroll offset) that don't need re-render.
- Prefer `useDeferredValue` or `startTransition` for expensive non-urgent updates.

## Async & Data Fetching

- Use `Promise.all()` for independent async operations — never sequential awaits.
- Check cheap sync conditions before awaiting expensive remote values.
- Move `await` into the branch where the value is actually consumed.

## Bundle Size

- Import directly from module path, not barrel files (`index.ts` re-exports).
- Use dynamic imports (`React.lazy` / `next/dynamic`) for heavy components not visible on initial load.
- Defer third-party scripts (analytics, logging) until after hydration.

## Keys

- NEVER use array index as `key` in `.map()` — causes reconciliation bugs on reorder/insert/delete.
- Use a stable unique identifier from the data (uuid, id, or a composite of unique fields).
- If no single field is unique, compose a key from multiple fields: `key={`${item.fieldA}-${item.fieldB}`}`.

## Rendering

- Use ternary (`condition ? <A /> : <B />`) not `&&` for conditional rendering — avoids rendering `0` or `""`.
- Extract static JSX (icons, labels) outside the component body when it doesn't depend on props/state.
- Use `content-visibility: auto` for long scrollable lists to skip off-screen layout work.

## Memoization

- Wrap expensive child components in `React.memo` only when parent re-renders frequently with same props.
- Don't memo simple primitive expressions — the comparison cost exceeds the render cost.
- Split hooks that combine independent dependencies into separate hooks to reduce re-render scope.
