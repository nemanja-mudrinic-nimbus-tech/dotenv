#!/usr/bin/env bash
# Run once by hand: ~/.dotfiles/macos/defaults.sh — then log out and log in again.
set -euo pipefail

# Hide the Dock automatically.
defaults write com.apple.dock autohide -bool true
# Show the hidden Dock with almost no wait when the pointer touches the edge.
defaults write com.apple.dock autohide-delay -float 0.1
# Hide the macOS menu bar always, so SketchyBar replaces it.
defaults write NSGlobalDomain _HIHideMenuBar -bool true
# Turn off "Displays have separate Spaces" (AeroSpace recommendation; needs log out).
defaults write com.apple.spaces spans-displays -bool true
# Group windows by application in Mission Control (AeroSpace recommendation).
defaults write com.apple.dock expose-group-apps -bool true

# Restart the Dock and the menu bar process. This applies the Dock settings at once.
killall Dock SystemUIServer || true

cat <<'EOF'

Done. Log out and log in now.

macOS reads the menu bar setting at login only, so killall is not enough.
Until you log in again the macOS menu bar stays on screen and covers SketchyBar.
The Spaces settings also need the new login.
EOF
