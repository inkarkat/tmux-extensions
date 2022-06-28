#!/bin/bash
set -o pipefail

commandName="$(commandName --no-interpreter -- "$@")"
tmux rename-window "$commandName"

SECONDS=0
    "$@"
[ $SECONDS -gt ${TMUXCOMMANDLAUNCHER_PROMPT_TIME:-2} ] || userprompt

tmuxCurrentWindowNum="$(tmux display-message -p '#{session_windows}' 2>/dev/null)" || return
[ $tmuxCurrentWindowNum -gt 2 ] || tmux set-option status off 2>/dev/null   # As we're still in the about-to-be-closed window, the threshold for clearing the status needs to be +1.
