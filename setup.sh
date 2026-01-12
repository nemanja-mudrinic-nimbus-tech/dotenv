#!/bin/bash

# Dotfiles setup script
# Run this on a fresh Mac to install everything and configure dotfiles

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================
# 1. Install Homebrew
# ============================================
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to path for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        info "Homebrew already installed"
    fi
}

# ============================================
# 2. Install Brew packages
# ============================================
install_brew_packages() {
    info "Installing Homebrew packages..."

    # Core tools
    BREW_PACKAGES=(
        # Terminal & Editor
        ghostty
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
            info "$package already installed"
        else
            info "Installing $package..."
            brew install "$package" || warn "Failed to install $package"
        fi
    done

    # Install casks (GUI apps)
    BREW_CASKS=(
        ghostty
    )

    for cask in "${BREW_CASKS[@]}"; do
        if brew list --cask "$cask" &> /dev/null; then
            info "$cask already installed"
        else
            info "Installing $cask..."
            brew install --cask "$cask" 2>/dev/null || info "$cask might be a formula, not a cask"
        fi
    done
}

# ============================================
# 3. Install Oh My Zsh
# ============================================
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        info "Oh My Zsh already installed"
    fi
}

# ============================================
# 4. Install Zsh plugins (oh-my-zsh custom plugins)
# ============================================
install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions (oh-my-zsh version)
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        info "Installing zsh-autosuggestions plugin..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting (oh-my-zsh version)
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        info "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    # zsh-history-substring-search
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]]; then
        info "Installing zsh-history-substring-search plugin..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
    fi

    # zsh-kubectl-prompt
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-kubectl-prompt" ]]; then
        info "Installing zsh-kubectl-prompt plugin..."
        git clone https://github.com/superbrothers/zsh-kubectl-prompt "$ZSH_CUSTOM/plugins/zsh-kubectl-prompt"
    fi

    # powerlevel10k theme (oh-my-zsh version)
    if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        info "Installing powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi
}

# ============================================
# 5. Setup fzf keybindings
# ============================================
setup_fzf() {
    if command -v fzf &> /dev/null; then
        info "Setting up fzf keybindings..."
        # fzf installed via brew auto-configures with `fzf --zsh`
    fi
}

# ============================================
# 6. Initialize submodules (nvim)
# ============================================
init_submodules() {
    info "Initializing git submodules..."
    cd "$DOTFILES_DIR"
    git submodule update --init --recursive
}

# ============================================
# 7. Create symlinks
# ============================================
create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        info "Symlink already exists: $dest"
    elif [[ -e "$dest" ]]; then
        warn "Backing up existing: $dest -> ${dest}.backup"
        mv "$dest" "${dest}.backup"
        ln -s "$src" "$dest"
        info "Created symlink: $dest -> $src"
    else
        # Create parent directory if needed
        mkdir -p "$(dirname "$dest")"
        ln -s "$src" "$dest"
        info "Created symlink: $dest -> $src"
    fi
}

create_symlinks() {
    info "Creating symlinks..."

    # Ghostty
    create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

    # Neovim
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Zsh
    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
}

# ============================================
# 8. Post-install setup
# ============================================
post_install() {
    info "Running post-install setup..."

    # Setup bat themes
    if command -v bat &> /dev/null; then
        bat cache --build 2>/dev/null || true
    fi

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Create nvm directory
    mkdir -p "$HOME/.nvm"
}

# ============================================
# Main
# ============================================
main() {
    echo ""
    echo "=========================================="
    echo "       Dotfiles Setup Script"
    echo "=========================================="
    echo ""

    # Check if running from dotfiles directory
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        error "Dotfiles directory not found at $DOTFILES_DIR"
        error "Please clone the repo first:"
        echo "  git clone --recursive <your-repo-url> ~/.dotfiles"
        exit 1
    fi

    install_homebrew
    install_brew_packages
    install_oh_my_zsh
    install_zsh_plugins
    setup_fzf
    init_submodules
    create_symlinks
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
    echo "Optional tools to install manually:"
    echo "  - kubectl: brew install kubectl"
    echo "  - gcloud: brew install google-cloud-sdk"
    echo "  - poetry: curl -sSL https://install.python-poetry.org | python3 -"
    echo "  - Flutter: https://flutter.dev/docs/get-started/install"
    echo ""
}

main "$@"
