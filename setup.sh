#!/bin/bash

# Dotfiles setup script
# Run this on a fresh Mac to install everything and configure dotfiles
#
# Usage:
#   ./setup.sh           # Fresh install
#   ./setup.sh --update  # Update existing installation

set -e

DOTFILES_DIR="$HOME/.dotfiles"
UPDATE_MODE=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --update|-u)
            UPDATE_MODE=true
            shift
            ;;
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
    step "Installing Homebrew packages..."

    # Core tools (formulas only, not casks)
    BREW_PACKAGES=(
        # Editor
        neovim
        tmux

        # Zsh plugins (installed via brew)
        powerlevel10k
        zsh-autosuggestions
        zsh-syntax-highlighting

        # Modern CLI replacements
        fzf
        fd
        bat
        eza
        zoxide
        ripgrep

        # Utilities
        direnv
        thefuck
        git
        gh

        # Development
        pyenv
        nvm
    )

    for package in "${BREW_PACKAGES[@]}"; do
        if brew list "$package" &> /dev/null; then
            if [[ "$UPDATE_MODE" == true ]]; then
                info "Upgrading $package..."
                brew upgrade "$package" 2>/dev/null || info "$package already up to date"
            else
                info "$package already installed"
            fi
        else
            info "Installing $package..."
            brew install "$package" || warn "Failed to install $package"
        fi
    done

    # Install casks (GUI apps)
    # Ghostty - check if already installed (cask or app exists)
    if brew list --cask ghostty &> /dev/null || [[ -d "/Applications/Ghostty.app" ]]; then
        if [[ "$UPDATE_MODE" == true ]]; then
            info "Upgrading ghostty..."
            brew upgrade --cask ghostty 2>/dev/null || info "ghostty already up to date"
        else
            info "ghostty already installed"
        fi
    else
        info "Installing ghostty..."
        brew install --cask ghostty
    fi
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
    install_zsh_plugin "zsh-kubectl-prompt" "https://github.com/superbrothers/zsh-kubectl-prompt"

    # Powerlevel10k theme
    local p10k_dir="$ZSH_CUSTOM/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        info "Installing powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    elif [[ "$UPDATE_MODE" == true ]]; then
        info "Updating powerlevel10k..."
        (cd "$p10k_dir" && git pull --rebase --quiet) || warn "Failed to update powerlevel10k"
    else
        info "powerlevel10k already installed"
    fi
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
    step "Creating symlinks..."

    create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
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

        # Compare versions (need 0.11.0+)
        local required="0.11.0"
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
    install_oh_my_zsh
    install_zsh_plugins
    setup_fzf
    create_symlinks
    setup_neovim
    post_install

    echo ""
    echo "=========================================="
    info "Setup complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Run 'p10k configure' if you want to customize the prompt"
    echo "  3. Open nvim to let lazy.nvim install plugins"
    echo ""
    if [[ "$UPDATE_MODE" != true ]]; then
        echo "To update everything later, run:"
        echo "  ~/.dotfiles/setup.sh --update"
        echo ""
    fi
    echo "Optional tools:"
    echo "  brew install kubectl google-cloud-sdk"
    echo ""
}

main "$@"
