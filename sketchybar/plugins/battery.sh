#!/usr/bin/env bash

# shellcheck source=SCRIPTDIR/../colors.sh
source "$CONFIG_DIR/colors.sh"
# shellcheck source=SCRIPTDIR/../icons.sh
source "$CONFIG_DIR/icons.sh"

batt="$(pmset -g batt)"
percent="$(grep -Eo '[0-9]+%' <<<"$batt" | head -1 | tr -d '%')"
[ -n "$percent" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

if   [ "$percent" -ge 90 ]; then icon="$BATTERY_100"
elif [ "$percent" -ge 60 ]; then icon="$BATTERY_75"
elif [ "$percent" -ge 30 ]; then icon="$BATTERY_50"
elif [ "$percent" -ge 10 ]; then icon="$BATTERY_25"
else icon="$BATTERY_0"
fi

color="$GREEN"
[ "$percent" -lt 40 ] && color="$AMBER"
[ "$percent" -lt 20 ] && color="$RED"
grep -q "AC Power" <<<"$batt" && { icon="$BATTERY_CHARGING"; color="$GREEN"; }

sketchybar --set "$NAME" drawing=on icon="$icon" icon.color="$color" label="${percent}%"
