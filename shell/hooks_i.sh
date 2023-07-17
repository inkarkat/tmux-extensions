#!/bin/sh source-this-script

[ "${TMUX:-}" ] || return

_PS1TmuxHook()
{
    # tmux doesn't have event hooks yet; often, we can extend built-in mappings
    # or external tmux commands, but for some events, we have to poll.
    # This checks the number of windows, and automatically enables the status
    # line when a second window is opened disables when closing a window leaves
    # a single one behind. The update happens via an asynchronous trigger on
    # each prompt. For the delta detection, we store the number of windows from
    # the previous poll in a tmux session-scoped user variable, so that it is
    # available from all shells that run in that session.
    typeset tmuxPreviousWindowNum="$(tmux show-option -vq @tmuxPreviousWindowNum 2>/dev/null)" || return
    typeset tmuxCurrentWindowNum="$(tmux display-message -p '#{session_windows}' 2>/dev/null)" || return

    [ ${tmuxCurrentWindowNum:-0} -eq ${tmuxPreviousWindowNum:-0} ] && return
    tmux set-option @tmuxPreviousWindowNum "$tmuxCurrentWindowNum" 2>/dev/null

    if [ ${tmuxCurrentWindowNum:-0} -eq 1 -a ${tmuxPreviousWindowNum:-0} -gt 1 ]; then
	tmux set-option status off 2>/dev/null
    elif [ ${tmuxCurrentWindowNum:-0} -gt 1 -a ${tmuxPreviousWindowNum:-0} -eq 1 ]; then
	tmux set-option status on 2>/dev/null
    fi
}

commandSequenceMunge _PS1OnPromptAsync _PS1TmuxHook

# Persist the session's output on exit (only for the initial shell, not for nested shells).
[ $((SHLVL - ${_SHLVL_TMUX:-0} - ${_SHLVL_BASE:?})) -gt 0 ] || ! type ${BASH_VERSION:+-t} tmux-clear >/dev/null 2>&1 \
    || commandSequenceMunge _PS1OnExitShell 'tmux-clear --no-clear'
