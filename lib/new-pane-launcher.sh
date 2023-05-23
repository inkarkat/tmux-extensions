#!/bin/bash
set -o pipefail

SECONDS=0

    "$@"

if [ $SECONDS -le ${TMUX_NEWPANELAUNCHER_PROMPT_TIME:-2} ]; then
    userprompt
fi
