#!/usr/bin/env bash
# Shell environment entry point — auto-detects bash or zsh
# Usage: echo 'source ~/ENV/env.sh' >> ~/.bashrc   (bash)
#        echo 'source ~/ENV/env.sh' >> ~/.zshrc    (zsh)
#
# Comment out any line in the relevant section to disable that module.

_ENV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" 2>/dev/null && pwd)"

if [[ -n "$ZSH_VERSION" ]]; then
    # ── zsh ───────────────────────────────────────────────────
    _D="$_ENV_ROOT/zsh"
    source "$_D/00-modules.zsh"   # Environment Modules: enables 'module load/unload/avail'
    source "$_D/01-path.zsh"      # PATH: typeset -U, prepends ~/.local/bin nvim cargo go bob
    source "$_D/02-exports.zsh"   # Exports: EDITOR, TERM, LANG, history, setopt, compinit
    source "$_D/03-colors.zsh"    # Colors: LS_COLORS, LESS_TERMCAP, GREP_COLOR
    source "$_D/04-aliases.zsh"   # Aliases: navigation, ls, editor, git, system, python
    source "$_D/05-fzf.zsh"       # FZF: default command, opts, zsh keybindings
    source "$_D/06-tools.zsh"     # Tools: bat, zoxide (zsh init), ripgrep smart-case
    source "$_D/07-functions.zsh" # Functions: cd (auto-venv), mcd, up, extract, backup, ff, fv, myip, localip, colors
    source "$_D/08-prompt.zsh"    # Prompt: exit-code + jobs + user:dir -> (via precmd)
    source "$_D/09-plugins.zsh"   # Plugins: zsh-autosuggestions, zsh-syntax-highlighting, neofetch/fastfetch on login

elif [[ -n "$BASH_VERSION" ]]; then
    # ── bash ──────────────────────────────────────────────────
    _D="$_ENV_ROOT/rc"
    source "$_D/00-modules.sh"    # Environment Modules: enables 'module load/unload/avail'
    source "$_D/01-path.sh"       # PATH: prepends ~/.local/bin nvim cargo go bob
    source "$_D/02-exports.sh"    # Exports: EDITOR, TERM, LANG, history, shopt, bind
    source "$_D/03-colors.sh"     # Colors: LS_COLORS, LESS_TERMCAP, GREP_COLOR
    source "$_D/04-aliases.sh"    # Aliases: navigation, ls, editor, git, system, python
    source "$_D/05-fzf.sh"        # FZF: default command, opts, bash keybindings
    source "$_D/06-tools.sh"      # Tools: bat, zoxide (bash init), ripgrep smart-case
    source "$_D/07-functions.sh"  # Functions: cd (autopushd+auto-venv), mcd, up, extract, backup, ff, fv, myip, localip, colors
    source "$_D/08-prompt.sh"     # Prompt: exit-code + jobs + user:dir -> (via PROMPT_COMMAND)
    source "$_D/09-plugins.sh"    # Plugins: bash-preexec, REPORTTIME (>=5s), neofetch/fastfetch on login

else
    echo "[env.sh] Unknown shell — neither BASH_VERSION nor ZSH_VERSION set." >&2
fi

unset _ENV_ROOT _D
