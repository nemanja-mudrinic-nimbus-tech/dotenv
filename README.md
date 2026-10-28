# Dotfiles

A complete macOS development setup with one green "moss" look everywhere. Clone it, run one script, and get the same working environment.

## What you get

| Part | Tools |
|---|---|
| Terminal | Ghostty, tmux (sessionx, floax, URL picker, Claude session picker), zsh with Oh My Zsh, Starship, atuin, fzf |
| Editor | Neovim (LazyVim, moss theme, LSP for Go, TypeScript and Python), lazygit |
| CLI tools | bat, eza, fd, ripgrep, zoxide, direnv, jq, yq, gh, git-delta, gitleaks, shellcheck, uv, Node.js (nvm) |
| Desktop | AeroSpace (tiling windows), SketchyBar, borders, Maccy (clipboard history) |
| Fonts | IBM Plex Mono (BlexMono Nerd Font), SF Pro, SketchyBar app icons |
| Claude Code | Rules, own and open-source skills, plugins (Plannotator, mattpocock skills, LSP), Context7 |
| Own commands | `doctor` (checks the setup), `gitid` (git identity per folder — `cheatsheet.md` → "Git identity per folder"), `devctl` (long-running processes), `skills` (skill library), `pn` (Plannotator in tmux), `recap` (day summary of Claude sessions) |

You do not need 1Password, a server or any account for the default setup.

## Two setups: default and `--personal`

`setup.sh` has two modes. **Everyone wants the default. Only the repo owner wants `--personal`.**

| | Default — `setup.sh` | Owner — `setup.sh --personal` |
|---|---|---|
| Who it is for | anyone who likes this setup | the repo owner, on his own machines |
| Terminal, editor, shell, CLI tools (`Brewfile`) | yes | yes |
| Desktop: AeroSpace, SketchyBar, borders, Maccy | yes | yes |
| Fonts, Claude Code rules and skills | yes | yes |
| Config links, group `core` in `links.tsv` | yes | yes |
| Work tools: Go, Kubernetes, Terraform, cloud CLIs, databases (`Brewfile.personal`) | no | yes |
| Container runtime (OrbStack) | no | yes |
| 1Password CLI, SSH agent config, `~/.config/dotfiles/personal.env` | no | yes |
| Git identity per folder (`gitid`), restored from 1Password | no | yes |
| Config links, group `personal` in `links.tsv` | no | yes |

**The default needs no account.** No 1Password, no server, no sign-in. It installs tools and links configs, nothing else.

`--personal` exists because the owner's machines need private things that cannot live in a public repo: client names, work emails, a Coolify domain, SSH keys. Those are read from 1Password and from `~/.config/dotfiles/personal.env`, neither of which is in git. Running `--personal` without the owner's 1Password account gets you the work tools and nothing else useful, so there is no reason to use it.

## Install

