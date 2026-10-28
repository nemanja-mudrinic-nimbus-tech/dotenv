# Agent guide: set up a Mac from these dotfiles

This repo is a complete macOS development setup:
- Terminal: Ghostty, tmux, zsh, Starship, atuin, fzf.
- Editor: Neovim (LazyVim).
- Desktop: AeroSpace, SketchyBar, borders, Maccy.
- Claude Code: rules and skills.

One script installs it, and `bin/doctor` checks it.

A person who cloned the repo can start Claude Code in `~/.dotfiles` and type:

> Set up this Mac from the dotfiles. Follow AGENTS.md.

## Rules for the agent

- **Ask before each of these:**
  - `setup.sh --personal`
  - `macos/defaults.sh`
  - removing a `*.backup` file
- **Personal parts belong to the repo owner (Nemanja).** Use `--personal` only when the person says they are Nemanja. For anyone else, never apply them.
- **1Password is optional.** The default setup never needs it. Only `--personal` and the commands `secret-put`, `gitid backup/restore`, `history-secrets` and `sensei` use it.
- **Never print, copy or commit secrets.** Secrets live in 1Password or `~/.secrets`, which is not in git.
- **Do not commit or push** unless the person asks.
- **`sudo` and password prompts need the person.** Tell them to type the command with a `!` prefix in the Claude prompt, for example `! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`.
- **`setup.sh` runs a long time** (10–30 min on a new Mac). Run it in the foreground with a long timeout, or with `devctl run` when `devctl` is available.

## What gets installed

| Part | Default | `--personal` |
|---|---|---|
| Brewfile: terminal, editor, shell, CLI tools, desktop apps, fonts, OrbStack | yes | yes |
| Links from `links.tsv` (group `core`) | yes | yes |
| Oh My Zsh, tmux plugins, Node.js (nvm), language servers, Claude Code plugins and MCP | yes | yes |
| Desktop start: SketchyBar, borders, AeroSpace, Maccy | yes | yes |
| Brewfile.personal: 1Password CLI and work tools (Go, Kubernetes, cloud CLIs, databases) | no | yes |
| Personal settings `~/.config/dotfiles/personal.env` (asks for the 1Password vault), 1Password SSH agent config, sensei skill | no | yes |
| Git identity per folder (`bin/gitid`; private lists in `~/.config/gitid/`, restored from 1Password) | no | yes |

## Procedure

1. Make sure that macOS has the command line tools: `xcode-select -p`. If this fails, tell the person to run `! xcode-select --install` and wait for the dialog to finish.
2. If `brew` is missing, tell the person to install Homebrew with the `!` command above. It asks for their password.
3. Make sure that the repo is at `~/.dotfiles`. The scripts expect this path.
4. Run `~/.dotfiles/setup.sh` (or `~/.dotfiles/setup.sh --personal`, see the rules).
   - An existing file at a link location is moved to `<file>.backup`. Tell the person which files were moved.
5. Give the person the steps that only a human can do:
   1. **AeroSpace:** System Settings → Privacy & Security → Accessibility → turn on AeroSpace. Without it, the window keys do nothing.
   2. **macOS changes:** `macos/defaults.sh` hides the Dock and the menu bar (SketchyBar replaces it) and changes Spaces settings. Ask first. The person must log out and in afterwards: macOS reads the menu bar setting at login only. Until then SketchyBar runs but stays invisible, because the macOS menu bar covers it. The doctor check reads the setting, so it passes before the login.
   3. **Bar font:** `brew install --cask font-sf-pro` asks for the password, so the person runs it with the `!` prefix.
   4. **Ghostty:** open it once. If the font looks wrong, press Cmd+Shift+, to reload the config.
   5. **nvim:** open it once. lazy.nvim installs the plugins. Then quit and open it again.
   6. **Personal only:** 1Password app → Settings → Developer → turn on "Integrate with 1Password CLI" and "Use the SSH agent". When macOS asks if Ghostty can access data from other apps, click Allow.
6. Run `~/.dotfiles/bin/doctor` (personal checks run when the personal links exist). Each FAIL line has a fix. Do the fix, then run `doctor` again until it says "All checks passed." Some checks (AeroSpace running, nvim plugins) pass only after step 5.
7. Tell the person where to learn the keys:
   - In tmux, the prefix is Ctrl-a. Prefix then `?` opens the cheatsheet (`cheatsheet.md`).
   - AeroSpace uses Alt keys.
   - Maccy opens with Shift+Cmd+C.

## Repo layout

| Path | What |
|---|---|
| `setup.sh` | Installs and links everything. `--update` upgrades, `--personal` adds the owner's parts |
| `Brewfile`, `Brewfile.personal` | Homebrew packages (`brew bundle`) |
| `links.tsv` | Every link from `~/.dotfiles` into `~`. Read by `setup.sh` and `doctor` |
| `bin/` | Commands on the PATH: `doctor`, `gitid`, `devctl`, `skills`, `recap`, `sensei`, `secret-put`, … |
| `ghostty/`, `tmux.conf`, `zsh/`, `starship/`, `atuin/`, `fzf/`, `lazygit/`, `nvim/` | Terminal, shell and editor configs |
| `aerospace/`, `sketchybar/`, `borders/`, `macos/` | Desktop configs |
| `claude/` | Claude Code: global `CLAUDE.md`, `settings.json`, `rules/`, own `skills/`, open-source `skills-library/` |
| `git/` | gitid example files (the real lists are private, in `~/.config/gitid/`) |
| `cheatsheet.md` | All keys and commands (tmux prefix `?`) |

## Changing the setup

- **New tool:** add it to `Brewfile`, or to `Brewfile.personal` for work-only tools. `doctor` checks it automatically.
- **New config file:** put it in the repo, then add a line to `links.tsv`. `setup.sh` links it and `doctor` checks it.
- **New key or command:** add it to `cheatsheet.md` in the same commit.
- **Code style:** `claude/rules/engineering.md`. Shell scripts must pass `shellcheck -S warning`.
