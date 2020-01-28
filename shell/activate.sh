#!/bin/sh source-this-script

alias tmux-activate-on-fail='pipelinemunge _PS1OnFail tmux-activate-pane; pipelinemunge RUNWITHPROMPT_FAIL_COMMAND tmux-activate-pane; export RUNWITHPROMPT_FAIL_COMMAND'
alias tmux-activate-on-fail-alert='export ALERT_FAIL_COMMAND=tmux-activate-pane'
