---
name: frontend
description: Nemanja's frontend practices across frameworks — component layout (atomic design where it helps), styling, accessibility, performance, fast and stable libraries, data fetching. Use for any web or mobile UI work together with the matching tech skill (e.g. typescript-react). A repo's own decisions win.
---

# Frontend

Concepts: `~/.dotfiles/claude/rules/engineering.md`. Framework details: the tech skill (`typescript-react`).

## Layout
- **Atomic design when the UI has a shared design system:** `components/atoms` (button, input), `molecules` (search field), `organisms` (header, task card), then `pages`/`routes`. For a small app, a flat `components/` plus `routes/` is fine — move to atomic when the same pieces repeat.
- Feature folders (`features/<name>/{components,hooks,api}`) when the app has several distinct areas.
- Shared UI primitives come from the design system (shadcn/ui), not re-built per page.

## Libraries
- Fast, stable, widely used: the framework's default router and data layer, Tailwind for styling, one icon set, one date library. No second library for something the first already does.
- Check bundle size before adding a dependency; prefer tree-shakeable ESM packages.

## Practices
- Server data through the data layer (cache, retries, invalidation), never ad-hoc fetch in components.
- Accessible by default: semantic HTML, labels, focus states, keyboard paths.
- Responsive from the start; test at phone width.
- Loading, empty and error states for every screen that fetches.
- No dead components, no commented-out markup.
