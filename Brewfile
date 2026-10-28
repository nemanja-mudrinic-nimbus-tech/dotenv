# Everything setup.sh installs for everyone. Personal work tools: Brewfile.personal (setup.sh --personal).
# Apps installed outside Homebrew (App Store, vendor installer) are skipped instead of failing the bundle.
def app?(name) = File.exist?("/Applications/#{name}.app")
def font?(glob) = !Dir.glob(["/Library/Fonts/#{glob}", "#{Dir.home}/Library/Fonts/#{glob}"]).empty?

tap "felixkratz/formulae"
tap "nikitabobko/tap"
tap "plannotator/tap"

# Terminal and editor
cask "ghostty" unless app?("Ghostty")
brew "tmux"
brew "neovim"
brew "tree-sitter-cli"

# Shell
brew "starship"
brew "atuin"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "direnv"
brew "thefuck"

# CLI tools
brew "fzf"
brew "fd"
brew "bat"
brew "eza"
brew "zoxide"
brew "ripgrep"
brew "lazygit"
brew "git"
brew "git-delta"
brew "gh"
brew "jq"
brew "yq"
brew "tree"
brew "imagemagick"
brew "gitleaks"
brew "shellcheck"
brew "uv"
brew "plannotator/tap/plannotator-tui"

# Desktop: tiling, bar, borders, clipboard
cask "nikitabobko/tap/aerospace" unless app?("AeroSpace")
brew "felixkratz/formulae/sketchybar"
brew "felixkratz/formulae/borders"
cask "maccy" unless app?("Maccy")

# Fonts: terminal (BlexMono), bar (SF Pro + app icons)
cask "font-blex-mono-nerd-font"
cask "font-sketchybar-app-font"
cask "font-sf-pro" unless font?("SF-Pro-Display-*")
