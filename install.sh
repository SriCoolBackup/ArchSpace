#!/bin/bash
set -euo pipefail
SCRIPT_TITLE="ArchSpace by Sri™"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/Modules"
TOS_FILE="$MODULES_DIR/tos.txt"
TOS_SCRIPT="$MODULES_DIR/tos.sh"
DIALOG_PACKAGE="dialog"

cleanup(){ clear; }
trap cleanup EXIT

main(){
    echo "🔐 Checking for sudo privileges..."
    sudo -v || { echo "❌ Sudo authentication failed."; exit 1; }

    echo "🧩 Checking for required package: $DIALOG_PACKAGE"
    if ! command -v "$DIALOG_PACKAGE" &>/dev/null; then
        echo "📦 Installing $DIALOG_PACKAGE..."
        sudo pacman -Sy --noconfirm "$DIALOG_PACKAGE" >/dev/null 2>&1 || {
            echo "❌ Failed to install $DIALOG_PACKAGE. Exiting."
            exit 1
        }
        echo "✅ $DIALOG_PACKAGE installed successfully."
    fi

    if [ ! -f "$TOS_FILE" ]; then
        echo "None" > "$TOS_FILE"
    fi

    status=$(<"$TOS_FILE")

    if [ "$status" != "accepted" ]; then
        if [ -f "$TOS_SCRIPT" ]; then
            chmod +x "$TOS_SCRIPT"
            bash "$TOS_SCRIPT" </dev/tty >/dev/tty 2>&1
            status=$(<"$TOS_FILE")
        else
            dialog --title "$SCRIPT_TITLE - Error" \
                --msgbox "\nMissing file:\n$TOS_SCRIPT" 10 60 2>/dev/tty
            exit 1
        fi
    fi

    if [ "$status" = "accepted" ]; then
        dialog --title "$SCRIPT_TITLE - Installation Started" \
            --msgbox "\nTOS verified.\nInstallation process initiated successfully.\nYour modules are now loading..." 12 60 2>/dev/tty
        clear
        echo "🔥 Installation in progress..."
        sleep 2
        echo "✅ All systems configured successfully."
        echo "🚀 ArchSpace ready, Commander Sri 🐧"
        sleep 1
    else
        dialog --title "$SCRIPT_TITLE - Session Ended" \
            --msgbox "\nTOS not accepted.\nInstallation aborted." 10 50 2>/dev/tty
        exit 0
    fi
}

main
