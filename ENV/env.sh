#!/usr/bin/env bash
# Shell environment entry point
# Usage: echo 'source ~/ENV/env.sh' >> ~/.bashrc
#
# Sources rc/ modules in order. Comment out any line to disable that module.

_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rc"

source "$_ENV_DIR/00-modules.sh"   # Environment Modules: enables 'module load/unload/avail' — tries common init paths (Lmod, TCL modules)
source "$_ENV_DIR/01-path.sh"      # PATH: prepends ~/.local/bin, nvim, cargo, go, bob — user tools take precedence over system
source "$_ENV_DIR/02-exports.sh"   # Exports: EDITOR=nvim, TERM, LANG, history (50k), shell opts (globstar, cdspell, direxpand), tab completion
source "$_ENV_DIR/03-colors.sh"    # Colors: LS_COLORS (ls), LESS_TERMCAP (man pages), GREP_COLOR — all terminal color settings
source "$_ENV_DIR/04-aliases.sh"   # Aliases: navigation (.. .3 .6), ls variants, editor (v/vi/vim/vd/vr), git (gs/gd/gl), system, python
source "$_ENV_DIR/05-fzf.sh"       # FZF: default command (fd/rg), rich opts with colors/preview/multi-select, Ctrl-T/Ctrl-R keybindings
source "$_ENV_DIR/06-tools.sh"     # Tools: bat (syntax cat, man pages), zoxide (z/zi smart cd), ripgrep smart-case
source "$_ENV_DIR/07-functions.sh" # Functions: cd (auto-ls), mcd, up, extract, backup, ff, fv, path, serve, topcpu, colors
source "$_ENV_DIR/08-prompt.sh"    # Prompt: PS1 showing exit-code + jobs + user:dir — mirrors __setprompt from .bashrc.rrachapa

unset _ENV_DIR
