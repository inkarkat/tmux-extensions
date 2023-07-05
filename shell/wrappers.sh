#!/bin/sh source-this-script

# Allow definition of tmux aliases (e.g. "tmux foo") by putting an executable
# "tmux-foo" somewhere in the PATH.
# Execute a passed SHELL-COMMAND in a new tmux window (that automatically closes
# after SHELL-COMMAND concludes.) SHELL-COMMAND can later also be re-executed
# via my mappings that recall the queried command (prefix + g* / prefix + g-).
tmux()
{
    typeset tmuxAlias="tmux-$1"
    if [ $# -eq 0 ]; then
	tmux-wrapper ${TMUX_DEFAULT_COMMAND:-new-session}
    elif type ${BASH_VERSION:+-t} "$tmuxAlias" >/dev/null 2>&1; then
	shift
	eval $tmuxAlias '"$@"'	# Need eval for shell aliases.
    elif type ${BASH_VERSION:+-t} -- "$1" >/dev/null; then
	typeset scriptDir="$(dirname -- "$(command -v tmux-wrapper)")"
	[ -d "$scriptDir" ] || { echo >&2 'ERROR: Cannot determine script directory!'; return 3; }
	typeset projectDir="${scriptDir}/.."
	printf -v quotedCommand '%q ' "$@"
	tmux-wrapper set status on \; set -g @queried_command "${quotedCommand% }" \; new-window -c "#{pane_current_path}" "${projectDir}/lib/new-window-launcher.sh"
    else
	tmux-wrapper "$@"
    fi
}
