#!/bin/bash

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

# Use an overridden default-command to run the queried command e.g. on the
# remote system instead of locally.
defaultCommand="$(tmux show-options -Aqv default-command)"
[ -z "$defaultCommand" ] || [ "$defaultCommand" != "$(tmux show-options -Aqv default-shell)" ] || defaultCommand=''

PGID=$$ \
TERM_COLORS=256 \
    exec \
	ensurePrompting --prompt 'Press any key to dismiss...' -- \
	    runWithPrompt --command "${defaultCommand}${defaultCommand:+ }$queriedCommand"
