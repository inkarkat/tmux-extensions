#!/bin/bash source-this-script

# Source: http://www.debian-administration.org/articles/317 for how to write more.
_tmux()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts='
attach-session
bind-key
break-pane
capture-pane
choose-client
choose-session
choose-window
clear-history
clock-mode
command-prompt
confirm-before
copy-buffer
copy-mode
delete-buffer
detach-client
display-message
display-panes
down-pane
find-window
has-session
if-shell
join-pane
kill-pane
kill-server
kill-session
kill-window
last-window
link-window
list-buffers
list-clients
list-commands
list-keys
list-panes
list-sessions
list-windows
load-buffer
lock-client
lock-server
lock-session
move-window
new-session
new-window
next-layout
next-window
paste-buffer
pipe-pane
previous-layout
previous-window
refresh-client
rename-session
rename-window
resize-pane
respawn-window
rotate-window
run-shell
save-buffer
select-layout
select-pane
select-prompt
select-window
send-keys
send-prefix
server-info
set-buffer
set-environment
set-option
set-window-option
show-buffer
show-environment
show-messages
show-options
show-window-options
source-file
split-window
start-server
suspend-client
swap-pane
swap-window
switch-client
unbind-key
unlink-window
up-pane
'

    readarray -t COMPREPLY < <(compgen -W "${opts}" -- "$cur")
    return 0

}

_tmuxEx()
{
    local IFS=$'\n'
    typeset -a aliases=(); readarray -t aliases < <(compgen -A command -- 'tmux-')
    aliases=("${aliases[@]/#tmux-/}")

    if [ $COMP_CWORD -ge 2 ] && contains "${COMP_WORDS[1]}" "${aliases[@]}"; then
	local tmuxAlias="_tmux_${COMP_WORDS[1]//-/_}"
	# Completing an alias; delegate to its custom completion function (if
	# available)
	if type -t "$tmuxAlias" >/dev/null; then
	    COMP_WORDS=("tmux-${COMP_WORDS[1]}" "${COMP_WORDS[@]:2}")
	    let COMP_CWORD-=1
	    "$tmuxAlias" "${COMP_WORDS[0]}" "${COMP_WORDS[COMP_CWORD]}" "${COMP_WORDS[COMP_CWORD-1]}"
	    return $?
	fi
    fi
    unset IFS

    _tmux "$@"

    if [ $COMP_CWORD -eq 1 ]; then
	readarray -O ${#COMPREPLY[@]} -t COMPREPLY < <(
	    # Also offer (exported) shell functions and shell commands that my
	    # tmux() wrapper function executes in a new window.
	    compgen -A function -A command "${COMP_WORDS[COMP_CWORD]}"
	    # Also offer aliases (tmux-aliasname, callable via my tmux wrapper
	    # function as tmux aliasname).
	    compgen -W "${aliases[*]}" -X "!${2}*"
	)
    fi
}
complete -F _tmuxEx tmux
