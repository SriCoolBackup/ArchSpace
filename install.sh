#!/bin/bash
set -euo pipefail
SCRIPT_TITLE="ArchSpace by Sri™"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/Modules/tos"
TOS_FILE="$MODULES_DIR/tos.txt"
TOS_SCRIPT="$MODULES_DIR/tos.sh"
HOME_SCRIPT="$SCRIPT_DIR/Modules/home.sh"
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

    for i in {5..1}; do
        dialog --title "$SCRIPT_TITLE - TOS Accepted" \
        --infobox "\n✅ Terms and Service accepted.\n\nMoving on in... $i" 10 60
        sleep 1
    done

    clear
    if [ -f "$HOME_SCRIPT" ]; then
        chmod +x "$HOME_SCRIPT"
        bash "$HOME_SCRIPT"
    else
        echo "❌ Missing home script at: $HOME_SCRIPT"
        exit 1
    fi
}

main
