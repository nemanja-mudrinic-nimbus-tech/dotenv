#!/bin/bash

# Dotfiles setup script
# Run this after cloning the dotfiles repo to create symlinks

set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "Setting up dotfiles..."

# Initialize and update submodules (for nvim)
cd "$DOTFILES_DIR"
git submodule update --init --recursive

# Create symlinks
create_symlink() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        echo "Symlink already exists: $dest"
    elif [ -e "$dest" ]; then
        echo "Backing up existing: $dest -> ${dest}.backup"
        mv "$dest" "${dest}.backup"
        ln -s "$src" "$dest"
        echo "Created symlink: $dest -> $src"
    else
        ln -s "$src" "$dest"
        echo "Created symlink: $dest -> $src"
    fi
}

# Ghostty
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

# Neovim
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Zsh
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

echo ""
echo "Dotfiles setup complete!"
echo ""
echo "Note: You may need to install these separately:"
echo "  - oh-my-zsh: https://ohmyz.sh/"
echo "  - powerlevel10k: https://github.com/romkatv/powerlevel10k"
echo "  - neovim plugins will install on first launch"
