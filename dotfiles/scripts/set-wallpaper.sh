#!/bin/bash

WALLPAPER_DIR="$HOME/.config/backgrounds/"

# Find all images
WALLPAPERS=($WALLPAPER_DIR/*.{jpg,jpeg,png,JPG,JPEG,PNG} 2>/dev/null)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Pick random
RANDOM_WP=${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}

# Set with swww (smooth transition)
swww img "$RANDOM_WP" --transition-type wipe --transition-duration 2 --transition-fps 60

# Generate pywal colors (quiet, no wallpaper set)
wal -i "$RANDOM_WP" -q -t  # -t for better transparency, -q quiet

# Optional: Reload apps that support wal (waybar, kitty if configured)
killall -USR1 waybar  # If waybar supports reload

# Notification
notify-send "Wallpaper changed" "$(basename "$RANDOM_WP")"
