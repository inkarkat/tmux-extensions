#!/bin/sh source-this-script

_tmuxActivatePaneCommand="$(tmux-activate-pane --get-command)"
alias tmux-activate-on-fail="pipelinemunge _PS1OnFail '${_tmuxActivatePaneCommand}'; pipelinemunge RUNWITHPROMPT_FAIL_COMMAND '${_tmuxActivatePaneCommand}'; export RUNWITHPROMPT_FAIL_COMMAND"
alias tmux-activate-on-fail-alert="export ALERT_FAIL_COMMAND='${_tmuxActivatePaneCommand}'"
unset _tmuxActivatePaneCommand
