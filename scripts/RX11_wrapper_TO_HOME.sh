#!/usr/bin/env bash
# Get the native Linux path from REAPER
LINUX_PATH="$1"

# Translate it to a Windows path using winepath
WINE_PATH=$(winepath -w "$LINUX_PATH")

# Launch iZotope RX inside your specific Wine prefix with the converted path
# Update the WINEPREFIX and path to your RX executable accordingly
WINEPREFIX="$HOME/.wine" wine "$WINEPREFIX/home/kirill/.wine/drive_c/Program Files/iZotope/RX 11 Audio Editor/win64/iZotope RX 11 Audio Editor.exe" "$WINE_PATH"
