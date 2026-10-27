# Global rules

Apply to every project. A project `CLAUDE.md` wins on conflict.

## Code
@~/.dotfiles/claude/rules/engineering.md

Area skills (`frontend`, `backend`, `devops`) and tech skills (`go-idioms`, `typescript-react`) load when the work matches.

## Working
- Surface assumptions before non-trivial work. For exploratory questions, propose a direction in 2–3 sentences before building.
- Library/framework API questions: look it up with Context7 before relying on memory.
- Long-running processes (dev servers, watchers, long test runs): start with `devctl run --name <n> -- <cmd>`, read output with `devctl logs <id>`, stop with `devctl stop <id>` when done. Never `&` or `nohup` (a hook blocks it). Session end stops what you started.

## Tone
- Terse. Answer what was asked. No trailing summaries. No emojis unless asked.
- Write replies and docs in **ASD-STE100 (Simplified Technical English)** style:
  - Procedures: numbered steps, one instruction per sentence, imperative ("Open the drawer."), max 20 words.
  - Descriptions: max 25 words per sentence, max 6 sentences per paragraph, one topic per paragraph.
  - Active voice, simple tenses. Condition first ("If X, do Y"). Warnings before the step they apply to.
  - Simple words with one meaning; the same term for the same thing every time. No idioms, slang or metaphors.
  - Keep articles (a, the); no noun clusters longer than three words.

## Git
- Never run `reset --hard`, `push --force`, `branch -D`, `clean -f` without explicit confirmation.
- Never `--no-verify` unless asked. Prefer new commits over `--amend`.
- No `Co-Authored-By`, session links or other attribution lines in commits or PRs.

## Vault — `~/vault` (markdown, edited in nvim)
Persistent memory across sessions. Access with Read/Write/Edit/Glob/Grep on absolute paths — no filesystem MCP.
Layout per project: `index.md`, `working-notes/`, `concepts/`, `lessons-learned/`, `sensitive/`. New project setup: `~/vault/backfill/index.md`.

**Reading — only what the task needs:**
- First substantive turn: if the engagement root's `CLAUDE.md` names a slug, read only `~/vault/projects/<slug>/index.md`. No slug → ask in one line (which / none / new).
- Open other notes only when the index points to one relevant to the current task. Never bulk-read the vault.
- `sensitive/` only when the task needs a specific ID or endpoint.

**Writing — paused until the vault decision (2026-10-25): do not create new vault notes; only fix existing ones.** When writing resumes, only these, never session chatter:
- A decision was made and its *why* would be lost → `working-notes/` (or update the existing note).
- A non-obvious problem was solved (took real digging, will bite again) → `lessons-learned/<domain>.md`.
- You learned how a system actually works, beyond what the code shows → `concepts/`.
- The user asks to save something, or the output is long-form (plan, design, postmortem, >~30 lines) → a file, and reply with a pointer plus the conclusion.
- Update an existing note before creating a new one. Keep `index.md` a short map (links, not content). Mention in the reply which vault file you wrote.
- `sensitive/` is gitignored — never paste its contents into commits, PRs, or logs.

## Code navigation
- Where a symbol is defined or used: load the `LSP` tool and use it before grep. Then grep/Explore for wider searches.
- If the project `CLAUDE.md` says `Second brain: on`, use the `brain` skill.
