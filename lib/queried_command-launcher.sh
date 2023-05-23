#!/bin/bash

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

exec runWithPrompt --command "$queriedCommand" --command userprompt
