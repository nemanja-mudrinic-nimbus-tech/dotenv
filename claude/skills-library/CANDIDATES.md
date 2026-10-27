# Open-source skill candidates

Research date: 2026-10-26. Stars and dates come from the GitHub API on that day.

This file lists open-source Agent Skills (SKILL.md format) that can be starting points for the own skills. Each skill stays inactive until you link it. The own layers are: concepts (`rules/engineering.md`), area skills (`frontend`, `backend`, `devops`) and tech skills (`go-idioms`, `typescript-react`).

Fit values:
- **good**: matches the house style. Copy rules from it with few changes.
- **partly**: useful content, but some rules conflict. The "Conflicts" column names them.
- **conflicts**: do not use as a starting point.

"Updated" is the last commit on the skill folder, not on the repository.

## Frontend

| # | Skill | Repo and path | License | Updated | Covers | Fit | Conflicts / notes | Feeds |
|---|---|---|---|---|---|---|---|---|
| 1 | react-best-practices | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) `skills/react-best-practices` (★33k) | MIT | 2026-04-14 | 70 React performance rules by impact: waterfalls, bundle size, re-renders. | partly | About 15 rules are Next.js or RSC only (`next/dynamic`, server actions, `after()`). `client-swr-dedup` uses SWR; we use TanStack Query. Ignore the `server-` group for Vite apps. | typescript-react |
| 2 | composition-patterns | vercel-labs/agent-skills `skills/composition-patterns` | MIT | 2026-01-28 | Compound components, no boolean-prop growth, React 19 APIs. | good | Context-provider patterns can become ceremony in small apps. Use them only when a component has real variants. | typescript-react, frontend (atomic layer) |
| 3 | shadcn | [shadcn-ui/ui](https://github.com/shadcn-ui/ui) `skills/shadcn` (★127k, official) | MIT | 2026-10-14 | shadcn CLI, registries, presets, styling and forms rules, "use components, not custom markup". | good | Large (296 lines + `rules/`). Needs the `shadcn` CLI. | frontend |
| 4 | router-core + router-query | [TanStack/router](https://github.com/TanStack/router) `packages/router-core/skills/router-core`, `packages/react-router/skills/compositions/router-query` (★15k, official) | MIT | 2026-10-17 | Route trees, type safety, loaders; Router with Query in loaders and `useSuspenseQuery`. | good | Pinned to a library version in metadata. The skills ship in the npm package, so a repo can also read them from `node_modules`. | typescript-react |
| 5 | accessibility | [addyosmani/web-quality-skills](https://github.com/addyosmani/web-quality-skills) `skills/accessibility` (★3k) | MIT | 2026-08-24 | WCAG 2.2 audit and fixes: semantics, labels, focus, keyboard, contrast. | good | Long (464 lines). Take the checklist; keep the own rule "accessible by default" short. | frontend |
| 6 | core-web-vitals (+ performance) | addyosmani/web-quality-skills `skills/core-web-vitals`, `skills/performance` | MIT | 2026-08-24 | LCP, INP, CLS with field and lab data; load-time budget. | good | `performance` overlaps rule 1 above for bundle topics. | frontend |
| 7 | web-design-guidelines | vercel-labs/agent-skills `skills/web-design-guidelines` | MIT | 2026-01-16 | UI review against the Vercel Web Interface Guidelines. | good | It fetches the guideline text from a GitHub URL at run time. Pin or copy the text if you want a stable review. | frontend (review step) |

## TypeScript and testing

| # | Skill | Repo and path | License | Updated | Covers | Fit | Conflicts / notes | Feeds |
|---|---|---|---|---|---|---|---|---|
| 8 | vitest | [antfu/skills](https://github.com/antfu/skills) `skills/vitest` (★6k) | MIT | 2026-10-23 | Vitest API, mocking, fixtures, coverage, filters. Generated from the Vitest docs. | good | Shows `vi.mock` a lot; the own rule prefers hand-written fakes. Short (55 lines + references). | typescript-react (tests) |
| 9 | playwright-cli | [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli) `skills/playwright-cli` (★15k, official) | Apache-2.0 | 2026-09-28 | Drive a browser from the shell: open, snapshot refs, click, fill, screenshot, run tests. | good | Needs the `playwright-cli` binary. Best fit for the factory manual-tester agent. | factory manual-tester |
| 10 | playwright-best-practices | [currents-dev/playwright-best-practices-skill](https://github.com/currents-dev/playwright-best-practices-skill) `playwright-best-practices` (★0.4k) | MIT | 2026-07-21 | Writing stable Playwright tests: locators, flakiness, auth, CI, a11y with axe. | partly | Teaches class-based Page Objects; prefer fixtures and plain functions. Very wide; load only the topic files you need. | factory test-runner |

## Backend

| # | Skill | Repo and path | License | Updated | Covers | Fit | Conflicts / notes | Feeds |
|---|---|---|---|---|---|---|---|---|
| 11 | golang-modernize | [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang) `skills/golang-modernize` (★3.7k) | MIT | 2026-09-02 | Move code to current Go features and stdlib (up to Go 1.27). | good | None found. Matches "current idioms, not old patterns". | go-idioms |
| 12 | golang-security | samber/cc-skills-golang `skills/golang-security` | MIT | 2026-09-02 | Injection, SSRF, crypto, secrets, PII in logs, `gosec`, race detector. | good | STRIDE/DREAD section is heavy for small services. | go-idioms, backend |
| 13 | golang-database | samber/cc-skills-golang `skills/golang-database` | MIT | 2026-09-02 | `database/sql`, pgx, transactions, isolation, pools, NULLs. Says "never an ORM". | partly | Recommends sqlx or pgx and never mentions sqlc. Keep the transaction and pool rules; keep sqlc as the own default. | go-idioms, backend |
| 14 | golang-error-handling | samber/cc-skills-golang `skills/golang-error-handling` | MIT | 2026-09-01 | `%w`, `errors.Is/As/Join`, "log or return, never both", slog. | partly | Promotes the author's `samber/oops` library. Drop that part. | go-idioms |
| 15 | golang-testing | samber/cc-skills-golang `skills/golang-testing` | MIT | 2026-09-02 | Table tests, parallel, fuzzing, goleak, integration tests. | partly | Uses testify suites and mocks; the own rule is stdlib tests plus hand-written fakes and a real database. | go-idioms |
| 16 | supabase-postgres-best-practices | [supabase/agent-skills](https://github.com/supabase/agent-skills) `skills/supabase-postgres-best-practices` (★2.9k) | MIT | 2026-07-30 | 30+ Postgres rules: indexes, pooling, locks, pagination, RLS, EXPLAIN. Says it applies to Postgres anywhere. | good | Some Supabase notes (RLS, pooler names). SQL-first, fits sqlc. | backend |
| 17 | fastapi | [fastapi/fastapi](https://github.com/fastapi/fastapi) `fastapi/.agents/skills/fastapi` (★104k, official) | MIT | 2026-10-15 | Current FastAPI: `Annotated`, return types, routers, async vs sync, SSE, `fastapi` CLI. | partly | Recommends SQLModel (an ORM) over SQLAlchemy. Accept only if the client repo already uses it. | backend (Python client) |
| 18 | modern-python | [trailofbits/skills](https://github.com/trailofbits/skills) `plugins/modern-python/skills/modern-python` (★7.8k) | CC-BY-SA-4.0 | 2026-09-16 | uv, ruff, ty, strict from day one, Makefile, migration from pip/Poetry. | good | Share-alike license: a changed copy must keep CC-BY-SA. Matches "standard tools, `make check`". | backend (Python tech skill) |
| 19 | api-and-interface-design | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) `skills/api-and-interface-design` (★111k) | MIT | 2026-10-02 | Stable contracts, error shapes, versioning, boundaries between modules. | partly | Long and generic (367 lines). Some advice leans to spec-first by default; the own rule makes spec-first a decision. | backend |

## DevOps

| # | Skill | Repo and path | License | Updated | Covers | Fit | Conflicts / notes | Feeds |
|---|---|---|---|---|---|---|---|---|
| 20 | terraform-style-guide | [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills) `plugins/terraform/skills/terraform-style-guide` (★0.9k, official) | MPL-2.0 | 2026-08-10 | HashiCorp file layout, naming, `for_each` over `count`, version pins, review checklist. | good | Asks for `description` on every variable; that is docs, not comments, so it is fine. | devops |
| 21 | terraform-test | hashicorp/agent-skills `plugins/terraform/skills/terraform-test` | MPL-2.0 | 2026-08-10 | `.tftest.hcl` run blocks, assertions, mocked providers. | good | Use only when a module has logic worth a test. | devops |
| 22 | docker-build-strategies (+ docker-compose-patterns) | [docker/skills](https://github.com/docker/skills) `skills/docker-build-strategies`, `skills/docker-compose-patterns` (official) | Apache-2.0 | 2026-09-29 | Multi-stage, cache, `.dockerignore`, non-root, small runtime; Compose health checks and local dev. | good | Has `scripts/` and `checks/`; read them before you run them. | devops |
| 23 | github-actions-hardening | [github/awesome-copilot](https://github.com/github/awesome-copilot) `skills/github-actions-hardening` (★40k) | MIT | 2026-06-16 | `${{ }}` injection, `pull_request_target`, token scopes, SHA pins, OIDC. | good | Alternative with the same scope: getsentry/skills `gha-security-review` (Apache-2.0, 2026-09-29). Pick one. | devops (CI) |
| 24 | gitops-workflow | [wshobson/agents](https://github.com/wshobson/agents) `plugins/kubernetes-operations/skills/gitops-workflow` (★42k) | MIT | 2026-10-04 | Argo CD Applications, app-of-apps, sync policies, External Secrets, Rollouts; also Flux. | partly | Installs Argo CD with `kubectl apply` by hand and mixes Flux. Keep the Application and sync-policy parts; drop Flux and Sealed Secrets. No official Argo CD skill exists. | devops |

## Cross-cutting

| # | Skill | Repo and path | License | Updated | Covers | Fit | Conflicts / notes | Feeds |
|---|---|---|---|---|---|---|---|---|
| 25 | skill-creator | [anthropics/skills](https://github.com/anthropics/skills) `skills/skill-creator` (★184k) | Apache-2.0 (skill folder) | 2026-04-20 | Write skills, run evals, tune descriptions for triggering. | good | Partial overlap with `mattpocock-skills:writing-for-agents` (style). skill-creator adds evals and benchmarks. It is also available as `anthropic-skills:skill-creator`; do not install twice. | own skill authoring |

## Notes

### Frontend
- No official Tailwind, TypeScript or Vite-plus-React skill exists. Context7 covers their APIs, so a skill adds little.
- Rules 1 and 2 are the strongest React sources. Copy single rules into `typescript-react`; do not load the whole set.
- The TanStack skills are official and versioned. They are the best source for the Router-plus-Query default stack.

### TypeScript and testing
- Vitest has no official skill (the Vitest repo has only a typo checker). The antfu skill is generated from the docs and stays current.
- For the factory agents, use playwright-cli for exploratory testing and pick rules from playwright-best-practices for the test-runner.

### Backend
- No sqlc skill exists. Write the sqlc and dbmate rules yourself in `go-idioms` and `backend`.
- samber/cc-skills-golang has 46 skills. Many teach the author's libraries (`samber/lo`, `samber/do`, `oops`) or DI frameworks (`wire`, `fx`, `dig`). Those conflict with "standard library first". Take only the skills in the table.
- For Python, use fastapi (official) plus modern-python. Do not use the community FastAPI skills (see Rejected).

### DevOps
- No official Kubernetes, Helm, Kustomize or Argo CD skill exists. The community skills are generic. The own `devops` skill already says more about GitOps than they do.
- HashiCorp and Docker are the two official vendor sets in this area.

### Cross-cutting and overlaps with mattpocock-skills
- Debugging: `mattpocock-skills:diagnosing-bugs` covers it. Do not add superpowers `systematic-debugging`.
- TDD: `mattpocock-skills:tdd` covers it. Do not add superpowers or addyosmani TDD skills.
- Code review: `mattpocock-skills:code-review`, the built-in `code-review` and `security-review` cover it. Do not add getsentry `find-bugs` or `code-review`.
- Refactoring: the built-in `simplify` and `mattpocock-skills:codebase-design` cover it. Do not add getsentry `code-simplifier` or addyosmani `code-simplification`.
- ADRs and docs: `mattpocock-skills:domain-modeling` records ADRs. addyosmani `documentation-and-adrs` and wshobson `architecture-decision-records` are duplicates.

## Rejected

| Skill | Repo | Reason |
|---|---|---|
| superpowers (whole set) | obra/superpowers | A full workflow (brainstorm, plans, worktrees, subagents). Overlaps mattpocock-skills and the factory. Debugging and TDD are duplicates. |
| verification-before-completion | obra/superpowers | The global rule "verify against a concrete check" already says this. |
| frontend-design | anthropics/skills | Visual style direction ("not templated defaults"). Conflicts with shadcn defaults and the design-system-first rule. |
| webapp-testing | anthropics/skills | Python Playwright scripts. playwright-cli does the same job with less code. |
| playwright-skill | lackeyjb/playwright-skill | Runs its own Node runner and `npm install`. playwright-cli is official and simpler. |
| tailwind-design-system | wshobson/agents | Tailwind v4 tokens with cva. Overlaps shadcn, which owns the primitives. |
| typescript-advanced-types | wshobson/agents | Conditional and mapped type tricks. Against YAGNI for app code. |
| vite, pnpm | antfu/skills | Good quality, but Context7 covers the APIs. Add only for a Vite plugin or pnpm workspace task. |
| postgresql-table-design | wshobson/agents | Good, but overlaps supabase-postgres-best-practices. Keep as a second source. |
| postgresql-code-review, sql-optimization | github/awesome-copilot | Shallow; covered by the Supabase rules. |
| k8s-manifest-generator, helm-chart-scaffolding | wshobson/agents | Thin templates (68 to 77 lines). Nothing beyond the own `devops` skill. |
| k8s-security-policies | wshobson/agents | Teaches PodSecurityPolicy, which Kubernetes removed in 1.25. |
| cc-devops-skills validators | akin-ozer/cc-devops-skills | Very long (up to 791 lines). Scripts install linters. Last change 2026-03. |
| devops-claude-skills | ahmedasmar/devops-claude-skills | No license. Last change 2026-04. |
| Argo CD skills in registries | jeremylongshore, majiayu000 registries | Unverified, generic, mass-generated. |
| fastapi-expert, golang-pro, typescript-pro | Jeffallan/claude-skills | Generic "expert" personas. FastAPI one uses async SQLAlchemy and JWT scaffolds; Go one is goroutine-heavy. |
| fastapi-templates, python-code-style | wshobson/agents | Scaffolds with layers and Google-style docstrings everywhere. Conflicts with no-comments and YAGNI. |
| golang-samber-*, golang-uber-fx/dig, golang-google-wire | samber/cc-skills-golang | Library promotion and DI containers. Conflicts with stdlib first and "no DI containers". |
| security-review | getsentry/skills | Good, but the built-in `security-review` covers it. |
| Trail of Bits audit skills (fuzzing, semgrep, codeql, chain scanners) | trailofbits/skills | Security research tools, not daily coding rules. `supply-chain-risk-auditor` and `agentic-actions-auditor` are worth a look later for CI. |
| alirezarezvani/claude-skills, sickn33/agentic-awesome-skills | community | Very large mixed sets (business, marketing). Low signal for engineering. |

## How to install inactive

The library folder holds read-only copies. A skill is active only when a link to it exists in `~/.claude/skills/`.

Warning: read every SKILL.md and every script in the skill folder before you link it. A skill can run commands.

1. Clone the source repo into a temporary folder with a shallow clone.
   `git clone --depth 1 https://github.com/<owner>/<repo> /tmp/skill-src/<repo>`
2. Copy only the skill folder into the library.
   `cp -R /tmp/skill-src/<repo>/<path> ~/.dotfiles/claude/skills-library/<name>/`
3. Write the source and the commit into a file next to it.
   `git -C /tmp/skill-src/<repo> rev-parse HEAD > ~/.dotfiles/claude/skills-library/<name>/SOURCE`
4. Add the repo URL and the license to the same `SOURCE` file.
5. Delete the temporary clone.
6. To activate the skill, make a link in the active folder.
   `ln -s ~/.dotfiles/claude/skills-library/<name> ~/.claude/skills/<name>`
7. To deactivate the skill, remove the link.
   `rm ~/.claude/skills/<name>`
8. To update, repeat steps 1 to 5 and compare the diff before you commit.

If the skill name collides with an own skill (for example `shadcn`), give the library folder a prefix such as `vendor-shadcn`. Change the `name:` field in the frontmatter to match.

For CC-BY-SA-4.0 skills (Trail of Bits), keep the license and attribution in the copy. A changed version must use the same license. For MPL-2.0 skills (HashiCorp), keep the license notice in changed files.

Use these copies as starting points. Move the rules you agree with into the own area or tech skill. Leave the copy unlinked when the own skill covers it.

## Sources

- https://github.com/anthropics/skills
- https://github.com/vercel-labs/agent-skills
- https://github.com/shadcn-ui/ui/tree/main/skills/shadcn
- https://github.com/TanStack/router/tree/main/packages/router-core/skills
- https://github.com/addyosmani/web-quality-skills
- https://github.com/addyosmani/agent-skills
- https://github.com/antfu/skills
- https://github.com/microsoft/playwright-cli
- https://github.com/currents-dev/playwright-best-practices-skill
- https://github.com/samber/cc-skills-golang
- https://github.com/supabase/agent-skills
- https://github.com/fastapi/fastapi/tree/master/fastapi/.agents/skills/fastapi
- https://github.com/trailofbits/skills
- https://github.com/hashicorp/agent-skills
- https://github.com/docker/skills
- https://docs.docker.com/ai/skills/
- https://github.com/github/awesome-copilot
- https://github.com/getsentry/skills
- https://github.com/wshobson/agents
- https://github.com/obra/superpowers
- https://github.com/akin-ozer/cc-devops-skills
- https://github.com/ahmedasmar/devops-claude-skills
- https://github.com/lackeyjb/playwright-skill
- https://github.com/Jeffallan/claude-skills
- https://github.com/VoltAgent/awesome-agent-skills
- https://github.com/ComposioHQ/awesome-claude-skills
- https://github.com/travisvn/awesome-claude-skills
- https://www.skills.sh/tiangolo
- https://openskillindex.com/skills/majiayu000-claude-skill-registry-gitops-with-argocd
