#!/bin/bash
#===============================================================================
#  ArchSpace by Sri™
#  Central Execution Hub for System Management & Setup Scripts
#  Author  : Sri
#  Version : 1.0
#  License : Free software (no warranty, use at your own risk)
#===============================================================================

set -euo pipefail
DIALOG_PACKAGE="dialog"
SCRIPT_TITLE="ArchSpace by Sri™"

# Cleanup on exit
cleanup() { clear; }
trap cleanup EXIT

main() {
    # Ensure running in a TTY
    if [ ! -t 0 ]; then exit 1; fi

    # Check for dialog package
    if ! command -v "$DIALOG_PACKAGE" &> /dev/null; then
        sleep 1
        sudo pacman -Sy --noconfirm "$DIALOG_PACKAGE" &> /dev/null
        sleep 2
    else
        sleep 1
    fi

    # Initial disclaimer and warning
    dialog --backtitle "Redirect Controller" --title "$SCRIPT_TITLE" --yes-label "Accept" --no-label "Decline" --yesno \
    "!!! CRITICAL EXECUTION NOTICE !!!\n\nThis script functions as the **central controller** for multiple system management and setup modules. Launching it will automatically invoke several subordinate scripts and background processes.\n\nBy continuing, you acknowledge and accept that:\n\n • This software is provided **as-is**, with **no warranty or liability**.\n • The author or maintainers **are not responsible** for any system instability, data loss, or damage resulting from its execution.\n • This utility is **free software**, intended solely to simplify repetitive setup and automation tasks.\n • Once started, this process may spawn **persistent or continuous operations** until manually terminated.\n\nProceed only if you understand the potential system impact and accept full responsibility for any resulting changes." 25 80 2>/dev/tty

    if [ $? -ne 0 ]; then
        dialog --title "$SCRIPT_TITLE - Session End" --msgbox \
        "You chose not to proceed. The persistent operation manager cannot be launched. Session terminated." 10 50 2>/dev/tty
        exit 0
    fi

    # Final confirmation
    dialog --backtitle "Redirect Controller" --title "$SCRIPT_TITLE - Final Confirmation" --yes-label "Accept and Continue" --no-label "Terminate Session" --yesno \
    "Are you absolutely sure you want to proceed? Once started, the system will initiate a **PROMPT-BASED configuration**, installing ONLY the packages you explicitly approve. This is your final chance to stop before initialization." 15 70 2>/dev/tty

    if [ $? -ne 0 ]; then
        dialog --title "$SCRIPT_TITLE - Session End" --msgbox \
        "You chose to terminate the session. All processes stopped." 10 50 2>/dev/tty
        exit 0
    fi

    # Exit after final confirmation
    dialog --title "$SCRIPT_TITLE - Launch Complete" --msgbox \
    "Initialization sequence accepted.\n\nFurther modules will be integrated in subsequent updates.\nSession will now close safely." 10 60 2>/dev/tty
    exit 0
}

main
