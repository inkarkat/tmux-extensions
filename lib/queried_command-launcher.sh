#!/bin/bash

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

# Use an overridden default-command to run the queried command e.g. on the
# remote system instead of locally.
defaultCommand="$(tmux show-options -Aqv default-command)"
[ -z "$defaultCommand" ] || [ "$defaultCommand" != "$(tmux show-options -Aqv default-shell)" ] || defaultCommand=''

commandName="$(commandName --eval --no-interpreter -- "$queriedCommand")"

PGID=$$ \
TERM_COLORS=256 \
    ensurePrompting --prompt 'Press any key to dismiss...' -- \
	runWithPrompt --command "${defaultCommand}${defaultCommand:+ }$queriedCommand"

readonly saveHistoryPluginHook=~/.tmux/plugins/tmux-logging-on-clear/scripts/save_complete_history.sh
[ ! -x "$saveHistoryPluginHook" ] \
    || HISTORY_NAME_OVERRIDE="${commandName:-command}" "$saveHistoryPluginHook"
