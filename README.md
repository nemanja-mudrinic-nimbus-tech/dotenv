# Dotfiles

A complete macOS development setup with one green "moss" look everywhere. Clone it, run one script, and get the same working environment.

## What you get

| Part | Tools |
|---|---|
| Terminal | Ghostty, tmux (sessionx, floax, URL picker, Claude session picker), zsh with Oh My Zsh, Starship, atuin, fzf |
| Editor | Neovim (LazyVim, moss theme, LSP for Go, TypeScript and Python), lazygit |
| CLI tools | bat, eza, fd, ripgrep, zoxide, direnv, jq, yq, gh, git-delta, gitleaks, shellcheck, uv, Node.js (nvm) |
| Desktop | AeroSpace (tiling windows), SketchyBar, borders, Maccy (clipboard history), OrbStack |
| Fonts | IBM Plex Mono (BlexMono Nerd Font), SF Pro, SketchyBar app icons |
| Claude Code | Rules, own and open-source skills, plugins (Plannotator, mattpocock skills, LSP), Context7 |
| Own commands | `doctor` (checks the setup), `gitid` (git identity per folder), `devctl` (long-running processes), `skills` (skill library), `pn` (Plannotator in tmux), `recap` (day summary of Claude sessions) |

You do not need 1Password, a server or any account for the default setup.

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
   2. Open Ghostty and nvim one time each.

`setup.sh` installs everything in `Brewfile` and links each config listed in `links.tsv`. If a file is already at a link location, the script moves it to `<file>.backup`.

**Optional:** `macos/defaults.sh` hides the Dock and the menu bar, because SketchyBar replaces the menu bar. It also changes the Spaces settings that AeroSpace needs. Log out and in after you run it.

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
- the 1Password vault name, in `~/.config/dotfiles/personal.env` (not in git)
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
