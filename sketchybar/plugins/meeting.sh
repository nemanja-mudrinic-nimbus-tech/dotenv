#!/usr/bin/env bash
# Show the first line of the file that the agenda app writes. Hide the item when there is no file.

file="$HOME/.local/state/agenda/next-meeting"
next="$([ -r "$file" ] && head -n 1 "$file")"

if [ -n "$next" ]; then
  sketchybar --set "$NAME" drawing=on label="$next"
else
  sketchybar --set "$NAME" drawing=off
fi
