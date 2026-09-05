#!/usr/bin/env bash
# Terminal colors: ls, less/man, grep

#--- ls colors ------------------------------------------------
export LS_COLORS='no=00:fi=00:di=1;35:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.zip=01;31:*.gz=01;31:*.bz2=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.png=01;35:*.mp3=01;35:*.wav=01;35:*cxx=1;38;5;114:*h=38;5;184:*mk=38;5;81:*log=01;34:*jou=0;33:'

#--- less / man page colors -----------------------------------
export LESS_TERMCAP_mb=$(printf '\e[01;31m')   # bold/blink   - red
export LESS_TERMCAP_md=$(printf '\e[01;32m')   # double-bright - green
export LESS_TERMCAP_me=$(printf '\e[0m')        # reset
export LESS_TERMCAP_se=$(printf '\e[0m')        # leave standout
export LESS_TERMCAP_so=$(printf '\e[01;33m')   # standout     - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')        # leave underline
export LESS_TERMCAP_us=$(printf '\e[04;33m')   # underline    - cyan
export GROFF_NO_SGR=1

#--- grep -----------------------------------------------------
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
