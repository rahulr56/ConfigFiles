# Oh My Zsh configuration
# Sourced BEFORE $ZSH/oh-my-zsh.sh
# Set ZSH_THEME="" to use our custom prompt from 08-prompt.zsh instead

export ZSH="$HOME/.oh-my-zsh"

# Theme — set to "" to use custom prompt in 08-prompt.zsh
# Popular choices: robbyrussell, agnoster, af-magic, half-life
# For powerline: install powerlevel10k then set "powerlevel10k/powerlevel10k"
ZSH_THEME="af-magic"

# Plugins — OMZ handles install path for zsh-users plugins
# zsh-autosuggestions and zsh-syntax-highlighting must be cloned into
# $ZSH_CUSTOM/plugins/ (install.sh does this automatically)
plugins=(
    git                    # git aliases (gst, gco, glog, etc.)
    zsh-autosuggestions    # fish-like inline suggestions
    zsh-syntax-highlighting # color commands before Enter (load last)
    fzf                    # fzf keybindings + completion
    z                      # z/zoxide directory jumping
    python                 # py, pip aliases + venv helpers
    pip                    # pip completion
    sudo                   # press ESC ESC to prepend sudo to last cmd
    colored-man-pages      # colors in man pages
    command-not-found      # suggest package when cmd not found
    extract                # universal extract() function
    history                # history aliases (h, hs, hsi)
    dirhistory             # Alt+Left/Right navigate dir history
)

# OMZ behavior
ENABLE_CORRECTION=false          # we use setopt CORRECT selectively
COMPLETION_WAITING_DOTS=true     # show ... while completing
HIST_STAMPS="yyyy-mm-dd"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
