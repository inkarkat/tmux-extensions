#!/bin/bash

readonly isSetWindowName="$1"; shift

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

# Use an overridden default-command to run the queried command e.g. on the
# remote system instead of locally.
defaultCommand="$(tmux show-options -Aqv default-command)"
[ -z "$defaultCommand" ] || [ "$defaultCommand" != "$(tmux show-options -Aqv default-shell)" ] || defaultCommand=''

typeset -a ensurePromptingArgs=()
if [ "$isSetWindowName" ]; then
    commandName="$(commandName --no-interpreter -- "$queriedCommand")"
    tmux rename-window "$commandName"

    printf -v quotedCommandName '%q' "(${commandName})"
    ensurePromptingArgs+=(--prompt-command "tmux rename-window $quotedCommandName")
fi

PGID=$$ \
TERM_COLORS=256 \
    exec \
	ensurePrompting "${ensurePromptingArgs[@]}" --prompt 'Press any key to dismiss...' -- \
	    runWithPrompt --command "${defaultCommand}${defaultCommand:+ }$queriedCommand"
