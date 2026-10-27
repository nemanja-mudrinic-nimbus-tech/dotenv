#!/bin/bash

# Dotfiles setup script
# Run this on a fresh Mac to install everything and configure dotfiles
#
# Usage:
#   ./setup.sh             # Fresh install: every tool and config
#   ./setup.sh --update    # Update an existing installation
#   ./setup.sh --personal  # Also Nemanja's parts: work tools, git identities, 1Password SSH agent, sensei
# Check the result: ~/.dotfiles/bin/doctor

set -e

DOTFILES_DIR="$HOME/.dotfiles"
UPDATE_MODE=false
PERSONAL=false

for arg in "$@"; do
    case $arg in
        --update|-u) UPDATE_MODE=true ;;
        --personal|-p) PERSONAL=true ;;
        -h|--help) sed -n '3,9p' "$0"; exit 0 ;;
        *) echo "Unknown option: $arg (see --help)"; exit 1 ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# ============================================
# 1. Install/Update Homebrew
# ============================================
setup_homebrew() {
    if ! command -v brew &> /dev/null; then
        step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to path for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        info "Homebrew already installed"
        if [[ "$UPDATE_MODE" == true ]]; then
            step "Updating Homebrew..."
            brew update
        fi
    fi
}

# ============================================
# 2. Install/Upgrade Brew packages
# ============================================
install_brew_packages() {
    step "Installing Homebrew packages (Brewfile)..."
    # brew bundle refuses formulae from an untrusted third-party tap.
    brew tap FelixKratz/formulae &> /dev/null && brew trust felixkratz/formulae &> /dev/null || true

    local upgrade="--no-upgrade"
    [[ "$UPDATE_MODE" == true ]] && upgrade=""
    brew bundle install $upgrade --file "$DOTFILES_DIR/Brewfile" || warn "Some Brewfile entries failed — see above"
    if [[ "$PERSONAL" == true ]]; then
        brew bundle install $upgrade --file "$DOTFILES_DIR/Brewfile.personal" || warn "Some Brewfile.personal entries failed — see above"
    fi
}

install_node() {
    step "Installing Node.js (nvm)..."
    export NVM_DIR="$HOME/.nvm"
    if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
        PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh)" || { warn "nvm install failed"; return; }
    fi
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
    nvm ls --no-colors default &> /dev/null || { nvm install --lts && nvm alias default 'lts/*'; } || warn "Node LTS install failed"
}

# ============================================
# 3. Install Oh My Zsh
# ============================================
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        step "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        info "Oh My Zsh already installed"
        if [[ "$UPDATE_MODE" == true ]]; then
            step "Updating Oh My Zsh..."
            (cd "$HOME/.oh-my-zsh" && git pull --rebase --quiet) || warn "Failed to update Oh My Zsh"
        fi
    fi
}

# ============================================
# 4. Install/Update Zsh plugins
# ============================================
install_zsh_plugin() {
    local name="$1"
    local url="$2"
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugin_dir="$ZSH_CUSTOM/plugins/$name"

    if [[ ! -d "$plugin_dir" ]]; then
        info "Installing $name..."
        git clone "$url" "$plugin_dir"
    elif [[ "$UPDATE_MODE" == true ]]; then
        info "Updating $name..."
        (cd "$plugin_dir" && git pull --rebase --quiet) || warn "Failed to update $name"
    else
        info "$name already installed"
    fi
}

install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    step "Setting up Zsh plugins..."

    # Install/update plugins
    install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
    install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
    install_zsh_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search"
}

# ============================================
# 5. Setup fzf
# ============================================
setup_fzf() {
    if command -v fzf &> /dev/null; then
        info "fzf configured (auto-loads via zshrc)"
    fi
}

# ============================================
# 6. Create symlinks
# ============================================
create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        info "Symlink exists: $dest"
    elif [[ -e "$dest" ]]; then
        warn "Backing up: $dest -> ${dest}.backup"
        mv "$dest" "${dest}.backup"
        ln -s "$src" "$dest"
        info "Created symlink: $dest"
    else
        mkdir -p "$(dirname "$dest")"
        ln -s "$src" "$dest"
        info "Created symlink: $dest"
    fi
}

