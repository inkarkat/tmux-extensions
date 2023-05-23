#!/bin/bash

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

PGID=$$ \
TERM_COLORS=256 \
    exec \
	ensurePrompting --prompt 'Press any key to dismiss...' -- \
	    runWithPrompt --command "$queriedCommand"
