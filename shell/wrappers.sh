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
	eval $tmuxAlias '"$@"'	# Need eval for shell aliases.
    elif type ${BASH_VERSION:+-t} -- "$1" >/dev/null; then
	typeset scriptDir="$([ "${BASH_SOURCE[0]}" ] && dirname -- "${BASH_SOURCE[0]}" || exit 3)"
	[ -d "$scriptDir" ] || { echo >&2 'ERROR: Cannot determine script directory!'; exit 3; }
	typeset projectDir="${scriptDir}/.."
	typeset commandName="$(commandName --no-interpreter -- "$@")"
	tmux-wrapper set status on \; new-window -c "#{pane_current_path}" ${commandName:+-n "$commandName" -e "commandName=$commandName"} "${projectDir}/lib/new-window-launcher.sh" "$@"
    else
	tmux-wrapper "$@"
    fi
}
