---
name: backend
description: Nemanja's backend practices across languages — service and API layout, layering, errors, data access (SQL first, sqlc, migrations), config, observability, testing. Use for any API, service, worker or CLI work together with the matching tech skill (e.g. go-idioms). A repo's own decisions win.
---

# Backend

Concepts: `~/.dotfiles/claude/rules/engineering.md`. Language details: the tech skill (`go-idioms`).

## Layout
- Start with packages by responsibility (`config`, `store`, `httpapi`, the domain package). Move to feature packages (`<feature>/{handler,service,store}`) when there are several domains; split services only for a real reason.
- In a monorepo: `apps/<service>`, shared code in `packages/` (or `internal/` in Go), infra in `deploy/`.

## APIs
- Handlers parse, call the service, write the response. Behaviour lives in the service.
- Validate input at the edge; return clear errors with stable codes; never leak internals.
- Hand-written handlers while the API is small and has one client; spec-first (OpenAPI + codegen) when there are external consumers or several clients.

## Data
- SQL first: sqlc (or the stack's equivalent) for typed queries, versioned migrations (dbmate or the repo's tool), one change per migration, up and down. No ORM unless the repo has one.
- Transactions around multi-step writes; idempotent jobs and handlers where retries happen.

## Operations
- Config from the environment, validated at start. Secrets from 1Password/the platform, never in git.
- Structured logs (one line per event, with request id); health and readiness endpoints; timeouts on every outbound call.

## Tests
- Unit tests for rules and parsing, store tests against a real database, one smoke test through the API.
