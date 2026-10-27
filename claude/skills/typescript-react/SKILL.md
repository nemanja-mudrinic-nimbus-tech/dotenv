---
name: typescript-react
description: Nemanja's TypeScript and React rules — default stack for new web apps (Vite, React, TanStack Router + Query, Tailwind, shadcn, pnpm), state, comments, generated files, lint/format. Use for any TypeScript, React or frontend work: writing, reviewing, refactoring, or starting a web app. A repo's own documented decisions win.
---

# TypeScript and React

Concepts: `~/.dotfiles/claude/rules/engineering.md`. Layout, libraries and UI practices: the `frontend` skill. This skill adds what is specific to TypeScript and React. A repo's own choices win.

## Default stack for a new app
- Vite + React + TypeScript (strict), TanStack Router + TanStack Query, Tailwind, shadcn/ui, pnpm.
- Pin the package manager in `package.json` (`"packageManager": "pnpm@x.y.z"`), so CI and Docker use the same major.
- Lint and format: the repo's choice; for a new repo use what the closest existing project of ours uses (fuda: Oxlint + Oxfmt).
- Tests: Vitest for logic; no end-to-end suite unless the repo has one or the factory's test agents own it.

## Code
- Components small and named after what they show. Logic that is not about rendering moves into plain functions or hooks next to the component.
- **State:** server state in TanStack Query; local state in the component; no global store unless several distant parts really share client-only state.
- **Types:** infer where obvious, declare at module boundaries (props, API results). No `any`; `unknown` + narrowing for external data. Validate external input at the edge.
- **Comments:** only a non-obvious why. JSDoc only on a shared, exported API that needs it — most code never does.
- Commit generated files the type checker needs (for example `routeTree.gen.ts`), so a fresh clone type-checks without a build step.
- No dead code, unused exports or commented-out JSX.

## Done
`pnpm lint`, `pnpm build` (tsc + vite) and the tests pass; screens you changed checked in a browser.
