#!/bin/bash
set -euo pipefail

# Title for Dialogs
SCRIPT_TITLE="ArchSpace Home by Sri™"

# Define script paths (adjust these to your real paths)
BASE_DIR="$(dirname "$(realpath "$0")")"
OTHERS_DIR="$BASE_DIR/Others"

INSTALL_SCRIPT="$OTHERS_DIR/install.sh"
TOS_SCRIPT="$OTHERS_DIR/tos.sh"
ABOUT_SCRIPT="$OTHERS_DIR/about.sh"
EXIT_OPTION="Exit ArchSpace"

# Function to launch selected script
launch_script() {
    clear
    case "$1" in
        "Install Packages")
            bash "$INSTALL_SCRIPT"
            ;;
        "Terms of Service")
            bash "$TOS_SCRIPT"
            ;;
        "About ArchSpace")
            bash "$ABOUT_SCRIPT"
            ;;
        "$EXIT_OPTION")
            clear
            echo "See ya, Sri 🐧 — logging out from ArchSpace HQ..."
            sleep 1
            exit 0
            ;;
        *)
            echo "Invalid choice. Are you drunk or just tired of bash?"
            ;;
    esac
}

# Main Menu
while true; do
    CHOICE=$(dialog --clear \
        --backtitle "$SCRIPT_TITLE" \
        --title "🏠 ArchSpace Main Hub" \
        --menu "Welcome home, Sri! What do you want to do today?" \
        20 60 10 \
        "Install Packages" "Run the main install hub" \
        "Terms of Service" "Review or accept the TOS" \
        "About ArchSpace" "Know the project details" \
        "$EXIT_OPTION" "Leave ArchSpace safely" \
        3>&1 1>&2 2>&3)

    # If user hits cancel or ESC
    if [ $? -ne 0 ]; then
        clear
        echo "Cancelled. You can run me again when you stop panicking 🐧"
        exit 0
    fi

    launch_script "$CHOICE"
done
