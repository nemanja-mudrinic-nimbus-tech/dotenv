#!/usr/bin/env bash
# Count tmux panes that run Claude Code; mark the item amber if a session waits for input.
# A Claude pane reports either "claude" or its version (for example 2.1.310) as its command.

export PATH="/opt/homebrew/bin:$HOME/.local/bin:$PATH"
# shellcheck source=SCRIPTDIR/../colors.sh
source "$CONFIG_DIR/colors.sh"

panes="$(tmux list-panes -a -F '#{pane_current_command}' 2>/dev/null)" || { sketchybar --set "$NAME" drawing=off; exit 0; }
count="$(grep -cE '^(claude|[0-9]+\.[0-9]+\.[0-9]+)$' <<<"$panes")"
[ "$count" -gt 0 ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

waiting="$(claude agents --json 2>/dev/null | jq '[.[] | select(.kind == "interactive" and .status == "waiting")] | length' 2>/dev/null)"

if [ "${waiting:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="$count · $waiting waiting" icon.color="$AMBER" label.color="$AMBER"
else
  sketchybar --set "$NAME" drawing=on label="$count" icon.color="$TEAL" label.color="$FG"
fi
