#!/bin/bash
set -euo pipefail

DIALOG=${DIALOG:-dialog}
LOG_FILE="/tmp/system_update_maintenance.log"

show_message() {
    $DIALOG --title "$1" --msgbox "$2" 10 60
}

progress() {
    $DIALOG --infobox "$1" 5 60
    sleep "${2:-2}"
}

clear_terminal() {
    clear
    tput reset
    echo -e "\n============================================================"
    echo " $1"
    echo "============================================================"
}

check_sudo_installed() {
    if ! command -v sudo &>/dev/null; then
        show_message "Error ❌" "Sudo is not installed.\nInstall sudo to continue."
        exit 1
    fi
}

validate_sudo() {
    if ! sudo -n true 2>/dev/null; then
        PASSWORD=$($DIALOG --title "Authentication Required 🔒" \
            --insecure --passwordbox "Enter sudo password, Sri 🐧:" 10 60 3>&1 1>&2 2>&3)
        clear_terminal "Validating Password..."
        echo "$PASSWORD" | sudo -S true 2>/dev/null || {
            show_message "Authentication Failed" "Wrong password.\nExiting maintenance..."
            exit 1
        }
    fi
}

main() {
    clear
    $DIALOG --title "System Update & Maintenance" \
        --infobox "Initializing maintenance environment... ⚙️" 5 60
    sleep 2

    $DIALOG --title "Welcome to the System Maintenance Console" \
        --msgbox "Sri 🐧, brace yourself.\n\nThis will:\n\n🧠 Update core packages\n🧩 Refresh AUR packages\n🧹 Purge caches\n\nLogs will appear in the terminal when commands run.\n\nProceed at your own risk." 14 60
    sleep 1

    check_sudo_installed
    validate_sudo
    sleep 1

    progress "Preparing for pacman update..." 2
    clear_terminal "Pacman Update in Progress"
    $DIALOG --infobox "Synchronizing databases...\nFetching the latest packages from Arch HQ 🛰️" 6 60
    sleep 2
    clear
    sudo pacman -Syu --noconfirm | tee "$LOG_FILE"
    sleep 2
    clear_terminal "Core Update Complete ✅"
    sleep 1

    HAS_YAY=$(command -v yay || true)
    HAS_PARU=$(command -v paru || true)

    if [[ -n "$HAS_YAY" || -n "$HAS_PARU" ]]; then
        if [[ -n "$HAS_YAY" && -n "$HAS_PARU" ]]; then
            $DIALOG --infobox "Detected both yay and paru.\nPreparing double AUR assault... ⚔️" 6 60
            sleep 3
            clear_terminal "AUR Update in Progress"
            clear
            yay -Syu --noconfirm | tee -a "$LOG_FILE"
            paru -Syu --noconfirm | tee -a "$LOG_FILE"
        elif [[ -n "$HAS_YAY" ]]; then
            $DIALOG --infobox "Detected yay.\nUnleashing yay’s AUR magic... 🪄" 6 60
            sleep 3
            clear_terminal "AUR Update in Progress"
            clear
            yay -Syu --noconfirm | tee -a "$LOG_FILE"
        else
            $DIALOG --infobox "Detected paru.\nDeploying paru power sequence... ⚙️" 6 60
            sleep 3
            clear_terminal "AUR Update in Progress"
            clear
            paru -Syu --noconfirm | tee -a "$LOG_FILE"
        fi
    else
        show_message "AUR Helper Missing" "No AUR helpers detected.\nSkipping AUR updates 💤."
    fi

    sleep 1
    $DIALOG --infobox "Initiating Cache Purge Protocol 🧹" 6 60
    sleep 2
    sudo pacman -Sc --noconfirm &>/dev/null || true
    sudo paccache -r &>/dev/null || true
    [[ -n "$HAS_YAY" ]] && yay -Scc --noconfirm &>/dev/null || true
    [[ -n "$HAS_PARU" ]] && paru -Scc --noconfirm &>/dev/null || true
    sleep 1

    $DIALOG --infobox "Verifying system integrity... 🔍" 6 60
    sudo pacman -Qk > /tmp/pacman-integrity.log || true
    sleep 2

    $DIALOG --title "🧾 Maintenance Logs" --textbox "$LOG_FILE" 20 70
    sleep 1
    $DIALOG --title "Integrity Report" --textbox "/tmp/pacman-integrity.log" 20 70
    sleep 1

    show_message "✅ Operation Complete" \
        "System Maintenance successfully executed!\n\nSri 🐧, your Arch is now sharper than ever.\n\nLogs saved at:\n$LOG_FILE"
    sleep 1

    clear_terminal "Mission Accomplished 🚀"
    sleep 1
}

main "$@"
