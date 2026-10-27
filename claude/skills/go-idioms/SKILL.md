---
name: go-idioms
description: Nemanja's Go rules — idiomatic, explicit, YAGNI code with no comments, a layout that starts small and evolves (packages by responsibility → feature packages), standard library first, codegen (sqlc, oapi-codegen) only when it pays. Use for any Go work: writing, reviewing, refactoring, or starting a Go repo. A repo's own documented decisions win.
---

# Go idioms

Clean, idiomatic Go that a reader understands without comments, built for today and easy to grow. When a repo has documented decisions (its `CLAUDE.md`, decisions doc, ADRs), follow those; deviating from these rules in a new repo is a decision worth one line in that doc.

## Code style: explicit, no comments
- **Names explain the code.** No comments that restate it, no doc comments on functions, methods or types. A comment only for a non-obvious *why* (a workaround, a constraint not visible in code).
- **Explicit over clever.** Plain control flow, early returns, no hidden magic: no reflection tricks, no `init()` side effects, no global mutable state, no struct-tag DSLs beyond encoding/validation.
- **Small functions with clear inputs and outputs.** Pass dependencies in; no package-level singletons.
- **Short names in small scopes** (`i`, `r`, `err`), descriptive as scope widens. No stutter (`users.User`, `board.Service`), no `Get` prefix on getters, no getters/setters at all for plain data.
- `gofmt`/`goimports`; the repo's `golangci-lint` config is law — no ad-hoc `nolint`.

## Idioms
- **Errors are values.** `(T, error)`; wrap with context `fmt.Errorf("load %s: %w", id, err)`; sentinel errors or small error types only when callers branch on them. No panics across package boundaries.
- **Interfaces at the consumer**, small (`-er` when one method), satisfied implicitly. None until a second implementation or a real test seam exists. Accept interfaces, return structs.
- **Constructors `NewX(deps…)`** returning concrete types. No DI containers, no factories of factories.
- **`ctx context.Context` first** on anything doing I/O; honour cancellation.
- **Zero values useful**; config structs with sensible defaults.
- **Concurrency explicit and bounded**: owner of every goroutine is obvious; timeouts on every server and outbound call; `errgroup`/`singleflight`/mutex over ad-hoc channels.
- **Standard library first** — `net/http` (Go 1.22+ routing), `log/slog`, `database/sql`, `encoding/json`. Every dependency is a decision. HTTP to other services: the idiomatic choice for the current Go version — usually `net/http`; an official, maintained SDK when it saves real work (cloud providers, auth flows).

## YAGNI + evolvable layout
Start with the smallest shape that is honest, and move when the code asks for it — not before. Feature-based (DDD-style) layout or spec-first APIs are for projects that grow or are known to grow; never mandatory.

| Stage | Layout | Move on when |
|---|---|---|
| **1. Small** (a tool, one service, few routes) | `cmd/<app>/main.go` + `internal/<responsibility>/` (`config`, `store`, `httpapi`, the core domain package) | a core package passes ~1,500 lines or mixes unrelated features |
| **2. Features** (several domains) | `internal/<feature>/{handler,service,types[,store]}.go` per feature (`users`, `billing`), shared bits in `internal/platform/` | features need independent deploys or teams |
| **3. Split** | separate services/modules | — |

- **Behaviour lives in the core/service**; handlers and CLIs parse, call, write.
- **Never** `controllers/ services/ models/` layers, ports-and-adapters scaffolding, or a `pkg/` of unused utilities.
- Moving between stages is an ordinary refactor PR — the code is written so it's cheap (explicit deps, consumer interfaces).

## Data and HTTP — codegen when it pays
- **Database (default)**: **sqlc** from the first query (SQL in `db/queries/`, typed code generated over `database/sql`/pgx) + versioned migrations in `db/migrations/` — **dbmate** or the repo's tool — one change each, up + down. No ORMs.
- **HTTP API**: hand-written `net/http` handlers while the API is small and only your client uses it. Switch to **spec-first** (`api/openapi.yaml` → `oapi-codegen`, handlers implement the generated interface) when there are external consumers, several clients, or a contract to keep. That switch is a decision.
- **Config**: environment only, parsed into a typed struct and validated at start.
- **Input never crashes the service**: invalid external data becomes a reported error/problem; failures keep the last good state where it makes sense.

## Tests
- **Where the logic is**: table-driven unit tests on domain/service code; one smoke test through HTTP. Fixtures in `testdata/`.
- No mocking frameworks; hand-written fakes at consumer interfaces. Real database (testcontainers or a test DB) for store code — never mock sqlc.
- `t.Cleanup` for teardown, `t.Run(tt.name, …)` with intent-revealing names, no test comments.
- External test package (`foo_test`) for public behaviour; internal only for unexported needs.

## Done means
`gofmt` clean, `golangci-lint` clean, `go test ./...` (or the repo's `make check`) green, docs that describe the changed behaviour updated in the same change.
