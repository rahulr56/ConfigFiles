#!/usr/bin/env bash
# Bash plugins: bash-preexec (preexec/precmd hooks), REPORTTIME, neofetch

#--- bash-preexec — adds preexec/precmd hooks to bash --------
# Mirrors zsh's hook system; required for REPORTTIME below
_PREEXEC="$HOME/.local/share/bash-preexec/bash-preexec.sh"
if [[ -f "$_PREEXEC" ]]; then
    source "$_PREEXEC"

    # REPORTTIME — print elapsed for commands taking >= 5 seconds
    _cmd_start=0
    preexec() { _cmd_start=$SECONDS; }
    precmd()  {
        local elapsed=$(( SECONDS - _cmd_start ))
        if (( _cmd_start > 0 && elapsed >= 5 )); then
            printf "[time] %ds\n" "$elapsed"
        fi
        _cmd_start=0
    }
fi
unset _PREEXEC

#--- neofetch / fastfetch — show system info on new shell ----
if [[ $- == *i* ]] && (( SHLVL == 1 )); then
    if command -v fastfetch &>/dev/null; then
        fastfetch
    elif command -v neofetch &>/dev/null; then
        neofetch
    fi
fi
