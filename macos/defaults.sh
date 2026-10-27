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

# Restart the Dock and the menu bar process so the changes apply.
killall Dock SystemUIServer
