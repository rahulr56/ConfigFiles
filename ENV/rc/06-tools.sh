#!/usr/bin/env bash
# Tool-specific config: bat, zoxide, ripgrep

#--- bat — syntax-highlighted cat ----------------------------
if command -v bat &>/dev/null; then
    export BAT_THEME="TwoDark"
    alias cat='bat --paging=never'
    alias catp='bat'
    alias bh='bat --paging=never -l help'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

#--- zoxide — frecency-based smart cd (z / zi) ---------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

#--- ripgrep — smart-case by default -------------------------
if command -v rg &>/dev/null; then
    alias rg='rg --smart-case'
fi
