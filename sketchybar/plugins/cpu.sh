#!/usr/bin/env bash
# Total CPU load in percent of all cores, from ps (no compiled helper).

# shellcheck source=SCRIPTDIR/../colors.sh
source "$CONFIG_DIR/colors.sh"

cores="$(sysctl -n hw.ncpu)"
load="$(ps -A -o %cpu= | awk -v cores="$cores" '{ sum += $1 } END { printf "%d", sum / cores }')"

color="$FG"
[ "$load" -ge 50 ] && color="$AMBER"
[ "$load" -ge 80 ] && color="$RED"

sketchybar --set "$NAME" label="${load}%" label.color="$color"
