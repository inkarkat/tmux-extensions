#!/bin/sh source-this-script

# Allow definition of tmux aliases (e.g. "tmux foo") by putting an executable
# "tmux-foo" somewhere in the PATH.
tmux()
{
    typeset tmuxAlias="tmux-$1"
    if [ $# -eq 0 ]; then
	tmux-wrapper ${TMUX_DEFAULT_COMMAND:-new-session}
    elif type ${BASH_VERSION:+-t} "$tmuxAlias" >/dev/null 2>&1; then
	shift
	$tmuxAlias "$@"
    else
	tmux-wrapper "$@"
    fi
}