create_symlinks() {
    step "Creating symlinks (links.tsv)..."
    local group src dest skill
    while IFS=$'\t' read -r group src dest; do
        [[ -z "$group" || "$group" == \#* ]] && continue
        [[ "$group" == personal && "$PERSONAL" != true ]] && continue
        create_symlink "$DOTFILES_DIR/$src" "$HOME/$dest"
    done < "$DOTFILES_DIR/links.tsv"
    while read -r skill; do
        [[ -n "$skill" ]] && create_symlink "$DOTFILES_DIR/claude/skills-library/$skill" "$HOME/.claude/skills/$skill"
    done < "$DOTFILES_DIR/claude/skills-library/ACTIVE"
}

setup_personal() {
    step "Personal parts: 1Password vault, SSH agent, git identities per folder (gitid)..."
    local env_file="$HOME/.config/dotfiles/personal.env"
    if [[ ! -f "$env_file" ]]; then
        local vault="${OP_VAULT:-}"
        [[ -n "$vault" ]] || read -r -p "1Password vault for your secrets and SSH keys [Private]: " vault
        mkdir -p "$(dirname "$env_file")"
        printf '# Personal settings for ~/.dotfiles scripts (not in git). Written by setup.sh --personal.\nexport OP_VAULT="%s"\n' "${vault:-Private}" > "$env_file"
    fi
    # shellcheck source=/dev/null
    . "$env_file"
    mkdir -p "$HOME/.config/1Password/ssh"
    printf '# Keys the 1Password SSH agent serves (default would be only the Private vault)\n[[ssh-keys]]\nvault = "%s"\n' "$OP_VAULT" > "$HOME/.config/1Password/ssh/agent.toml"
    [[ -f "$HOME/.config/gitid/profiles.tsv" ]] || "$DOTFILES_DIR/bin/gitid" restore || warn "gitid restore failed — sign in to 1Password, then: gitid restore"
    "$DOTFILES_DIR/bin/gitid" apply || warn "gitid apply failed — run it by hand"
}

setup_desktop() {
    step "Starting the desktop tools (SketchyBar, borders, AeroSpace, Maccy)..."
    brew services start sketchybar &> /dev/null || warn "SketchyBar did not start"
    brew services start borders &> /dev/null || warn "borders did not start"
    open -a AeroSpace 2> /dev/null || warn "AeroSpace not found"
    open -a Maccy 2> /dev/null || warn "Maccy not found"
}

setup_git_secret_scan() {
    step "Installing gitleaks pre-commit hooks (dotfiles, vault)..."
    local repo
    for repo in "$DOTFILES_DIR" "$HOME/vault"; do
        [[ -d "$repo/.git" ]] || continue
        printf '#!/bin/sh\nexec gitleaks git --pre-commit --staged --redact --no-banner -v\n' > "$repo/.git/hooks/pre-commit"
        chmod +x "$repo/.git/hooks/pre-commit"
    done
}

setup_tmux_plugins() {
    step "Setting up tmux plugins (TPM)..."
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" &> /dev/null || warn "TPM plugin install failed — run prefix I inside tmux"
}

# ============================================
# Dev tooling: graphify, language servers, Claude Code extras
# ============================================
setup_dev_tooling() {
    step "Setting up dev tooling (graphify, language servers, Claude Code)..."

    if command -v uv &> /dev/null; then
        if uv tool list 2>/dev/null | grep -q '^graphifyy'; then
            info "graphify already installed"
        else
            uv tool install graphifyy || warn "Failed to install graphify"
        fi
    fi

    if command -v npm &> /dev/null; then
        npm install -g typescript-language-server typescript pyright || warn "Failed to install language servers"
    else
        warn "npm not found — install node via nvm, then re-run for TS/Python language servers"
    fi

    if command -v claude &> /dev/null; then
        claude mcp get context7 &> /dev/null || claude mcp add --transport http -s user context7 https://mcp.context7.com/mcp || warn "Failed to add Context7"
        local plugin
        for plugin in gopls-lsp typescript-lsp pyright-lsp; do
            claude plugin install "$plugin@claude-plugins-official" &> /dev/null || warn "Failed to install Claude plugin $plugin"
        done
        claude plugin marketplace add craftzdog/tmux-claude-hatch &> /dev/null || true
        claude plugin install tmux-claude-hatch@tmux-claude-hatch &> /dev/null || warn "Failed to install tmux-claude-hatch Claude plugin"
        claude plugin marketplace add mattpocock/skills &> /dev/null || true
        claude plugin install mattpocock-skills@mattpocock &> /dev/null || warn "Failed to install mattpocock-skills Claude plugin"
        claude plugin marketplace add backnotprop/plannotator &> /dev/null || true
        claude plugin install plannotator@plannotator &> /dev/null || warn "Failed to install plannotator Claude plugin"
        command -v plannotator &> /dev/null || curl -fsSL https://plannotator.ai/install.sh | bash -s -- --minimal || warn "Failed to install plannotator binary"
    else
        warn "Claude Code not found — install it, then re-run setup for Context7 + LSP plugins"
    fi
}

# ============================================
# 7. Setup Neovim
# ============================================
setup_neovim() {
    step "Setting up Neovim..."

    # Check nvim version
    if command -v nvim &> /dev/null; then
        local nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        info "Neovim version: $nvim_version"

        # Compare versions (need 0.12.0+: vellum images use nvim_ui_send)
        local required="0.12.0"
        if [[ "$(printf '%s\n' "$required" "$nvim_version" | sort -V | head -n1)" != "$required" ]]; then
            warn "Neovim $nvim_version is older than $required"
            warn "Some plugins may not work. Run: brew upgrade neovim"
        fi
    fi

    # Clean nvim cache if update mode or if there are issues
    if [[ "$UPDATE_MODE" == true ]]; then
        info "Cleaning Neovim plugin cache..."
        rm -rf "$HOME/.local/share/nvim/lazy"
        rm -rf "$HOME/.local/state/nvim"
        rm -rf "$HOME/.cache/nvim"
        info "Neovim cache cleared - plugins will reinstall on next launch"
    fi

    # Create necessary directories
    mkdir -p "$HOME/.local/share/nvim"
    mkdir -p "$HOME/.local/state/nvim"
}

# ============================================
# 8. Post-install setup
# ============================================
post_install() {
    step "Running post-install setup..."

    # Setup bat themes
    if command -v bat &> /dev/null; then
        bat cache --build 2>/dev/null || true
    fi

    # Create directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.nvm"

    # Create secrets file from example if it doesn't exist
    if [[ ! -f "$HOME/.secrets" ]]; then
        cp "$DOTFILES_DIR/zsh/secrets.example" "$HOME/.secrets"
        warn "Created ~/.secrets - please add your API keys!"
    fi
}

# ============================================
# 9. Pull latest dotfiles
# ============================================
update_dotfiles() {
    if [[ "$UPDATE_MODE" == true ]]; then
        step "Pulling latest dotfiles..."
        cd "$DOTFILES_DIR"
        git pull --rebase || warn "Failed to pull dotfiles"
    fi
}

# ============================================
# Main
# ============================================
main() {
    echo ""
    echo "=========================================="
    if [[ "$UPDATE_MODE" == true ]]; then
        echo "       Dotfiles Update Script"
    else
        echo "       Dotfiles Setup Script"
    fi
    echo "=========================================="
    echo ""

    # Check if dotfiles directory exists
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        error "Dotfiles directory not found at $DOTFILES_DIR"
        error "Please clone the repo first:"
        echo "  git clone <your-repo-url> ~/.dotfiles"
        exit 1
    fi

    # Run update first if in update mode
    if [[ "$UPDATE_MODE" == true ]]; then
        update_dotfiles
    fi

    setup_homebrew
    install_brew_packages
    install_node
    install_oh_my_zsh
    install_zsh_plugins
    setup_fzf
    create_symlinks
    setup_tmux_plugins
    [[ "$PERSONAL" == true ]] && setup_personal
    setup_git_secret_scan
    setup_dev_tooling
    setup_neovim
    setup_desktop
    post_install

    echo ""
    echo "=========================================="
    info "Setup complete!"
    echo "=========================================="
    echo ""
    echo "Steps only a human can do (AGENTS.md explains each):"
    echo "  1. AeroSpace: System Settings → Privacy & Security → Accessibility → turn on AeroSpace"
    echo "  2. Optional macOS changes (hidden Dock and menu bar, Spaces): ~/.dotfiles/macos/defaults.sh, then log out and in"
    echo "  3. Ghostty: open it; Cmd+Shift+, reloads the config"
    echo "  4. tmux: start it once; plugins are installed (prefix is Ctrl-a, prefix ? = cheatsheet)"
    echo "  5. nvim: open it once; lazy.nvim installs the plugins"
    echo "  6. Shell history into atuin (optional): atuin import zsh"
    if [[ "$PERSONAL" == true ]]; then
        echo "  7. 1Password app: Settings → Developer → turn on 'Integrate with 1Password CLI' and 'Use the SSH agent'"
    fi
    echo ""
    echo "Check everything: ~/.dotfiles/bin/doctor"
    echo "Update later:     ~/.dotfiles/setup.sh --update"
    echo ""
}

main "$@"
