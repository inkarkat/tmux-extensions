#!/bin/bash
set -o pipefail

windowId="$(tmux display-message -p "#{window_id}" 2>/dev/null)"
< <(tmux display-message -p $'#{window_id}\t#{window_name}' 2>/dev/null) IFS=$'\t' read -r windowId windowName
SECONDS=0

    "$@"

if [ $SECONDS -le ${TMUX_NEWWINDOWLAUNCHER_PROMPT_TIME:-2} ]; then
    # Indicate inactive COMMAND by wrapping in (...).
    [ -n "$commandName" -a "$windowName" = "$commandName" -a -n "$windowId" ] && \
	tmux rename-window -t "$windowId" "(${commandName})"

    userprompt
fi

tmuxCurrentWindowNum="$(tmux display-message -p '#{session_windows}' 2>/dev/null)" || exit
[ $tmuxCurrentWindowNum -gt 2 ] || tmux set-option status off 2>/dev/null   # As we're still in the about-to-be-closed window, the threshold for clearing the status needs to be +1.
