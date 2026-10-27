#!/usr/bin/env bash
# Show workspaces 1-5 that hold windows, plus the focused one, each with the icons of its apps.
# Hide all of them while AeroSpace is not running.

export PATH="/opt/homebrew/bin:$PATH"
# shellcheck source=SCRIPTDIR/../colors.sh
source "$CONFIG_DIR/colors.sh"
# shellcheck source=SCRIPTDIR/icon_map.sh
source "$CONFIG_DIR/plugins/icon_map.sh"

windows="$(aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null)" || {
  sketchybar --set '/space\..*/' drawing=off
  exit 0
}
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

args=()
for ws in 1 2 3 4 5; do
  icons=""
  while IFS= read -r app; do
    __icon_map "$app"
    icons+="$icon_result "
  done < <(awk -F'|' -v ws="$ws" '$1 == ws && !seen[$2]++ { print $2 }' <<<"$windows")
  icons="${icons% }"

  if [ "$ws" = "$focused" ]; then
    args+=(--set "space.$ws" drawing=on label="$icons" label.drawing="$([ -n "$icons" ] && echo on || echo off)"
      background.drawing=on background.color="$GREEN" icon.color="$DARK" label.color="$DARK")
  elif [ -n "$icons" ]; then
    args+=(--set "space.$ws" drawing=on label="$icons" label.drawing=on
      background.drawing=off icon.color="$MUTED" label.color="$MUTED")
  else
    args+=(--set "space.$ws" drawing=off)
  fi
done
sketchybar "${args[@]}"
