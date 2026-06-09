# PATH — zsh native dedup via typeset -U

typeset -U path   # automatically removes duplicates

path=(
    $HOME/.local/bin
    $HOME/.local/opt/nvim/bin
    $HOME/.cargo/bin
    $HOME/go/bin
    $HOME/.local/share/bob/nvim-bin
    $path
)

export PATH
