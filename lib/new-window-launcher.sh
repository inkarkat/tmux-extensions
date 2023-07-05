#!/bin/bash
set -o pipefail

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

# Use an overridden default-command to run the queried command e.g. on the
# remote system instead of locally.
defaultCommand="$(tmux show-options -Aqv default-command)"
[ -z "$defaultCommand" ] || [ "$defaultCommand" != "$(tmux show-options -Aqv default-shell)" ] || defaultCommand=''

windowId="$(tmux display-message -p "#{window_id}" 2>/dev/null)"

typeset -a ensurePromptingArgs=()
commandName="$(commandName --eval --no-interpreter -- "$queriedCommand")"
if [ -n "$commandName" ]; then
    tmux rename-window "$commandName"

    # Indicate inactive COMMAND by wrapping in (...) (but only if the COMMAND
    # did not change it).
    printf -v quotedCommandName '%q' "$commandName"
    printf -v quotedWindowdId '%q' "$windowId"
    ensurePromptingArgs+=(--prompt-command "[ \"\$(tmux display-message -t $quotedWindowdId -p '#{window_name}' 2>/dev/null)\" = $quotedCommandName ] && tmux rename-window '('$quotedCommandName')'")
fi

PGID=$$ \
TERM_COLORS=256 \
    ensurePrompting "${ensurePromptingArgs[@]}" --prompt 'Press any key to dismiss...' -- \
	runWithPrompt --command "${defaultCommand}${defaultCommand:+ }$queriedCommand"

tmuxCurrentWindowNum="$(tmux display-message -p '#{session_windows}' 2>/dev/null)" || exit
[ $tmuxCurrentWindowNum -gt 2 ] || tmux set-option status off 2>/dev/null   # As we're still in the about-to-be-closed window, the threshold for clearing the status needs to be +1.
