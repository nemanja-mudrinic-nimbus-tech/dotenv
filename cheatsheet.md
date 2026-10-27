# Nimbus Dev Cheatsheet

Map of all notes/guides: `vault dev-setup` → index.md. Open anywhere: **`prefix ?`** (tmux popup) · **`cheat`** (shell, same view) · `cheate` (edit) · nvim `<leader>oc`. Prefix = **Ctrl+a** · nvim leader = **Space**.

---

## Navigation — one motion everywhere

| Keys | Action |
|---|---|
| `Ctrl+h/j/k/l` | Move between **nvim splits AND tmux panes** (seamless) |
| `Cmd+D` / `Cmd+Shift+D` | New Ghostty split (rarely needed — tmux owns panes) |
| `Cmd+Alt+arrows` | Move between Ghostty splits |

---

## tmux (prefix = Ctrl+a)

**Changed 2026-10-25:** status bar is at the **top** · `prefix s` is now **sessionx** · new `prefix F` floating shell (`prefix M` its menu) · new `prefix Ctrl+u` pick a URL on screen and open it · closing a session jumps to another one (you stay in tmux). Bar in omerxx's catppuccin layout, moss colours: session pill left, windows `name │ number`, current folder right.

| Keys | Action |
|---|---|
| `prefix \|` / `prefix -` | Split pane vertical / horizontal (keeps cwd) |
| `Ctrl+h/j/k/l` | Move between panes (and into nvim) |
| `prefix H/J/K/L` | Resize pane (hold to repeat) |
| **Drag pane border** | Resize with the mouse (mouse is on) |
| `prefix Space` | Cycle preset layouts (even-split, main, tiled) |
| `prefix c` / `prefix ,` | New window / rename window |
| `prefix 1..9` | Go to window N |
| `prefix n / p` | Next / previous window |
| `prefix z` | Zoom (fullscreen) current pane |
| `prefix x` | Kill pane · `prefix &` kill window. Closing the last pane of a session ends the session |
| End a whole session | In `prefix s`: select it, `Alt+Backspace` · or `tmux kill-session -t NAME` |
| Careful in `prefix s` | Typing a name or folder that is not a session and pressing `Enter` **creates** a new session |
| `prefix d` | Detach (leave tmux, everything keeps running). In a shell: `tmux detach` |
| `prefix [` | **Copy mode** — scroll/select output with the keyboard (works on a Claude session's output too): `k/j` line, `Ctrl+u/d` half page, `g/G` top/bottom, `/text` or `?text` search (`n/N` next/prev), `v` (or `Space`) start selection, `w/b/e` by word, `0/$` line start/end, `V` whole line, `Ctrl+v` block, `y`/`Enter` copy to clipboard, `q` quit |
| `prefix w` · `prefix l` | Window/session tree with preview · back to the last window |
| **Scroll Claude's output** (no copying) | `prefix [` (or `prefix PgUp`, or just the mouse wheel) → `Ctrl+u`/`Ctrl+d` half page, `k`/`j` line, `g` top, `?text` find → `q` back to Claude's input (nothing is copied unless you press `v`…`y`) |
| `prefix g` | **lazygit** popup |
| `prefix ?` | **This cheatsheet** popup |
| `prefix s` | **sessionx** — pick a session (preview, git branch). Type a name that does not exist + `Enter` = new session; type a folder name = zoxide jumps there. Inside: `Ctrl+r` rename · `Alt+Backspace` kill · `Ctrl+w` windows · `Ctrl+t` tree · `?` preview on/off |
| `prefix F` | **floax** — a floating terminal for quick commands (git status, a test run, a one-off) without touching your panes. `prefix F` again hides it; it keeps running and comes back with `prefix F`. `exit` inside it closes it for good. `prefix M` = floax menu (size, fullscreen, embed as a window) |
| `prefix r` | Reload tmux config |
| `prefix Ctrl+h` / `prefix Ctrl+l` | Move the current window one place left / right in the bar (hold `Ctrl` and repeat) |
| `prefix !` | Take the current pane out into its own window |
| `prefix j` | Pick another window and pull it into this one as a side-by-side pane |

### Sessions (new / switch / kill)
| From inside tmux | Action |
|---|---|
| `prefix s` | sessionx picker (see above) |
| `prefix (` / `prefix )` | Previous / next session |
| `prefix :` then `new -s NAME` | Create a new session (and switch to it) |
| `prefix $` | Rename current session |
| `prefix d` | Detach (session keeps running) |

| From the shell | Action |
|---|---|
| `tmux ls` | List sessions |
| `tmux new -s NAME` | New session (only when *not* already in tmux) |
| `tmux a` / `tmux a -t NAME` | Attach most-recent / a named session |
| `tmux-switch` | Fuzzy-switch session |
| `tmux-kill` | Fuzzy-kill session(s) |

### How to work in tmux (the flow)
- **You're always in tmux** (auto-starts in `main`). New project session: `prefix N` (asks a name, starts in the current folder); switch sessions with `prefix s`.
- **Windows = areas, panes = glances.** Window 1 = editor, window 2 = server/logs, window 3 = scratch. Use panes for short-lived things (a test run, a REPL).
- **Detach, don't quit.** `prefix d` leaves everything running; reattach later with `tmux a`. It survives closing Ghostty / a reboot of the terminal.
- **Zoom over resize.** `prefix z` fullscreens a pane and back — faster than constant resizing.
- **lazygit & cheatsheet are popups** (`prefix g`, `prefix ?`) — they float and vanish, so they never eat a pane.
- **Scrollback:** `prefix [`, then `/` to search, `q` to exit (mouse scroll works too).
- **Reload config after edits:** `prefix r`.

---

## Neovim — coding (LazyVim defaults)

### LSP / code intelligence
| Keys | Action |
|---|---|
| `gd` | Go to definition · `gD` declaration |
| `gr` | References · `gI` implementation · `gy` type definition |
| `K` | Hover docs · `gK` signature help |
| `<leader>ca` | Code action (quickfix, imports, etc.) |
| `<leader>cr` | Rename symbol (project-wide) |
| `<leader>cR` | Rename file (updates imports) |
| `<leader>cf` | Format buffer/selection |
| `<leader>cd` | Line diagnostics (floating) |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous **error** |
| `<leader>cl` | LSP info · `<leader>xx` Trouble (all diagnostics) |
| `<leader>ss` | Document symbols (outline) |
| `<leader>cs` | Symbols via Trouble |

### Completion (blink.cmp)
| Keys | Acti            :  on |
|---|---|
| `Ctrl+Space` | Trigger completion |
| `Enter` | Confirm · `Ctrl+e` cancel |
| `Tab` / `Shift+Tab` | Next / prev item & snippet jump |

### Comments / surround
| Keys | Action |
|---|---|
| `gcc` | Toggle line comment · `gc` + motion (e.g. `gcap`) |
| `gco` / `gcO` | Add comment below / above |
| `gsa` + motion + char | Surround **add** (e.g. `gsaiw"`) |
| `gsd` + char | Surround **delete** (e.g. `gsd"`) |
| `gsr` + old + new | Surround **replace** (e.g. `gsr"'`) |

### Files / buffers / search
| Keys | Action |
|---|---|
| `Space Space` | Find files · `Space ff` files (root) |
| `Space /` | Grep project · `Space sw` grep word under cursor |
| `Space e` | File explorer (snacks; neo-tree removed 2026-10-25) · `Space ,` switch buffer |
| `Space fm` / `Space fM` | **mini.files** — Miller-column file browser at this file / at the cwd. Edit names like text, `=` to apply, `q` close |
| `Ctrl+g` / `1 Ctrl+g` | Show file path (relative / absolute) in cmdline |
| `Space fy` / `fY` | Copy file path to clipboard (absolute / relative) |
| `Shift+h` / `Shift+l` | Previous / next buffer |
| `Space bd` | Close buffer · `Space bo` close others |
| `Space sk` | Search keymaps · `Space sh` search help |
| `Space gg` | lazygit (in nvim) |

### Diff / GitHub (octo + diffview)
| Keys | Action |
|---|---|
| `Space gd` / `gD` | Diffview open / close |
| `Space gh` / `gH` | File history / branch history |
| `Space op` / `oP` | List / create PR |
| `Space oi` / `oI` | List / create issue |
| `Space or` | Start PR review |

### Test (neotest, Go adapter)
| Keys | Action |
|---|---|
| `Space tt` / `tr` | Run file / nearest test |
| `Space tl` / `ts` | Run last / toggle summary |
| `Space to` / `tS` | Show output / stop |

### Harpoon / terminal
| Keys | Action |
|---|---|
| `Space ma` / `mm` / `mr` | Harpoon add / menu / remove |
| `Space 1..4` | Jump to harpoon file 1–4 |
| `Space ft` / `fT` | Terminal (project root / cwd) · `Esc` exits |
| `Space xs` | Run shell command |

### Markdown
| Keys | Action |
|---|---|
| _(automatic)_ | Inline render while editing (render-markdown.nvim) |
| `Space mt` | Toggle inline render (raw ↔ pretty) |
| `Space mv` | Toggle **vellum** preview as a side split (images, mermaid, math). Off by default |
| `Space mz` | Toggle **full-screen reading** (vellum fills the window; press again → back to editing) |
| In vellum preview: `<CR>` on an image or diagram | Open it full-screen · zoom/pan with keys or mouse · `0` fit to screen |
| `nvim photo.jpg` · open it from `Space e` / `Space ff` | View an **image file** (jpg, png, gif, webp, heic…) in a buffer (snacks.image + ImageMagick). Pickers preview images too |
| Markdown images `![](shot.jpg)` | Shown by vellum (`Space mv` / `Space mz`), not inline while editing |
| `:MarkdownPreview` | Live preview in the browser |

### Messages & notifications
| Keys | Action |
|---|---|
| `Space n` | Notification history (re-read past popups) |
| `Space un` | Dismiss all notifications |
| `Space sn` | Noice message log (search) |
| `:messages` | Vim's raw message log |

---

## Neovim — editing motions (vanilla, work everywhere)

### Text objects — change/delete inside
| Keys | Action |
|---|---|
| `ciw` / `diw` | Change / delete **inner word** |
| `ci"` `ci'` `ci(` `ci{` `ci[` | Change inside quotes / brackets |
| `cit` / `dat` | Change inside / delete around **HTML/JSX tag** |
| `cip` / `dip` | Change / delete inner paragraph |
| `daw` | Delete a word incl. surrounding space |
| `vi(` / `va(` | Select inner / around parens |

### Copy · cut · paste — use operator + motion, not `v`
`vw` selects *onto* the first letter of the next word (visual mode includes the cursor char) — that's why you step back. An **operator + motion** (`y`/`d`/`c` + where) never needs that.

| Keys | Action |
|---|---|
| `yiw` · `yaw` | Copy the word under the cursor · word + space |
| `ye` · `yw` · `yb` | Copy to end of word · up to next word (stops before it) · back to word start |
| `y$` · `yy` · `3yy` | Copy to end of line · whole line · 3 lines |
| `yi"` `yi(` `yip` | Copy inside quotes / parens / paragraph |
| `ve` / `vE` | Visual to **end** of word / WORD (use instead of `vw`) · `viw` select word |
| `d…` (e.g. `diw`, `dd`, `d$`) | **Cut** = delete into the register, stays in normal mode |
| `c…` (e.g. `ciw`) | **Change** = cut **and enter insert mode** — by design, for "replace this with typing" |
| `x` (visual) | Cut the selection |
| `p` / `P` | Paste after / before the cursor |
| `viw` then `p` | Replace a word with what you copied (in visual `P` keeps the register for repeat pastes) |
| `"0p` | Paste the last **yank** even after you deleted something since |
| `gv` | Reselect the last selection |
Yanks go to the macOS clipboard (Cmd+V elsewhere works).

### Motions & jumps
| Keys | Action |
|---|---|
| `f{c}` / `t{c}` | Jump to / before char on line · `;` `,` repeat / reverse |
| `w` `b` `e` | Word forward / back / end |
| `0` `^` `$` | Line start / first non-blank / end |
| `gg` `G` | Top / bottom of file · `{n}G` line n |
| `%` | Jump to matching bracket |
| `*` / `#` | Search word under cursor fwd / back |
| `Ctrl+o` / `Ctrl+i` | Jump back / forward (jumplist) |
| `` `` `` / `` `. `` | Back to last jump / last edit |

### The multipliers
| Keys | Action |
|---|---|
| `.` | **Repeat last change** (the #1 time-saver) |
| `cgn` | Change next search match, then `.` to repeat (multi-cursor) |
| `qa … q` then `@a` | Record macro to reg a, replay · `@@` repeat last |
| `:%s/old/new/gc` | Substitute all, confirm each (`\<word\>` = whole word) |
| `:g/pat/normal @a` | Run macro `a` on every line matching pat |
| `>` `<` (visual) | Indent / dedent · `=` auto-indent |
| `za` `zR` `zM` | Toggle fold / open all / close all |
| `"ay` … `"ap` | Yank to register a … paste from a (`"0p` = last yank) |

### File picker (`Space Space`) — hidden & gitignored files
| Keys | Action |
|---|---|
| `Space Space` | Find files in the **project root** · `Space f F` in the current dir |
| Hidden files (`.env`, `.github/…`) | **Already shown** (config: `files = { hidden = true }`) |
| `Alt+i` (⌥i) inside the picker | Toggle **gitignored** files (e.g. `node_modules`, `bin/`, `.env` if ignored) |
| `Alt+h` (⌥h) inside the picker | Toggle hidden files |
| `Esc` | Picker from typing to normal mode (`j/k` move, `Enter` open) · `Esc` again closes |
| `Space s g` / `Space /` | Grep text in the project (same ⌥i / ⌥h toggles) |
The picker opens ready to type — the ⌥ toggles work while typing too (Ghostty sends Option as Alt).

### Search only inside a folder or a block
| Where | Keys |
|---|---|
| **A folder** — grep text | `Space e` (explorer) → cursor on the folder → `Space /` |
| **A folder** — find files | explorer → cursor on the folder → `Ctrl+c` (make it nvim's cwd) → `Space f F` · undo with `:cd -` |
| Explorer itself | `I` show gitignored · `H` hidden · `.` focus folder as root · `Backspace` up |
| **A block of text** in the file | Select it (`V` + `j`/`k`, or `vip`) → `Esc` → `/\%Vword` searches only inside that selection (`n` next) |
| Replace inside a block | Select → `:` (shows `'<,'>`) → `s/old/new/g` |

---

## GitHub flow

**Typical loop:** branch → commit (lazygit) → push → open PR (`gh`/octo) → review → checks pass → merge.

### gh CLI — pull requests
| Command | Action |
|---|---|
| `gh pr create --fill` | Create PR from current branch (`-w` opens browser) |
| `gh pr list` / `gh pr status` | Open PRs / your PR overview |
| `gh pr checkout <n>` | Check out PR #n locally |
| `gh pr view <n> -w` | View PR (browser) · `gh pr diff <n>` show diff |
| `gh pr review <n> --approve` | Approve (`--request-changes -b "…"`, `--comment`) |
| `gh pr merge <n> --squash -d` | Merge & delete branch (`--rebase` / `--merge`) |
| `gh pr ready` / `gh pr close <n>` | Mark ready / close |

### gh CLI — issues & repo
| Command | Action |
|---|---|
| `gh issue list` / `gh issue create` | List / create issue |
| `gh issue view <n> -w` | Open issue in browser |
| `gh repo view -w` | Open repo in browser |
| `gh search prs --author @me --state open` | Find your open PRs across repos |

### GitHub Actions (via gh)
| Command | Action |
|---|---|
| `gh run list` | Recent workflow runs |
| `gh run view <id>` | Run summary · `--log` full logs · `--log-failed` only failures |
| `gh run watch <id>` | Live-watch a run until it finishes |
| `gh run rerun <id>` | Re-run (`--failed` only failed jobs) |
| `gh run cancel <id>` | Cancel a run |
| `gh workflow list` | List workflows |
| `gh workflow run <file> -f key=val` | Trigger a `workflow_dispatch` run |
| `gh workflow enable/disable <file>` | Toggle a workflow |

### octo.nvim (review inside nvim)
| Command / Keys | Action |
|---|---|
| `:Octo pr list` / `Space op` | Browse PRs |
| `:Octo pr checkout` | Check out the open PR |
| `Space or` (`:Octo review start`) | Start review (panel of changed files) |
| `:Octo review submit` | Submit approve / request-changes / comment |
| `:Octo comment add` | Add comment on selected lines |
| `:Octo pr merge rebase` | Merge the PR |
| `]q` / `[q` | Next / previous review thread |

### lazygit (popup: `prefix g`, or `Space gg` in nvim)
| Keys | Action |
|---|---|
| `Space` | Stage / unstage file or hunk |
| `c` | Commit · `C` commit with editor · `A` amend last |
| `P` / `p` | Push / pull |
| `b` | Branches view · `n` new branch · `Space` checkout |
| `Enter` | Expand files / enter panel · `Tab` cycle panels |
| `d` | View diff / discard · `z` undo · `/` filter |
| `1`–`5` | Jump to panel (status/files/branches/commits/stash) |
| `x` | Open the keybinding menu · `q` quit |

**Daily flow:** `prefix g` → `Space` stage files (or `Enter` on a file, then `Space` per hunk) → `c` write message → `Enter` commit → `P` push. New branch: `b` → `n`. Undo the last lazygit action: `z`.

| Problem | Fix |
|---|---|
| `Esc` | Goes back / cancels inside lazygit — also in nvim (`Space gg`), fixed 2026-10-26 |
| Commit message editor opens nvim inside lazygit (`C`) | Write, then `:wq`; or use `c` for a one-line message |
| Wrong author on the commit | `git config user.email` in that repo — the identity follows the folder (gitid, planned) |

---

## Languages — zero setup

Tooling auto-loads by filetype — open a file and it just works:
**Go · Rust · TypeScript/React · Python · Docker · Terraform · JSON · YAML · Markdown · TOML**

Per-project tweaks: drop a `.neoconf.json` in the repo root (rare — only for settings that differ per project).

---

## Ghostty

| Keys | Action |
|---|---|
| `Cmd+T` / `Cmd+W` | New / close tab · `Cmd+1..9` go to tab |
| `Cmd+D` / `Cmd+Shift+D` | Split right / down |
| `Cmd+,` / `Cmd+Shift+,` | Open / reload config |
| `Shift+Enter` | Newline (Claude Code) |

Theme: `theme = moss` (vivid green `#3fd468` on near-black, no blue; the same colors in tmux, nvim, prompt, bat, fzf, lazygit, Claude Code `dark-ansi`) — file `ghostty/themes/moss`. Font: IBM Plex Mono (BlexMono Nerd Font Mono, with icons), size 17, taller lines, opaque, 12 px padding. In nvim the focused window has the theme background; other windows are slightly darker. The mouse pointer hides while you type.

---

## tmux plugins, windows & tabs

| Key / command | Action |
|---|---|
| `prefix y` | **Claude popup** for the current dir (tmux-claude-hatch); `prefix d` closes it, Claude keeps running |
| `prefix u` | **Agent picker**: every running Claude with status (working / waiting / idle), live preview; ENTER jump · `ctrl-x` kill |
| `prefix C-s` · `prefix C-r` | Save / restore sessions (resurrect). Auto-save every 15 min, auto-restore when tmux starts (continuum) |
| `prefix I` · `prefix U` | Install / update tmux plugins (TPM) |
| `t` | Attach to tmux from any plain shell |

**Windows & tabs:** only the **first** Ghostty window auto-attaches to tmux. New Ghostty tabs/windows are plain shells (cheatsheet, Kali, one-offs); type `t` to join tmux there. A bell (highlighted window in the status bar) = a Claude session needs you.

---

## Databases — sqmeow.nvim (`<leader>D`)

**Open it:** in nvim `Space D d` · from any shell **`db`** (drawer + query result, no start screen) · **`dbadd`** (straight to "new connection"). `:q` / `:qa` quits. sqmeow lives inside nvim — no separate app; shell commands like `new db` don't exist.

**New-connection form** — a list of rows (checked against sqmeow's code):
1. `j`/`k` (or `Tab`/`Shift+Tab`, arrows) pick a row → `Enter` (or `i`) opens it for typing.
2. Type → `Enter` saves the row **and jumps to the next one** (that's normal). `Esc` leaves a row without moving.
3. **Required for Postgres: Name and User.** Everything else is optional — grey text is only a hint, an empty row means: Host `localhost`, Port `5432`, Database = all, no password, **no options** (so for Neon/cloud type `sslmode=require` yourself).
4. **Save: `Ctrl+s`** — works in the list *and* while typing in a row. If nothing closes, read the **red text in the bottom border** (e.g. "User cannot be empty") and fill that row.
5. `Enter` on **Read only** toggles it (tick for prod) · `q` cancels.
Password: put `{{ exec "op read op://<vault>/<item>/password" }}` in the row instead of the real password.

First run: `:Sqmeow install` then `:checkhealth sqmeow`.

| Key | Action |
|---|---|
| `<leader>Dd` · `<leader>Da` · `<leader>Ds` | Drawer · add connection · new scratchpad |
| `<leader>Dl` · `<leader>Dc` | Query log · cancel query |
| Drawer: `<CR>` · `u` · `p` · `K` · `?` | Connect/expand · make active · preview table · structure · all keys |
| Drawer, on a connection: `e` · `R` · `d` · `A` · `r` | **Edit** it · rename · delete · add another · reload |
| Scratchpad: `<CR>` · visual `<CR>` · `<leader>E` | Run statement · run selection · run buffer |
**Query workflow** (three areas: left = drawer, right = scratchpad where you write SQL, bottom = results):
1. Drawer: cursor on the connection → `u` (use it — bottom bar changes from "not connected").
2. Browse: `Enter` expands schema → Tables · on a table `p` = first page of rows in the results · `K` = columns/structure · `s` = copy a ready `SELECT` for it.
3. Write: move to the right window (`Ctrl+l`) — or `Space D s` for a new scratchpad — paste (`p`) or type SQL.
4. Run: cursor on a statement → `Enter` (normal mode) · select several lines → `Enter` · whole buffer → `Space E` · stop a slow query → `Ctrl+c`.
5. Results (bottom): `L`/`H` next/prev page · `K` show one row vertically · `s` sort by column · `x` export · `q` close.
`?` in any sqmeow window lists every key. Move between the three areas with `Ctrl+h/j/k/l`.
**Which DB does a query hit?** (from sqmeow docs) → the scratchpad's **pin** if it has one (`:Sqmeow bind <connection>` · `:Sqmeow bind none` clears), otherwise the **active** connection — the one you pressed `u` on, shown in the bottom bar. Switch = `u` on another connection.
Connection saved without a database (= all DBs): in the drawer `Enter` on a database opens it as its own connection `acme-local/app_db` → `u` on that. Or save the DB in the connection (`e` → Database).
**Scratchpads persist** — make one per topic (`Space D s`, or `a` in the drawer), reopen it later from the drawer's **scratchpads** node; a pinned scratchpad remembers its DB.

Passwords: `{{ exec "op read op://Private/<item>/password" }}` (1Password, recommended) · `{{ env "VAR" }}` (from `~/.secrets`) · plain URL only for local throwaway DBs. Tick **Read only** for prod.
Guide: `~/vault/projects/dev-setup/guides/sqmeow-databases.md`

---

## OrbStack & Kali

| Command | Action |
|---|---|
| `orb -m kali` · `ssh kali@orb` | Shell in Kali (in current dir) · SSH (scp/rsync work too) |
| `orb start kali` · `orb stop kali` · `orb list` | Start · stop (frees CPU/RAM) · list machines |
| `orb push <file>` · `orb pull <file>` | Copy Mac → Kali · Kali → Mac |
| `orb clone kali kali-clean` | Snapshot before experiments |
| Mac files inside Kali | same path: `/Users/<you>/…` |
| Kali files on the Mac | `~/OrbStack/kali/home/<you>/…` |
| `docker …` | Runs on OrbStack (Docker Desktop is gone) |

Inside Kali, tmux + nvim use the same dotfiles (symlinked). Nested tmux: `C-a C-a` reaches the inner one.
Guide + learning links: `~/vault/projects/dev-setup/guides/kali-orbstack.md`

---

## Claude Code — daily commands & where config lives

| Command | Action |
|---|---|
| `/copy` | Copy my last reply as clean markdown (**use this instead of selecting text** — terminal copy joins/splits lines) |
| Sessions: find / resume / pin / keep | see **Claude sessions** below (`prefix a`) |
| `/mcp` | See / toggle connected MCPs for this session |
| `/model` | Switch model / effort |
| `/plugin` | Plugins (LSP: gopls, typescript, pyright) |
| `! <cmd>` | Run a shell command directly, no model round-trip |
| `claude mcp list` | MCPs for the current folder (user + local scope) |
| `claude -w` | Start a session in its own git worktree (parallel work on one repo) |

| What | Where |
|---|---|
| Global rules | `~/.claude/CLAUDE.md` (copy: `~/.dotfiles/claude/`) |
| Settings, allowlist, plugins | `~/.claude/settings.json` (copy: `~/.dotfiles/claude/`) |
| MCPs (user + per-project local scope) | `~/.claude.json` — manage with `claude mcp add/remove -s user|local` |
| Project → vault pointer | `CLAUDE.md` **outside the repo** (engagement root or the repo's parent folder) → `Vault: ~/vault/projects/<slug>/index.md`. Claude loads parent-folder `CLAUDE.md` files, so team repos stay untouched. Layers explained: `~/vault/projects/dev-setup/concepts/claude-instruction-layers.md` |
| Paused skills | `~/.claude/skills-paused/` (move back into `~/.claude/skills/` to re-enable) |
| Rollback of the 2026-09-27 setup | `cp -R ~/.claude/backups/2026-09-27/* ~/.claude/` |

Global MCPs: **context7** only. Per project (local scope): **graphify** in each project with a code graph (`brain status`).

---

## Claude sessions — find, resume, pin, keep

A *Claude session* = one conversation (its own id, transcript, folder). Not a tmux session: closing or killing tmux never deletes it.

| Do | How |
|---|---|
| **Find & reopen any session, any folder** | tmux **`prefix a`** (or `devctl sessions`) → type part of the name or folder → **ENTER**. It opens in its own folder in a new tmux window (`claude --resume` for you, no `cd`). If it's already running (●), ENTER jumps to that pane instead of opening it twice |
| **Name** a session | inside it: `/rename <name>` · or start named: `claude -n <name>` |
| **Pin** a session (keep it) | inside it: `! devctl pin --name "label"` · or in the picker: `ctrl-p` (toggle) |
| **Unpin** | picker `ctrl-p` again · or `devctl unpin <id>` |
| Show pinned only / all | picker `ctrl-s` / `ctrl-a` · or `devctl sessions --pinned` |
| Plain list (no picker) | `devctl sessions --list` |
| Continue the last session in *this* folder | `claude --continue` · pick from this folder only: `/resume` or `claude --resume` |
| Parallel work on one repo | `claude -w` (own git worktree) · running agents overview: `prefix u` (hatch) |

**Symbols in the picker:** `★` pinned · `●` running now · `★⌂` pinned and restored from the archive (Claude already deleted the original) · bottom preview = the session's last prompt.

**What is kept, what expires:**
- **Unpinned** sessions: Claude Code deletes them after **30 days without use** (`cleanupPeriodDays` in `~/.claude/settings.json`). Using a session resets the clock.
- **Pinned** sessions: kept for good. Pinning copies the transcript + label + folder to `~/.local/share/devctl/sessions/`; the copy is refreshed every time that session ends; ENTER on a `★⌂` session restores it and resumes.
- **All automatic, nothing to run:** Claude Code does its cleanup itself when it starts (last run is stamped in `~/.claude/.last-cleanup`). Archiving pinned sessions happens at pin time and at every session end (hook). The archive is never deleted automatically; only `unpin` removes a copy.
- Pins list: `~/.local/state/devctl/pins.tsv` (session id · label · folder).
- Good habit: `/rename` sessions you'll want again; pin the ones that are long-running work (a client engagement, this setup).

---

## devctl — dev servers & long runs (nothing left running)

Why: forgotten `npm run dev` / stuck pytest drained the battery. Everything long-running goes through `devctl`, which records it and stops it when the Claude session ends.

| Command / key | Action |
|---|---|
| `devctl run --name api -- npm run dev` | Start detached in its own process group, log to file, record it |
| `devctl ps` | Tracked processes + **untracked dev orphans** + their listening ports |
| tmux `prefix k` | Picker over `devctl ps` — TAB select, ENTER stop |
| `devctl logs <id>` · `devctl logs <id> -f` | Last 100 lines · follow |
| `devctl stop <id>` · `--here` · `--all` | Stop one · everything started under this dir · everything tracked |
| `devctl kill-pid <pid>` | Stop an untracked orphan (and its group) |
| `devctl prune` | Drop dead entries, delete logs older than 7 days |

**Claude side (hooks in `~/.claude/settings.json`):** a PreToolUse guard blocks `&` / `nohup` and backgrounded dev servers/tests unless started via `devctl run`; SessionEnd stops everything that session started. Disable the guard for one session: `DEVCTL_GUARD=0 claude`.
**Files:** ledger `~/.local/state/devctl/ledger.jsonl`, logs `~/.local/state/devctl/logs/`.

---

## Git identity per folder — gitid (new 2026-10-26)

Each folder has one identity (name, email, SSH key). Git picks it from the folder, so parallel sessions and agents never mix accounts. In a folder with no rule, git refuses to commit and tells you to set an identity.

| Command | Does |
|---|---|
| `gitid` | Show the identity git uses here and where it comes from |
| `gitid list` | All profiles and folder rules |
| `gitid set` | Pick a profile (fzf) for this repo's folder |
| `gitid check` | Every repo under `~/Documents` with the email it will use |
| `gitid apply` | Rebuild after editing `~/.config/gitid/profiles.tsv` or `folders.tsv` |
| `gitid backup` · `gitid restore` | Save both files to 1Password · get them back on a new Mac |

Profiles: `gitid list`. The default profile covers `~/Documents`, dotfiles and vault; each client folder has its own. A repo's own `git config --local user.email` still wins over the folder rule.

**How to use it:**
1. Before you commit in a repo, run `gitid`. It prints the name, email and SSH key git will use.
2. If it says "no identity here", run `gitid set` and pick the profile. The rule covers that folder and everything below it.
3. New client: add a line to `~/.config/gitid/profiles.tsv` (`profile`, name, email, key file in `~/.ssh`), add its folder to `folders.tsv` above `~/Documents`, then run `gitid apply && gitid backup`.
4. Check all repos at once: `gitid check`. "(repo setting overrides)" means the repo has its own `user.email`; remove it with `git config --unset user.email` in that repo if it is wrong.
5. Claude sessions and agents need nothing: they commit in a folder, so they get that folder's identity.

Files: `~/.config/gitid/profiles.tsv`, `~/.config/gitid/folders.tsv` (private: client names stay out of the public repo; copy in 1Password) → generated `~/.config/git/gitid/` (never edit by hand). Format: `~/.dotfiles/git/*.example.tsv`.

## 1Password setup — step by step (2026-10-26)

Do these once. Secret values go from your Mac straight into 1Password; Claude never sees them.

1. Create the personal vault: `op vault create "<vault>" --icon id-card`; `setup.sh --personal` writes it to `~/.config/dotfiles/personal.env` as `OP_VAULT`, which every script uses.
2. Move the secrets out of shell history: `history-secrets --save-all` (or `history-secrets` to choose per secret). Then run `exec zsh` in every open shell.
3. Rotate the long-lived tokens it found (DigitalOcean, GitHub, 1Password service account).
4. Import the SSH keys in the 1Password app: New Item → SSH Key → Add Private Key → Import → pick each key from `~/.ssh` (the key files named in `gitid list`).
5. Turn on 1Password → Settings → Developer → **Use the SSH agent**.
6. Tell Claude "SSH keys are in 1Password" — it switches gitid and `~/.ssh/config` to the agent (keys then leave the disk).
7. Coolify API token: `secret-put "Coolify sensei API" credential`, paste the token.

Check: `history-secrets --scan` finds 0 · `op item list --vault "$OP_VAULT"` lists the items.

## Secrets — 1Password first

| Command | Action |
|---|---|
| `op signin` | Unlock the 1Password CLI for this shell (Touch ID via the 1Password app) |
| `op read "op://Private/<item>/<field>"` | Print one secret (pipe it, don't paste it) |
| `op run --env-file=.env.tpl -- npm run dev` | Run with secrets injected; `.env.tpl` holds `KEY=op://…` refs, safe to commit |
| `op item create --category "API Credential" --title "<name>" --vault Private credential=<value>` | Save a new secret |
| `secret` · `secret pick` · `secret get <name>` · `secret ls` | New secure note (name → paste → Ctrl-D) · same with type picker · copy value to clipboard (cleared after 45 s) · list. Touch ID sign-in if needed; values go to op via stdin, never argv |
| `secret-put "<title>"` · `secret-put --from-doctl personal` · `secret-put --list` | Store a secret with a hidden prompt · copy doctl's token into 1Password · list what's stored (titles only) |
| `vault-secrets-to-1password` · `--apply` | Dry run · back up every `~/vault/**/sensitive/` file to 1Password (Documents, tag `vault-sensitive`) |
| `gitleaks git --pre-commit --staged` | What the pre-commit hook runs (dotfiles + vault) |

**Automatic:** when Claude writes a file containing a secret, `secret-guard` flags it and suggests 1Password. Commits to dotfiles/vault with a secret are blocked by gitleaks. False positive → add its fingerprint to `.gitleaksignore`.
Where secrets may live locally: `~/.secrets` (shell env), `~/vault/projects/*/sensitive/` (gitignored). Nowhere else.

---

## sensei CLI

One command for the sensei VM: Coolify API plus ssh helpers. A missing name opens an fzf picker.

| Command | Action |
|---|---|
| `sensei` | fzf menu of all commands |
| `sensei ls` | Coolify resources: name, type, status, URL |
| `sensei share [dir]` | Quick share a folder: name → auth? → users → confirm → files to `/data/sites/<name>/`, Coolify service, deploy, wait for HTTPS. Passwords go to 1Password "sensei share <name>" |
| `sensei logs [name] [lines]` | Runtime logs (default 200 lines) |
| `sensei restart [name]` | Restart (after nginx.conf or htpasswd changes) |
| `sensei down [name]` | Delete the resource, `/data/sites/<name>` and the 1Password item (asks y/N first) |
| `sensei ssh [-- cmd]` · `sensei ps` · `sensei df` | Shell · containers · disk and memory |

Token (once): Coolify → Keys & Tokens → create an API token (`read:sensitive` or root, so `logs` works). Then run `secret-put "Coolify sensei API" credential` and paste it. Without it, `ps`, `df` and `ssh` work; the API commands stop with this hint.

---

## Quick share on sensei — a page on its own subdomain, no git

`N=<name>` → lands at `https://$N.sensei.internal.nimbus-tech.io` (wildcard DNS + auto HTTPS, nothing to set up). Notes: `vault homelab` → working-notes/quick-shares.md · how Coolify works + git/Express recipes: concepts/coolify.md. In any Claude session just say "deploy this to sensei" — skill `sensei-deploy` loads.

| Step | Command / click |
|---|---|
| 1. Users | `openssl rand -base64 18 \| tr -d '/+=' \| cut -c1-20` per person → `printf '%s:%s\n' <user> "$(openssl passwd -apr1 <pass>)" >> htpasswd` (keep passwords in `vault/projects/homelab/sensitive/`) |
| 2. Files up | `cp ~/Documents/sensei-sites/curve-survey/nginx.conf .` then `scp index.html nginx.conf htpasswd sensei:/tmp/` |
| 3. Place | `ssh sensei "D=/data/sites/$N; sudo mkdir -p \$D/html && sudo install -m644 /tmp/index.html \$D/html/ && sudo install -m644 /tmp/nginx.conf \$D/ && sudo install -m640 -g101 /tmp/htpasswd \$D/ && rm /tmp/{index.html,nginx.conf,htpasswd}"` |
| 4. Coolify | project **quick-shares** → + New Resource → *Docker Compose Empty* → paste compose below → General: name `$N` → Domains: + Add, `https` · `$N.sensei.internal.nimbus-tech.io` · port 80 → Actions → Deploy |
| 5. Check | `curl -so /dev/null -w '%{http_code}\n' https://$N.sensei.internal.nimbus-tech.io` → 401; with `-u user:pass` → 200 |
| Update page | redo 2–3 for `index.html` only — live instantly, no redeploy |
| Update users/conf | redo 2–3, then Coolify → Actions → Restart |
| Take down | Coolify resource → Danger Zone → Delete, then `ssh sensei sudo rm -r /data/sites/$N` |

```yaml
services: {<name>: {image: 'nginx:1.27-alpine', volumes: ['/data/sites/<name>/html:/usr/share/nginx/html:ro', '/data/sites/<name>/nginx.conf:/etc/nginx/conf.d/default.conf:ro', '/data/sites/<name>/htpasswd:/etc/nginx/.htpasswd:ro']}}
```
One line on purpose — Coolify's editor auto-indents multi-line YAML when pasted/typed. Public page (no auth)? Drop the `auth_basic` lines from nginx.conf and the htpasswd volume.

---

## Activity board — activity-tracker (new 2026-10-26)

Your personal board: what you work on across all projects, shown in fuda.

- Repo: `~/Documents/sensei/activity-tracker` (private on GitHub once created: `gh repo create nemanja-mudrinic-nimbus-tech/activity-tracker --private --source . --remote origin --push`).
- Columns: Backlog → Next → In progress → Waiting. Done tasks move to `docs/board/archive/`.
- One task = one file `docs/board/tasks/AT-<n>.md`. Copy one, take the next number, set `status`, `labels` (`type:` · `project:` · `source:`).
- Claude can add or move tasks for you: "add a task to the activity board: …".
- `recap` (any shell) summarises today's Claude sessions → `~/.local/share/recap/<date>.md`: done · found while working · where we stopped · proposed tasks (board or todo). `recap --dry-run` shows what would be sent; `recap 2026-10-25` for another day. Runs only when you start it.

## Agent workflow skills (mattpocock-skills)

The old `/dark-factory` skill was removed on 2026-10-25. A new factory is in design. gamble's factory notes are in `~/Documents/sensei/gamble/docs/factory/`.

Building blocks you can use now: `/grill-with-docs` interrogate a plan · `/to-spec` thread → spec · `/mattpocock-skills:wayfinder` multi-session decision map · `/to-tickets` spec → slices · `/implement-spec` · `/tdd` · `/code-review` · `/diagnosing-bugs` · `/retro` lessons → rules · `/setup-matt-pocock-skills` once per repo.

---

## Check that it works — look and tools (added 2026-10-25)

Run `doctor` first: it checks every package, link, font, desktop tool and Claude plugin, and prints a fix for each FAIL. `setup.sh --update` upgrades everything.

Colours are "moss": near-black `#151719`, vivid green `#3fd468`, amber strings, teal functions, purple types, no blue. Font: IBM Plex Mono (BlexMono Nerd Font) 17.

| Tool | Do this | Expect |
|---|---|---|
| Ghostty | Open a new window (`Cmd+N`) | Opaque near-black, padding around the text, Plex font |
| Starship prompt | Open a new pane (`prefix \|`) | `folder ➜` in green on the left; git branch on the right |
| `ls` / `ll` | Run both | `ls` = short grid with icons · `ll` = long list without the user column |
| bat | `bat ~/.dotfiles/tmux.conf` | Moss colours |
| fzf | `Ctrl+T` | List at the top, slim green marker, file preview |
| atuin | `Ctrl+R` | Searchable history; `Enter` puts the command on the line |
| tmux bar | Look at the top | Green session pill · windows `name │ number` · amber folder pill |
| sessionx | `prefix s` | Sessions left, preview right; type a new name + `Enter` = new session |
| floax | `prefix F` twice | Floating shell opens, then hides |
| URL picker | `prefix Ctrl+u` in a pane with a link | List of links; `Enter` opens it |
| Claude sessions | `prefix a` | Aligned rows, `~` paths, `●` = running |
| lazygit | `prefix g` | Green active border |
| nvim | Open a `.go` or `.py` file | Keywords green, functions teal, types purple, strings amber, NORMAL block green |
| nvim focus | `Space s v` | The focused split is lighter than the other one |
| AeroSpace | `Alt+1`, `Alt+2`, `Alt+H/L` | Workspaces switch, focus moves |
| SketchyBar | Look at the top of the screen | Floating bar: workspaces with app icons (focused = green), clock, battery, CPU, Claude count |
| borders | Click another window | Green border moves with focus |
| Maccy | `Shift+Cmd+C` | Clipboard history |
| Claude Code | Start a new session | Amber/sage colours (`dark-ansi`). The input cursor stays blue — Claude draws it itself |

**Secure Input (lock icon at the bottom right).** When a password field has focus (1Password, `sudo`, `op signin` in Ghostty), macOS turns on Secure Input. While it is on, no app can read keys, so AeroSpace's `Alt` shortcuts do nothing and show a warning. Close or leave the password field and the shortcuts work again.

**Secrets in shell history:** `history-secrets --scan` lists them (masked) · `history-secrets` asks per secret: save to 1Password, delete, or keep — then cleans `~/.zsh_history` and atuin.

## Desktop — AeroSpace, SketchyBar, Maccy (new 2026-10-25)

AeroSpace puts windows in tiles. SketchyBar replaces the macOS menu bar. Borders draws a green line around the focused window. Maccy keeps a clipboard history. Raycast is removed.

`Alt+B`, `Alt+F`, `Alt+D`, `Alt+Y`, `Alt+.` and `Option+Delete` are not bound here. They still edit text in zsh and in Claude Code.

| Keys | Does |
|---|---|
| `Alt+H` / `J` / `K` / `L` | Focus the window to the left / below / above / to the right |
| `Alt+Shift+H` / `J` / `K` / `L` | Move the window left / down / up / right |
| `Alt+1` … `Alt+5` | Go to workspace 1–5 |
| `Alt+Shift+1` … `Alt+Shift+5` | Move the window to workspace 1–5 |
| `Alt+Tab` | Go back to the last workspace |
| `Alt+/` | Tiles layout; press again to change the direction |
| `Alt+,` | Accordion layout; press again to change the direction |
| `Alt+Shift+F` | Fullscreen on / off (AeroSpace, not macOS fullscreen) |
| `Alt+Shift+Space` | Float / tile the window |
| `Alt+-` / `Alt+=` | Make the window smaller / larger |
| `Alt+Shift+T` | Open Ghostty |
| `Alt+Shift+B` | Open Dia |
| `Alt+Shift+;` | Service mode (the next key does one thing, then you are back) |
| Service mode: `R` / `Backspace` / `Esc` | Reset the layout · close all windows except the focused one · reload the config and leave |
| `Shift+Cmd+C` | Open Maccy (clipboard history) |
| Maccy: `Enter` / `Option+Enter` | Copy the item / copy and paste it |
| Maccy: `Cmd+1…9` / `Option+1…9` | Copy / paste the item with that number |

### How AeroSpace works (read this first)

- **Workspace** = one full screen of windows, numbered 1–5. SketchyBar shows the numbers at the top; the green one is where you are. Only one workspace is visible at a time.
- **Layout** = how the windows on one workspace share the screen:
  - **tiles** — side by side (or stacked top/bottom). Nothing overlaps. Default.
  - **accordion** — all windows on top of each other, slightly offset; the focused one is in front. Looks like "overlapping".
  - **floating** — a normal macOS window you drag yourself (Finder, Settings, 1Password, Maccy float by default).
- **Focus** = the window that gets your keys. The green border shows it.
- New windows open on the current workspace, except Ghostty (→ 1), browsers (→ 2) and Slack (→ 3).
- With an external screen connected, workspace 1 always sits on it; unplug and it comes back to the laptop. Each screen shows one workspace at a time, so you see two at once.

| I want to… | Keys (Alt = Option ⌥) |
|---|---|
| Go to another workspace | `Alt+1` … `Alt+5` · `Alt+Tab` = back to the last one |
| Move focus to the window left / right / up / down | `Alt+H` / `L` / `K` / `J` |
| Swap the focused window with its neighbour | `Alt+Shift+H` / `L` / `K` / `J` |
| Send the focused window to workspace N | `Alt+Shift+N`, then `Alt+N` to follow it |
| Windows overlap → put them side by side | `Alt+/` (tiles). Press again: top/bottom |
| Stack them on purpose (one in front) | `Alt+,` (accordion); `Alt+H`/`L` flips through them |
| One window full screen for a moment | `Alt+Shift+F` (again = back) |
| Make the focused tile wider / narrower | `Alt+=` / `Alt+-` |
| Take a window out of the tiles (float) and back | `Alt+Shift+Space` |
| Layout is a mess | `Alt+Shift+;` then `R` (reset this workspace) |
| Two screens: jump to the other screen | `Alt+M` |
| Two screens: move this whole workspace to the other screen | `Alt+Shift+M` |
| Two screens: move only this window to the other screen | `Alt+Shift+N` (you follow it) |
| **Dia next to me / back to workspace 2** (one key, both ways) | `Alt+Shift+D` |

**Which key acts on what:**

| Key | Acts on | Switches between |
|---|---|---|
| `Alt+Shift+Space` | the focused **window** | floating ↔ tiled |
| `Alt+/` | all tiled windows on the **workspace** | side by side ↔ top/bottom |
| `Alt+,` | all tiled windows on the **workspace** | overlapping (accordion), direction flips on each press |

**Two rules:** (1) the keys act on the workspace of the window with the green border — click it or use `Alt+H/L` first. (2) You only see a layout change with two or more **tiled** windows; a floating window is outside the tiles and ignores `Alt+/` and `Alt+,`.

**Daily setup — Ghostty alone on the Dell, Dia when needed:** workspace 1 = Ghostty only (it fills the screen) · `Alt+Shift+D` brings Dia in, the screen splits half/half · `Alt+Shift+D` again sends Dia back to workspace 2 and Ghostty fills the screen again. If Dia lands on top instead of beside Ghostty, Ghostty is floating: click it, `Alt+Shift+Space`.

**Recipe — Ghostty left, Dia right, half and half:** `Alt+1` → click Dia; if it floats, `Alt+Shift+Space` → `Alt+/` until side by side → if Ghostty is on the right, click it and `Alt+Shift+H` → wider/narrower: `Alt+=` / `Alt+-` on the focused side.

**Recipe — Dia next to the terminal, then back:** `Alt+Shift+B` (Dia comes to the front, AeroSpace jumps to its workspace) → `Alt+Shift+1` (send Dia to 1) → `Alt+1` (terminal and Dia side by side) → work → focus Dia, `Alt+Shift+2` (Dia back to 2).

Workspaces: 1 terminal (Ghostty), 2 browser (Dia, Chrome), 3 Slack, 4 notes, 5 other. Ghostty, browser and Slack windows go to their workspace automatically. Finder, System Settings, 1Password and Maccy windows float.

The bar shows the workspaces that have windows (focused one in green), the app in front, the clock, the battery and the number of Claude panes in tmux. If a Claude session waits for input, the Claude item turns amber. The next meeting shows only when the agenda app writes `~/.local/state/agenda/next-meeting`.

Reload: AeroSpace reloads when you save its config (or `Alt+Shift+;` then `Esc`) · SketchyBar `sketchybar --reload` · Borders: run `~/.config/borders/bordersrc`.

Do these once:
1. Open AeroSpace with `open -a AeroSpace`.
2. Give AeroSpace access in System Settings → Privacy & Security → Accessibility.
3. Run `~/.dotfiles/macos/defaults.sh`. It hides the Dock and the menu bar, turns off separate Spaces per display, and groups windows by app in Mission Control.
4. Log out and log in again.
5. Open Maccy → Settings → turn on "Launch at login".

Configs: `~/.dotfiles/aerospace/`, `sketchybar/`, `borders/`, `macos/defaults.sh`.

## Shell — prompt and history (changed 2026-10-25)

| Keys / command | Action |
|---|---|
| `Ctrl+R` | **atuin** — fuzzy search all history (folder, exit code, time). `Enter` puts it on the line, `Tab` edits it, `Ctrl+R` again cycles global / host / session / folder |
| `↑` / `↓` | Unchanged: history substring search (type `git`, then `↑`) |
| `atuin stats` | Your most-used commands |
| Prompt | **Starship** (moss, omerxx layout): folder + `➜` on the left; git branch and status, duration, kube context, language versions on the right. Config `~/.dotfiles/starship/starship.toml` |

History is local only (no atuin account, no sync). Commands with tokens, keys or passwords are filtered and never stored (`~/.dotfiles/atuin/config.toml`).

## Line editing — zsh, Claude Code input, any shell in tmux

The same keys work in zsh and in the Claude Code input. Option works as Alt (Ghostty setting).

| Keys | Does |
|---|---|
| **Cmd+Left** / **Cmd+Right** | Start / end of line (Cmd+Left sends `Ctrl+A` twice, so tmux passes it through) |
| **Option+Left** / **Option+Right** | One word back / forward (same as `Alt+B` / `Alt+F`) |
| `Ctrl+W` | Delete back to the previous space (a whole path or `--flag=value`) |
| **Option+Delete** | Delete only the previous word |
| `Alt+D` | Delete the next word |
| `Ctrl+U` (or **Cmd+Delete**) | Delete from the cursor to the start of the line |
| `Ctrl+K` | Delete from the cursor to the end of the line |
| `Ctrl+Y` | Paste the text you deleted last (`Alt+Y` cycles older ones in Claude) |
| `Ctrl+_` | Undo the last edit (Claude input) |
| `Ctrl+E` | End of line (Cmd+Right sends this) |
| `Ctrl+A` **inside tmux** | Is the tmux prefix — press `Ctrl+A Ctrl+A` for start of line, or use Cmd+Left |
| Claude: `Ctrl+G` | Open the prompt in nvim for long edits; save and quit to return |

---

## Homebrew — taps and updates

| Command | Does |
|---|---|
| `brew update && brew upgrade` | Update all installed tools |
| `brew trust --formula <user>/<tap>/<formula>` | Trust one formula from a third-party tap. Homebrew ignores untrusted taps (no updates) |
| `brew untap <user>/<tap>` | Remove a tap that you do not use |
| `brew list --formula` · `brew outdated` | Show installed tools · show tools with updates |

If Homebrew says "taps are not trusted", trust only the formulas that you use, for example `brew trust --formula hashicorp/tap/terraform-ls`.

---

## Plannotator — review Claude's plans, replies and code in a web page

Local, open source. Your comments go back to Claude as its next message. Sharing is off (`PLANNOTATOR_SHARE=disabled` in zshrc).

| Command (in Claude) | Does |
|---|---|
| `/plannotator-last` | **Annotate Claude's last reply** in the browser — for chat-style work, no plan mode needed |
| `/plannotator-tui` | The same in the **terminal**: a popup opens over this session → pick a reply → annotate → `S` → Claude gets the feedback and acts on it (tmux only) |
| `/plannotator-annotate <file \| dir \| url>` | Annotate a spec, vault note, folder of docs or a web page |
| `/plannotator-review` · `/plannotator-review <PR url>` | PR-style review of uncommitted changes / a GitHub PR |
| Plan mode (`Shift+Tab`) | When Claude proposes a plan, the review page opens by itself |
| `plannotator sessions` · `--open 1` | List / reopen review pages (shell) |
| **`prefix P`** (Shift+p) → menu → **`L`** | Pick a running Claude session (preview of its screen) → it runs `/plannotator-last` → review its last reply in the **browser**; feedback goes back to that session |
| **`prefix P`** → menu → **`R`** | Pick a running Claude session → it runs `/plannotator-tui` → terminal popup with **that** session's replies → `S` → Claude acts on the feedback |
| **`prefix P`** → menu → **`T`** | Pick a markdown file in the current folder (preview) → annotate it in the **terminal** (`plannotator-tui`); feedback is copied to the clipboard — paste it into Claude |
| `pn last` · `pn tlast` · `pn file [dir\|file]` | The same pickers from any shell (terminal UI) |
| `pn web [dir\|file]` | Annotate a markdown file in the **browser**; the feedback prints in the shell. From a Claude session use `/plannotator-annotate <file>` instead — the feedback goes straight to Claude |
Only Claude sessions started **after** the plugin install know `/plannotator-last` — restart older ones.

In the web page: select text → comment / delete / "looks good" → **Send** → Claude revises.

---

## Context & memory — pick the right tool (on demand, not by default)

Default is lean: vault pointer + LSP + Explore. Heavier things are opt-in per project.

**Browse the vault:** `vault` (nvim at `~/vault`: index + file explorer — `Space e` toggles the same explorer; `Space mz` to read full-screen) · `vault projects/dev-setup/plan.md` (open one note) · in nvim: `<leader>vo` jump to note, `<leader>vs` search, `<leader>vb` backlinks, `gf` follow `[[link]]`, `<leader>e` file tree, `<leader>mz` full-screen reading.

| Need | Use | Default? |
|---|---|---|
| Why was X decided / client IDs / gotchas | Vault `~/vault/projects/<slug>/` (read via the project `CLAUDE.md` pointer) — edit in nvim `<leader>v…` | always |
| Where is X defined / who uses X / rename X | LSP plugins (gopls, typescript, pyright) — Claude uses them automatically | always |
| Broad "find everything about X" search | Ask Claude to use the **Explore** subagent — keeps main context clean | when searching wide |
| Current API of a library/framework | Context7 ("check Context7 for …") | when a library is involved |
| Code structure of a big / long-lived project | **Second brain** (graphify, below) | opt-in per project |

### brain — when to use it
- **Use it** for large repos you live in for months (big client codebases), and for "explain the architecture", "what does X touch", "is X ever called".
- **Skip it** for small or short jobs. LSP + grep are enough.
- **It is automatic:** when a graph exists, Claude can query it (graphify MCP) without you asking.
- **Keep it fresh:** a stale graph gives wrong answers. After big merges run `brain update .`; check age with `brain status` (`prefix b`).
- **Not the vault:** the graph lives in `~/.local/share/brain/`, and it has no link to `~/vault` notes.

### Second brain — do it yourself (`brain`)

**What it is:** a code map (graphify graph) of one project that Claude queries *before* reading files, plus the project's vault notes. Graph = *what calls what*. Vault = *why* (decisions, gotchas).

**When to use it — decide in 10 seconds**
| Use it | Skip it |
|---|---|
| Big repo (hundreds of files) or several repos in one engagement | Small repo, a script, a one-off fix |
| You'll work on it for weeks/months (a big client codebase) | A few days of work |
| Questions like "what calls X", "what breaks if I change Y", "how does a request flow" | "Where is X defined / rename X" → LSP already answers exactly, no graph needed |

**Good at / bad at** (learned on a large client repo)
- ✅ Blast radius of a *named* symbol (`graphify affected "compute_with_cache"` → every caller + tests) · proving something is never called · architecture overview
- ❌ "Find everything that does X" — it's **structural, not semantic** (matches names, not meaning) → use grep / ask Claude to search
- ❌ Anything across an HTTP call — the graph can't see that A calls B via an API; a "path" through `asyncio` is a shared import, not a call

**Set it up (once per project) — you run these**
```sh
cd ~/Documents/acme/pipeline            # 1. the root: the one live repo, or the folder holding all repos
ls ~/vault/projects/acme/index.md        # 2. vault project exists? (else: ~/vault/backfill/index.md)
nvim .graphifyignore                       # 3. scope: exclude vendored/generated code (node_modules/, .venv/, dist/, .yarn/, *.cjs, generated clients)
brain on acme .                          # 4. build graph + connect Claude + mark CLAUDE.md  (free, AST only, minutes on big repos)
graphify god-nodes --top 10                # 5. sanity: must be YOUR classes/services; s() a() n() = junk got in → fix step 3 → brain rebuild acme
claude  → /mcp                              # 6. graphify listed = done
```
Where the marker goes: the root's `CLAUDE.md` — or, if that repo has a tracked `CLAUDE.md`, the parent folder's (`~/Documents/acme/CLAUDE.md`). brain never edits tracked files.

**Is it working? — 1-minute check** (example project `acme`; swap slug/root for yours)
| # | Run | Expect |
|---|---|---|
| 0 | `brain status --all` | every vault project: brain `on` / `off(kept)` / `-`, and which code folder points to it |
| 1 | `brain status` | row `acme` · recent BUILT date · `mcp:on` · ~37k nodes |
| 2 | `tail -2 ~/Documents/acme/CLAUDE.md` | `Vault: ~/vault/projects/acme/index.md` + `Second brain: on — graph … (built <date>)` |
| 3 | `ls -l ~/Documents/acme/pipeline/graphify-out` | symlink → `~/.local/share/brain/acme/graphify-out` |
| 4 | `cd ~/Documents/acme/pipeline && graphify god-nodes --top 5` | real names (`OrderService`, `BillingClient`, `AuthGateway` …), not `s()` / `a()` |
| 5 | `cd ~/Documents/acme/pipeline && claude mcp list \| grep graphify` | `graphify: … ✔ Connected` |
| 6 | start `claude` there → `/mcp` | `graphify` listed |
| 7 | ask: *"use graphify: explain KratosClient"* | answer cites `services/core/clients/kratos.py` ~L37, and you see a `graphify` tool call in the transcript |
Any row fails → **Troubleshooting** below. Rows 1–5 pass but Claude doesn't use it → say "use graphify" explicitly, or check row 2 (the `Second brain: on` line is what tells Claude to query the graph first).

**Every day**
| Situation | Do |
|---|---|
| Start work | `claude` in the root (or any subfolder) — graph + vault pointer load automatically |
| Ask about structure | "use graphify: what calls `PlaygroundService`?" · "what breaks if I change `KratosClient`?" · "trace a request from the API to the DB for X" · "explain the architecture" |
| Quick look without Claude | `graphify explain "KratosClient"` · `graphify affected "AnalyticsError"` · `graphify path "A" "B"` · `graphify query "how is auth done"` · `brain report` · `brain open` |
| Cleaned up vault notes / markdown docs | **nothing** — the graph is code-only; Claude re-reads the vault index every session |
| After a big merge / refactor | `brain update .` (nvim `<leader>ob`) |
| After editing `.graphifyignore` or deleting lots of code | `brain rebuild acme` (update only merges — removed files never drop out) |
| Is it fresh? | `brain status` · tmux `prefix b` · nvim `<leader>oB` |
| Which projects use it / which don't? | `brain status --all` |
| Project over | `brain off acme` (keep graph) · `brain off acme --purge` (delete graph) |
| Something's broken (no graphify in `/mcp`, pointer line missing) | `brain on <slug> <root>` again — safe to repeat, re-wires everything |

**Vault side (the other half)**
- Claude reads only `~/vault/projects/<slug>/index.md` at start → keep it a **short map**: current work, reference notes, where history lives. Stale index = stale answers.
- Review it when the code changes shape (like a project that shrinks to one live repo): update paths, move finished notes to `history/`, drop what's wrong. Ask Claude: "review the acme vault project against the current code".
- Decisions/gotchas Claude learns get written back to `working-notes/`, `lessons-learned/`, `concepts/` (rules in `~/.claude/CLAUDE.md`).

**Troubleshooting**
| Symptom | Fix |
|---|---|
| `/mcp` doesn't list graphify | You started Claude outside the root → `cd` into it · `brain status` shows `mcp:off` → `brain on <slug> <root>` again |
| Answers mention code that no longer exists | `brain rebuild <slug>` |
| Top god nodes are `s()`, `a()`, `push()` | Minified/vendored JS in the graph → add its folder to `.graphifyignore` → `brain rebuild` |
| Claude ignores the vault | Check the root (or parent) `CLAUDE.md` has the `Vault:` line |
| Spending worries | brain strips all LLM API keys → builds are always free. Never run `graphify extract` / `label` / `cluster-only` by hand |

**Rules:** graphs live in `~/.local/share/brain/<slug>/`, never in repos or the vault · `graphify-out` in the root is a git-excluded symlink · MCP is local scope (never `claude mcp add -s project`).
**Live now:** see `brain status`.

---

## Graphify — code map for Claude (when it pays off)

**What it is:** a local, free tool that parses code (tree-sitter, no LLM) into a graph of files → functions → imports → calls (`graphify-out/graph.json`). Claude queries it through the graphify MCP. It's a *snapshot*, not a service — refresh after structural changes.

**Use it for:** "what calls X / what breaks if I change X" · refactors across modules/repos · first look at an unfamiliar big codebase · tracing a flow end to end.
**Try LSP first** for "where is X defined / who uses X / rename X" — exact and always current.
**Skip it** for small repos, single-file bugs, config/infra work, anything grep answers in one shot.

| Command | Action |
|---|---|
| `graphify update .` | Build / refresh graph for this folder (AST only, **free**) |
| `open graphify-out/graph.html` | Visual map in the browser (look once, for orientation) |
| `graphify-out/GRAPH_REPORT.md` | Plain-language summary: hubs, communities (read in nvim) |
| `graphify query "<question>"` · `graphify affected "X"` · `graphify god-nodes` | Ask the graph from the terminal |
| In Claude: "use graphify: what calls `X`?" | Claude queries the graph first |

⚠ **Cost trap:** if `GEMINI_API_KEY` (or another LLM key) is in your shell, `graphify extract` (without `--code-only`), `graphify label`, and `graphify cluster-only` (without `--no-label`) will **call Gemini and spend money**. Stick to `graphify update` / `--code-only` / `--no-label`.
