#!/bin/bash
set -euo pipefail
SCRIPT_TITLE="ArchSpace by Sri™"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOS_FILE="$SCRIPT_DIR/tos.txt"

cleanup(){ clear; }
trap cleanup EXIT

accept_tos(){
    if [ ! -f "$TOS_FILE" ]; then
        echo "None" > "$TOS_FILE"
    fi

    dialog --title "$SCRIPT_TITLE" \
    --yes-label "Accept" --no-label "Decline" --yesno \
    "\n!!! CRITICAL EXECUTION NOTICE !!!\n\nThis script functions as the **central controller** for multiple system management and setup modules. Launching it will automatically invoke several subordinate scripts and background processes.\n\nBy continuing, you acknowledge and accept that:\n\n • This software is provided **as-is**, with **no warranty or liability**.\n • The author or maintainers **are not responsible** for any system instability, data loss, or damage resulting from its execution.\n • This utility is **free software**, intended solely to simplify repetitive setup and automation tasks.\n • Once started, this process may spawn **persistent or continuous operations** until manually terminated.\n\nProceed only if you understand the potential system impact and accept full responsibility for any resulting changes." 25 80 2>/dev/tty
    [ $? -ne 0 ] && echo "None" > "$TOS_FILE" && clear && exit 0

    dialog --title "$SCRIPT_TITLE - Final Confirmation" \
    --yes-label "Accept and Continue" --no-label "Terminate Session" --yesno \
    "\nAre you absolutely sure you want to proceed? Once started, the system will initiate a **PROMPT-BASED configuration**, installing ONLY the packages you explicitly approve. This is your final chance to stop before initialization." 15 70 2>/dev/tty
    [ $? -ne 0 ] && echo "None" > "$TOS_FILE" && clear && exit 0

    echo "accepted" > "$TOS_FILE"
    sync
}

accept_tos
