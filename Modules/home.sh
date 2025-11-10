#!/bin/bash
set -euo pipefail

# ╭────────────────────────────────────────────────────────────╮
# │                      ArchSpace by Sri™                     │
# │                  Automated Arch Linux Installer            │
# │                                                            │
# │  Author      : Sri                                         │
# │  Version     : 1.0                                         │
# │  License     : MIT                                         │
# │  Repository  : https://github.com/SriProjects/ArchSpace    │
# │  Description : A modular and extensible framework designed │
# │                to automate Arch Linux installation,        │
# │                configuration, and environment setup.       │
# ╰────────────────────────────────────────────────────────────╯

SCRIPT_TITLE="ArchSpace Home by Sri™"

BASE_DIR="$(dirname "$(realpath "$0")")"
OTHERS_DIR="$BASE_DIR/Others"

if ! command -v dialog &>/dev/null; then
    echo "Error: 'dialog' not installed. Run: sudo pacman -S dialog"
    exit 1
fi

EXIT_OPTION="Exit ArchSpace"

MENU_ORDER=(
    "Wipe, Mount & Format Drives"
    "Install Base System & Generate Fstab"
    "Configure Locale, Timezone & Hostname"
    "Setup Users, Groups & Sudo"
    "Setup Network & Internet"
    "Install Bluetooth & Audio Drivers"
    "Enable Essential Services & Daemons"
    "Install & Configure AUR Helper"
    "Install Custom & Recommended Packages"
    "System Update & Maintenance"
    "Install Desktop Environment & Display Manager"
    "Apply Themes, Wallpapers & Icons"
    "Setup Git, Docker & Dev Tools"
    "Setup Neovim / IDE & Programming Tools"
    "Backup, Restore & Verify System"
    "System Cleanup & Optimization"
    "$EXIT_OPTION"
)

declare -A SCRIPT_PATHS=(
    ["Wipe, Mount & Format Drives"]="$OTHERS_DIR/wipe_mount_format.sh"
    ["Install Base System & Generate Fstab"]="$OTHERS_DIR/base_install.sh"
    ["Configure Locale, Timezone & Hostname"]="$OTHERS_DIR/locale_time_hostname.sh"
    ["Setup Users, Groups & Sudo"]="$OTHERS_DIR/user_sudo.sh"
    ["Setup Network & Internet"]="$OTHERS_DIR/network_setup.sh"
    ["Install Bluetooth & Audio Drivers"]="$OTHERS_DIR/bluetooth_audio.sh"
    ["Enable Essential Services & Daemons"]="$OTHERS_DIR/enable_services.sh"
    ["Install & Configure AUR Helper"]="$OTHERS_DIR/aur_setup.sh"
    ["Install Custom & Recommended Packages"]="$OTHERS_DIR/custom_packages.sh"
    ["System Update & Maintenance"]="$OTHERS_DIR/system_update.sh"
    ["Install Desktop Environment & Display Manager"]="$OTHERS_DIR/desktop_env.sh"
    ["Apply Themes, Wallpapers & Icons"]="$OTHERS_DIR/themes_icons.sh"
    ["Setup Git, Docker & Dev Tools"]="$OTHERS_DIR/git_docker_setup.sh"
    ["Setup Neovim / IDE & Programming Tools"]="$OTHERS_DIR/neovim_setup.sh"
    ["Backup, Restore & Verify System"]="$OTHERS_DIR/backup.sh"
    ["System Cleanup & Optimization"]="$OTHERS_DIR/system_cleanup.sh"
)

launch_script() {
    clear
    local choice="$1"
    local script="${SCRIPT_PATHS[$choice]:-}"

    if [[ "$choice" == "$EXIT_OPTION" ]]; then
        clear
        echo -e "\n👋 Logging out from ArchSpace HQ — see you soon, Sri 🐧"
        sleep 1
        exit 0
    fi

    if [[ -n "$script" && -f "$script" ]]; then
        clear
        echo "───────────────────────────────────────────────"
        echo " Launching: $choice"
        echo "───────────────────────────────────────────────"
        sleep 1
        bash -c "bash '$script'; echo; read -p 'Press Enter to return to ArchSpace...' " || {
            echo "⚠️  '$choice' crashed or exited unexpectedly."
            sleep 2
        }
    elif [[ -n "$script" ]]; then
        echo "[⚙️] '$choice' selected — script not found yet."
        echo "[INFO] Expected path: $script"
        echo "[NOTE] Placeholder active. Test successful."
        sleep 2
    else
        echo "Invalid choice. Try again, Commander Sri."
        sleep 2
    fi
}

while true; do
    MENU_ITEMS=()
    for key in "${MENU_ORDER[@]}"; do
        MENU_ITEMS+=("$key" "")
    done

    CHOICE=$(dialog --clear \
        --backtitle "$SCRIPT_TITLE" \
        --title "🏠  ArchSpace Main Hub" \
        --menu "Welcome home, Sri! Choose your next mission:" \
        25 80 18 \
        "${MENU_ITEMS[@]}" \
        3>&1 1>&2 2>&3)

    if [[ -z "${CHOICE:-}" ]]; then
        clear
        echo "Cancelled. You may flee for now, but Arch awaits, Sri 🐧"
        exit 0
    fi

    launch_script "$CHOICE"
done
