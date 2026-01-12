# Dotfiles

My macOS development environment: Neovim + Ghostty + Zsh with Oh My Zsh and Powerlevel10k.

## What's Included

- **Ghostty** - Terminal emulator with custom themes (Catppuccin, Noctis)
- **Neovim** - LazyVim configuration with LSP, Copilot, and custom plugins
- **Zsh** - Oh My Zsh + Powerlevel10k theme + useful plugins
- **CLI Tools** - fzf, fd, bat, eza, zoxide, ripgrep, and more

## Quick Start

### 1. Clone the repository

```bash
git clone git@github.com:nemanja-mudrinic-nimbus-tech/dotenv.git ~/.dotfiles
```

### 2. Run the setup script

```bash
~/.dotfiles/setup.sh
```

This will automatically:
- Install Homebrew (if not installed)
- Install all required packages via Homebrew (including Ghostty, Neovim, etc.)
- Install Oh My Zsh and plugins
- Create symlinks for all config files

### 3. Add your API keys

```bash
nano ~/.secrets
```

Add your keys (see `zsh/secrets.example` for format).

### 4. Restart your terminal

Open a new terminal window or run:
```bash
source ~/.zshrc
```

### 5. Open Neovim

```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

## What Gets Installed

### Homebrew Packages

| Package | Description |
|---------|-------------|
| ghostty | GPU-accelerated terminal |
| neovim | Hyperextensible text editor |
| tmux | Terminal multiplexer |
| powerlevel10k | Zsh theme |
| zsh-autosuggestions | Fish-like autosuggestions |
| zsh-syntax-highlighting | Syntax highlighting for zsh |
| fzf | Fuzzy finder |
| fd | Fast find alternative |
| bat | Cat with syntax highlighting |
| eza | Modern ls replacement |
| zoxide | Smarter cd command |
| ripgrep | Fast grep alternative |
| direnv | Directory-based env variables |
| thefuck | Correct previous command |
| pyenv | Python version manager |
| nvm | Node.js version manager |

### Oh My Zsh Plugins

- git, sudo, extract
- kubectl, gcloud, poetry
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-history-substring-search
- zsh-kubectl-prompt

## Directory Structure

```
~/.dotfiles/
├── ghostty/           # Ghostty terminal config
│   ├── config         # Main config
│   └── themes/        # Color themes
├── nvim/              # Neovim config (LazyVim)
│   ├── init.lua
│   └── lua/
│       ├── config/    # Core settings
│       └── plugins/   # Plugin configs
├── zsh/
│   ├── zshrc          # Main zsh config
│   ├── p10k.zsh       # Powerlevel10k theme
│   └── secrets.example # Template for API keys
├── setup.sh           # Installation script
└── README.md
```

## Symlinks Created

| Source | Destination |
|--------|-------------|
| `~/.dotfiles/ghostty` | `~/.config/ghostty` |
| `~/.dotfiles/nvim` | `~/.config/nvim` |
| `~/.dotfiles/zsh/zshrc` | `~/.zshrc` |
| `~/.dotfiles/zsh/p10k.zsh` | `~/.p10k.zsh` |

## Optional Tools

These are referenced in the config but not auto-installed:

```bash
# Kubernetes
brew install kubectl

# Google Cloud SDK
brew install google-cloud-sdk

# Poetry (Python)
curl -sSL https://install.python-poetry.org | python3 -

# Flutter
# See: https://flutter.dev/docs/get-started/install
```

## Customization

### Powerlevel10k

Run the configuration wizard:
```bash
p10k configure
```

### Ghostty Theme

Edit `~/.config/ghostty/config` and change the theme:
```
theme = catppuccin-mocha
```

Available themes: `catppuccin-mocha`, `catppuccin-frappe`, `catppuccin-latte`, `catppuccin-macchiato`, `noctis`, `noctis-azureus`, etc.

## Troubleshooting

### Fonts not displaying correctly

Install a Nerd Font:
```bash
brew install --cask font-meslo-lg-nerd-font
```

Then set it in Ghostty config or run `p10k configure`.

### Zsh plugins not loading

Ensure plugins are installed:
```bash
ls ~/.oh-my-zsh/custom/plugins/
```

If missing, run the setup script again.

### Neovim plugins failing

Clear the plugin cache and reinstall:
```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
nvim
```
