#!/usr/bin/env bash
# Core exports: editor, terminal, history, shell options

#--- Editor — set for every tool that respects these vars -----
_EDITOR_BIN=""
if command -v nvim &>/dev/null; then
    _EDITOR_BIN="$(command -v nvim)"
elif command -v vim &>/dev/null; then
    _EDITOR_BIN="$(command -v vim)"
fi

if [[ -n "$_EDITOR_BIN" ]]; then
    export EDITOR="$_EDITOR_BIN"
    export VISUAL="$_EDITOR_BIN"
    export SUDO_EDITOR="$_EDITOR_BIN"   # used by sudoedit / sudo -e
    export GIT_EDITOR="$_EDITOR_BIN"    # overrides core.editor for this session
    export SVN_EDITOR="$_EDITOR_BIN"
    export HGEDITOR="$_EDITOR_BIN"
    export FCEDIT="$_EDITOR_BIN"        # used by fc (history editing)
    export CVSEDITOR="$_EDITOR_BIN"

    # Man pages: prefer nvim, fall back to less
    if [[ "$_EDITOR_BIN" == *nvim* ]]; then
        export MANPAGER='nvim +Man!'
    fi
fi
unset _EDITOR_BIN

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
    bind "set completion-ignore-case on"      2>/dev/null || true
    bind "set show-all-if-ambiguous On"       2>/dev/null || true
    # Arrow key prefix search — Up/Down searches history matching typed prefix
    bind '"\e[A": history-search-backward'    2>/dev/null || true
    bind '"\e[B": history-search-forward'     2>/dev/null || true
fi

#--- Python ---------------------------------------------------
[ -f "$HOME/.python_startup.py" ] && export PYTHONSTARTUP="$HOME/.python_startup.py"
