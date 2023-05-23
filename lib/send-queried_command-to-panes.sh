#!/bin/bash

queriedCommand="$(tmux show-options -gv @queried_command)"
[ -n "$queriedCommand" ] || exit 99

exec xargs -I PANE tmux send-keys -t PANE "$queriedCommand" Enter
