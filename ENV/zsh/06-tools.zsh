# Tool-specific config: bat, zoxide, ripgrep

#--- bat -------------------------------------------------------
if (( $+commands[bat] )); then
    export BAT_THEME="TwoDark"
    alias cat='bat --paging=never'
    alias catp='bat'
    alias bh='bat --paging=never -l help'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

#--- zoxide — frecency-based smart cd (z / zi) ----------------
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

#--- ripgrep --------------------------------------------------
if (( $+commands[rg] )); then
    alias rg='rg --smart-case'
fi
