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

# Move Loom's record shortcuts from Option+Shift+1..5 to Option+Shift+7, 8, 9, 0.
# Option+Shift+1..6 belong to AeroSpace (move window to a workspace).
# "Record for agent" has no free Option+Shift number, so it gets Ctrl+Option+Shift+5.
# Loom writes its settings when it quits, so quit it first.
if [ -d /Applications/Loom.app ]; then
  osascript -e 'quit app "Loom"' 2>/dev/null || true
  option_shift=655360
  ctrl_option_shift=917504
  loom_shortcut() {
    local json="{\"keyCode\":$2,\"keyEquivalent\":\"$3\",\"modifierFlagsRawValue\":$4}"
    defaults write com.loom.desktop.native "keyboardShortcut.$1" -data "$(printf '%s' "$json" | xxd -p | tr -d '\n')"
  }
  loom_shortcut recordDisplay 26 7 "$option_shift"
  loom_shortcut recordWindow 28 8 "$option_shift"
  loom_shortcut recordArea 25 9 "$option_shift"
  loom_shortcut recordCameraOnly 29 0 "$option_shift"
  loom_shortcut recordForAgent 23 5 "$ctrl_option_shift"
fi

# Maccy (clipboard history) opens with Shift+Cmd+B (default Shift+Cmd+C).
if [ -d /Applications/Maccy.app ]; then
  osascript -e 'quit app "Maccy"' 2>/dev/null || true
  defaults write org.p0deje.Maccy KeyboardShortcuts_popup -string '{"carbonKeyCode":11,"carbonModifiers":768}'
fi

# Restart the Dock and the menu bar process. This applies the Dock settings at once.
killall Dock SystemUIServer || true

cat <<'EOF'

Done. Log out and log in now.

macOS reads the menu bar setting at login only, so killall is not enough.
Until you log in again the macOS menu bar stays on screen and covers SketchyBar.
The Spaces settings also need the new login.
EOF
