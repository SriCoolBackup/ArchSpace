#!/bin/bash
set -euo pipefail

DIALOG_PACKAGE="dialog"

cleanup() {
    clear
}
trap cleanup EXIT

display_message() {
    local TITLE="TUI Initialized"
    local MSG="All dependencies confirmed. The TUI environment is fully operational."
    local HEIGHT=10
    local WIDTH=60
    local BACKTITLE="System Utility"

    dialog --backtitle "$BACKTITLE" \
           --title "$TITLE" \
           --msgbox "$MSG" $HEIGHT $WIDTH 2>/dev/tty
}

main() {
    if [ ! -t 0 ]; then
        exit 1
    fi
    
    if ! command -v "$DIALOG_PACKAGE" &> /dev/null; then
        sudo pacman -Sy --noconfirm "$DIALOG_PACKAGE" &> /dev/null
    fi

    display_message
}

main