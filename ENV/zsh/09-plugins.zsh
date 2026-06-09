# Zsh plugins: autosuggestions, syntax-highlighting, neofetch

if [[ -n "$ZSH" ]]; then
    # OMZ active — plugins already loaded via omz-config.zsh plugins=()
    # Just set keybinding for autosuggestions
    bindkey '^E' autosuggest-accept 2>/dev/null || true
else
    # No OMZ — load plugins manually from ~/.local/share/zsh/plugins/
    _ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"

    _ZSH_AUTOSUGGEST="$_ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if [[ -f "$_ZSH_AUTOSUGGEST" ]]; then
        source "$_ZSH_AUTOSUGGEST"
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
        bindkey '^E' autosuggest-accept
    fi

    # syntax-highlighting must be sourced LAST
    _ZSH_HIGHLIGHT="$_ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    if [[ -f "$_ZSH_HIGHLIGHT" ]]; then
        source "$_ZSH_HIGHLIGHT"
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
        ZSH_HIGHLIGHT_STYLES[path]='underline'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
    fi

    unset _ZSH_PLUGINS _ZSH_AUTOSUGGEST _ZSH_HIGHLIGHT
fi

#--- neofetch / fastfetch — system info on new shell ---------
if [[ -o interactive ]] && (( SHLVL == 1 )); then
    if (( $+commands[fastfetch] )); then
        fastfetch
    elif (( $+commands[neofetch] )); then
        neofetch
    fi
fi
