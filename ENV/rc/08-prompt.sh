#!/usr/bin/env bash
# Prompt — mirrors __setprompt from .bashrc.rrachapa
# Shows: exit_code (jobs) (user:dir) ->
# Only active in interactive shells

[[ $- != *i* ]] && return

export PROMPT_DIRTRIM=3

__setprompt() {
    local status=$? len
    local LAST_COMMAND
    len=${#status}
    if   [ $len -eq 1 ]; then LAST_COMMAND="00${status}"
    elif [ $len -eq 2 ]; then LAST_COMMAND="0${status}"
    else                       LAST_COMMAND="${status}"
    fi

    history -a   # flush history immediately

    local WHITE="\033[1;37m"
    local DARKGRAY="\033[1;30m"
    local LIGHTRED="\033[1;31m"
    local GREEN="\033[0;32m"
    local YELLOW="\033[1;33m"
    local LIGHTMAGENTA="\033[1;35m"
    local NOCOLOR="\033[0m"

    PS1="\[${LIGHTMAGENTA}\]${LAST_COMMAND}\[${WHITE}\]"
    PS1+="(\[${WHITE}\]\[${LIGHTRED}\]j:\j\[${WHITE}\])"
    PS1+="(\[${NOCOLOR}\]\[${LIGHTRED}\]\u\[${YELLOW}\]:\[${GREEN}\]\w\[${WHITE}\])\[${NOCOLOR}\]->"

    PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "
}

PROMPT_COMMAND='__setprompt'
