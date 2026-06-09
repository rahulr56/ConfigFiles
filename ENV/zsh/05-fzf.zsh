# FZF — fuzzy finder config and keybindings (zsh)

(( $+commands[fzf] )) || return

#--- Default source -------------------------------------------
if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden'
elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#--- Default opts ---------------------------------------------
export FZF_DEFAULT_OPTS="--layout=reverse-list --no-mouse --border --cycle \
--info=inline --height=40% --multi \
--preview-window=:hidden \
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} 2>/dev/null || cat {})) || ([[ -d {} ]] && tree -C {}) || echo {}' \
--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,hl+:#F92672 \
--prompt='∼ ' --pointer='▶' --marker='✓' \
--bind '?:toggle-preview' \
--bind 'ctrl-a:select-all'"

export FZF_CTRL_R_OPTS="--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672 \
--header 'CTRL-Y: copy to clipboard'"

#--- Load zsh keybindings (Ctrl-T, Ctrl-R, Alt-C) ------------
for _fzf_script in \
    "$HOME/.fzf.zsh" \
    "$HOME/.local/opt/fzf/shell/key-bindings.zsh" \
    "/usr/share/doc/fzf/examples/key-bindings.zsh" \
    "/usr/share/fzf/key-bindings.zsh"
do
    [[ -f "$_fzf_script" ]] && source "$_fzf_script" && break
done
unset _fzf_script
