#!/bin/sh source-this-script

alias tmux-activate-on-fail='pipelinemunge _PS1OnFail tmux-activate-pane'
alias tmux-activate-on-fail-alert='export ALERT_FAIL_COMMAND=tmux-activate-pane'
