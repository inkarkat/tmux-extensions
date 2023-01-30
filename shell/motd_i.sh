#!/bin/bash source-this-script

# Also show the message-of-the day on the very first Tmux session.

# The first login shell has already shown the MOTD.
shopt -q login_shell 2>/dev/null && return

# The first Tmux session is when there's just one session, it is the first pane
# in the first window.
[ "$(tmux list-sessions -F '#{session_windows} #{pane_index}')" = '1 0' ] || return

. ~/profile.d/motd_i.sh
