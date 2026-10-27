# Engineering rules (all projects)

From the coding questionnaire (2026-10-26). A repo's own `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md` or decisions doc wins on conflict.

Three layers: these **concepts** (always) → **area skills** `frontend`, `backend`, `devops` (layout and practices per area) → **tech skills** `go-idioms`, `typescript-react` (one language or framework). Load the area and tech skills that match the work.

## Code
- **Clean, simple, current.** Short functions, early returns, no hidden magic, no global mutable state. Use the language's current idioms, not old patterns.
- **Names explain the code.** Variables, functions and files read like plain words; the same thing has the same name everywhere.
- **No comments.** The code explains itself. The only exception is a non-obvious *why* (a workaround, a constraint not visible in code). Doc comments (JSDoc, Go doc) only where a public API needs them.
- **YAGNI.** Build for the cases in front of you. No speculative abstractions, layers or options.
- **DRY for real duplication.** Extract a shared helper when the same logic appears a second time with the same meaning; do not merge code that only looks alike.
- **SOLID where it simplifies:** one responsibility per unit, dependencies passed in, small interfaces at the consumer. Never as ceremony.
- **Libraries: fast, stable, maintained, widely used.** Prefer the standard library and the ecosystem's default choice; every new dependency is a decision you can justify in one line.
- **Remove dead or broken code.** Nothing half-wired, commented out or unused stays behind.
- **Decided but not built** → the decisions doc as "TBD + proposal", never stub code.
- **One change, one topic.** Fixing X does not also tidy unrelated Y; note Y or do it as its own commit. Keeps reviews small and changes easy to revert.

## Structure
- **Monorepo by default** for a product: apps, packages, infra and docs in one repo with clear folders. Split only for a real reason (different owners, release cycles or access).
- **Start simple.** A few packages/folders by responsibility. Move to feature-based layout (DDD-style) or spec-first APIs only when the project grows or is known to grow — a decision, not a default.
- **Thin edges, behaviour in the core.** Handlers and CLIs parse, call, write.
- **Input never breaks the system.** Invalid external data becomes a reported problem, not a crash; failures keep the last good state.
- **Config from the environment**, typed and validated at start. Secrets only in 1Password or the platform's env — never in git, notes or chat.

## Data
- **Default: SQL first with generated, typed access** (sqlc in Go) **plus versioned migrations** (dbmate or the stack's equivalent), one change per migration, up and down. No ORM unless the repo already uses one.

## Tests and done
- Tests where the logic is (parsing, rules, services); one smoke test at the edge; small fixtures; hand-written fakes over mocking frameworks; real database for store code.
- Validate against real data (local checkouts) when possible.
- **Done** = formatter clean, linter clean, tests green (or the repo's `make check`), docs and diagrams changed in the same commit as the behaviour.
- Tooling stays standard (`go`, `pnpm`, `docker`, `make`); personal tools only wrap them.

## Tools
- Look up library and framework APIs with **Context7** before relying on memory; use LSP for code navigation; use the project's own scripts (`make`, `pnpm`) for checks.

## Git and review
- Commit messages: imperative, what and why. No `Co-Authored-By`, session links or other attribution.
- Agents open draft PRs; risky changes (new dependency, schema/migration, public API, auth/secrets, infra/cost, hard to undo) always go to a human.
- PR body: what, why, how to test, risk, how to revert.
