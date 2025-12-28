#!/bin/bash

WALLPAPER="$1"

# Set with hyprpaper
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"

# Generate pywal colorscheme
wal -i "$WALLPAPER" -e  # -e skips setting wallpaper itself

# Source colors in new shells (fish)
# Optional: reload kitty, waybar, etc.
# pkill -USR1 kitty  # Reload kitty theme if configured
