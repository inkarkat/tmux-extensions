#!/bin/sh source-this-script

# Allow definition of tmux aliases (e.g. "tmux foo") by putting an executable
# "tmux-foo" somewhere in the PATH.
# Execute a passed COMMAND in a new tmux window (that automatically closes after
# COMMAND concludes.)
tmux()
{
    typeset tmuxAlias="tmux-$1"
    if [ $# -eq 0 ]; then
	tmux-wrapper ${TMUX_DEFAULT_COMMAND:-new-session}
    elif type ${BASH_VERSION:+-t} "$tmuxAlias" >/dev/null 2>&1; then
	shift
	$tmuxAlias "$@"
    elif type ${BASH_VERSION:+-t} "$1" >/dev/null; then
	tmux-wrapper set status on \; new-window -c "#{pane_current_path}" "$@"
    else
	tmux-wrapper "$@"
    fi
}
