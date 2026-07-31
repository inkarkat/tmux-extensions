#!/bin/sh source-this-script

# Allow definition of tmux aliases (e.g. "tmux foo") by putting an executable
# "tmux-foo" somewhere in the PATH.
## tmux sp SHELL-COMMAND
##			Execute a passed SHELL-COMMAND in a vertically split
##			tmux pane (that automatically closes on confirmation
##			after SHELL-COMMAND concludes.)
##			SHELL-COMMAND can later also be re-executed via my
##			mappings that recall the queried command:
##			prefix + g* / prefix + g- / prefix + g|
## tmux vsp SHELL-COMMAND
##			Execute a passed SHELL-COMMAND in a horizontally split
##			tmux pane (that automatically closes on confirmation
##			after SHELL-COMMAND concludes.)
##			SHELL-COMMAND can later also be re-executed via my
##			mappings that recall the queried command:
##			prefix + g* / prefix + g- / prefix + g|
## tmux n SHELL-COMMAND	Execute a passed SHELL-COMMAND in a new tmux window
## tmux SHELL-COMMAND	(that automatically closes on confirmation after
##			SHELL-COMMAND concludes.)
##			SHELL-COMMAND can later also be re-executed via my
##			mappings that recall the queried command:
##			prefix + g* / prefix + g- / prefix + g|
_tmux_projectDir()
{
    typeset scriptDir="$(dirname -- "$(command -v tmux-wrapper)")"
    [ -d "$scriptDir" ] || { echo >&2 'ERROR: Cannot determine script directory!'; return 3; }
    printf %s "${scriptDir}/.."
}
tmux()
{
    typeset tmuxAlias="tmux-$1"
    if [ $# -eq 0 ]; then
	tmux-wrapper ${TMUX_DEFAULT_COMMAND:-new-session}
    elif type ${BASH_VERSION:+-t} "$tmuxAlias" >/dev/null 2>&1; then
	shift
	eval $tmuxAlias '"$@"'	# Need eval for shell aliases.
    elif [ "$1" = sp -o "$1" = vsp ]; then
	case "$1" in
	    sp)	    typeset splitArg=-v;;
	    vsp)    typeset splitArg=-h;;
	esac
	shift

	printf -v quotedCommand '%q ' "$@"
	tmux-wrapper \
	    set -g @queried_command "${quotedCommand% }" \; \
	    split-window $splitArg -c "#{pane_current_path}" "$(_tmux_projectDir)/lib/new-window-launcher.sh" \; \
	    set status on
    elif [ "$1" = n ] || type ${BASH_VERSION:+-t} -- "$1" >/dev/null; then
	[ "$1" = n ] && shift

	printf -v quotedCommand '%q ' "$@"
	tmux-wrapper \
	    set -g @queried_command "${quotedCommand% }" \; \
	    new-window -c "#{pane_current_path}" "$(_tmux_projectDir)/lib/new-window-launcher.sh" \; \
	    set status on
    else
	tmux-wrapper "$@"
    fi
}
