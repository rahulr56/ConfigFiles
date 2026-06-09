#!/usr/bin/env bash
# PATH — user-local binaries take precedence over system

_prepend_path() { [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"; }

_prepend_path "$HOME/.local/bin"
_prepend_path "$HOME/.local/opt/nvim/bin"
_prepend_path "$HOME/.cargo/bin"
_prepend_path "$HOME/go/bin"
_prepend_path "$HOME/.local/share/bob/nvim-bin"   # bob neovim manager