1. Install the Xcode command line tools: `xcode-select --install`.
2. Install Homebrew from [brew.sh](https://brew.sh).
3. Clone the repo:
   ```bash
   git clone https://github.com/nemanja-mudrinic-nimbus-tech/dotenv.git ~/.dotfiles
   ```
4. Choose one way to install:
   - **With Claude Code:** start `claude` in `~/.dotfiles` and type "Set up this Mac from the dotfiles. Follow AGENTS.md." Claude runs the setup, tells you the manual steps and checks the result.
   - **By hand:** run `~/.dotfiles/setup.sh`, do the steps it prints at the end, then run `~/.dotfiles/bin/doctor`.
5. Do the manual steps:
   1. Turn on AeroSpace in System Settings → Privacy & Security → Accessibility.
   2. Run `~/.dotfiles/macos/defaults.sh`, then log out and log in again. **SketchyBar stays invisible until you do this:** the macOS menu bar covers the bar. The script also hides the Dock and sets the Spaces options AeroSpace needs.
   3. Install the bar font: `brew install --cask font-sf-pro`. It asks for your password, so `setup.sh` cannot do it.
   4. Open Ghostty and nvim one time each.

`setup.sh` installs everything in `Brewfile` and links each config listed in `links.tsv`. If a file is already at a link location, the script moves it to `<file>.backup`.

### If a desktop tool does not start

Run `doctor` first. It names the broken part and prints the fix. The usual ones:

| What you see | Why | Fix |
|---|---|---|
| No bar at the top, `pgrep -x sketchybar` finds it | The macOS menu bar is still shown and covers it | `~/.dotfiles/macos/defaults.sh`, then log out and in |
| No bar, nothing running | The service is stopped | `brew services start sketchybar` |
| The bar shows but the text looks wrong | SF Pro is missing (it needs your password) | `brew install --cask font-sf-pro` |
| Maccy does not start after a restart | Maccy keeps "Launch at login" in macOS, not in a config file | `~/.dotfiles/setup.sh` adds the login item. If macOS blocks the terminal, open Maccy → Settings → Launch at login |
| `Alt` keys do nothing | AeroSpace has no Accessibility permission, or a password field has focus (Secure Input) | Turn on AeroSpace in System Settings → Privacy & Security → Accessibility |
| No green border on the focused window | The service is stopped | `brew services start borders` |

`setup.sh` starts SketchyBar and borders as `brew services` (they come back after a restart), and adds AeroSpace and Maccy to the macOS login items.

### Use only some parts

Each part is a folder. Copy or link only the folders you want, for example:
- `ghostty/` to `~/.config/ghostty`. Also install the font: `brew install --cask font-blex-mono-nerd-font`.
- `nvim/` to `~/.config/nvim`.

`links.tsv` shows where each folder goes.

## Claude Code part

Everything for Claude Code is in `claude/`. `setup.sh` links it into `~/.claude`, so a change in the repo applies at once.

| Path | Linked to | What |
|---|---|---|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global rules. Imports `claude/rules/engineering.md` |
| `claude/settings.json` | `~/.claude/settings.json` | Permissions and hooks (secret scan, `devctl` guard) |
| `claude/skills/<name>/` | `~/.claude/skills/<name>` | Own skills: frontend, backend, devops, go-idioms, typescript-react, brain, plannotator-tui |
| `claude/skills-library/<name>/` | `~/.claude/skills/<name>` when active | Open-source skills. `skills ls` lists them, `skills on/off <name>` switches them. `ACTIVE` lists the active ones |

The rules and skills are written for the repo owner's way of working. Read them before you use them, and change what does not fit you.

## Owner setup (`--personal`)

`setup.sh --personal` adds the repo owner's private parts. Other people do not need it. It uses 1Password:
- the 1Password CLI and work tools (`Brewfile.personal`)
- a container runtime (OrbStack) — a personal choice rather than part of the setup; swap for Docker Desktop, Colima or Podman
- the 1Password vault name and the `sensei` Coolify domain, in `~/.config/dotfiles/personal.env` (not in git)
- the 1Password SSH agent config
- git identities per folder, restored from 1Password into `~/.config/gitid/` (not in git)

New laptop:
1. Install the 1Password app and sign in. In Settings → Developer, turn on "Integrate with 1Password CLI" and "Use the SSH agent".
2. Do steps 1–3 of [Install](#install).
3. Run `~/.dotfiles/setup.sh --personal`. When it asks for the vault, type the vault that holds your SSH keys.
4. Do the manual steps, then run `doctor`.
5. To push from this laptop, run `git -C ~/.dotfiles remote set-url origin git@github.com:nemanja-mudrinic-nimbus-tech/dotenv.git`.

## Check and update

| Command | What it does |
|---|---|
| `doctor` | Checks every part. Each FAIL line has a fix. |
| `setup.sh --update` | Pulls the repo, upgrades the packages and plugins |

## Learn the keys

- **tmux:** the prefix is `Ctrl-a`. Prefix then `?` opens the cheatsheet (`cheatsheet.md`). The cheatsheet has every key and command.
- **AeroSpace:** Alt keys.
- **Maccy:** `Shift+Cmd+C`.

## Change the setup

- **New tool:** add it to `Brewfile`.
- **New config file:** add a line to `links.tsv`.
- **Agents and layout:** `AGENTS.md` explains the repo layout and the rules for agents.
