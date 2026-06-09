#!/usr/bin/env bash
# Core exports: editor, terminal, history, shell options

#--- Editor ---------------------------------------------------
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
    export MANPAGER='nvim +Man!'
elif command -v vim &>/dev/null; then
    export EDITOR=vim
    export VISUAL=vim
fi

#--- Terminal -------------------------------------------------
export TERM=xterm-256color
export COLORTERM=truecolor
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CLICOLOR=1

#--- less -----------------------------------------------------
export LESS='-RXF'       # colors, no-clear-screen, quit-if-one-screen
export LESSHISTFILE=-    # don't write ~/.lesshst

#--- History --------------------------------------------------
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=erasedups:ignoredups:ignorespace
export HISTTIMEFORMAT="%F %T  "
shopt -s histappend 2>/dev/null || true

#--- Shell options --------------------------------------------
shopt -s checkwinsize 2>/dev/null || true   # update LINES/COLUMNS
shopt -s globstar     2>/dev/null || true   # ** glob
shopt -s cdspell      2>/dev/null || true   # typo correction for cd
shopt -s direxpand    2>/dev/null || true   # expand vars on TAB

stty -ixon 2>/dev/null || true   # Ctrl-S forward history search

if [[ $- == *i* ]]; then
    bind "set completion-ignore-case on" 2>/dev/null || true
    bind "set show-all-if-ambiguous On"  2>/dev/null || true
fi

#--- Python ---------------------------------------------------
[ -f "$HOME/.python_startup.py" ] && export PYTHONSTARTUP="$HOME/.python_startup.py"
