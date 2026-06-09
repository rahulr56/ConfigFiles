# Core exports: editor, terminal, history, shell options

#--- Editor ---------------------------------------------------
if (( $+commands[nvim] )); then
    export EDITOR=nvim
    export VISUAL=nvim
    export MANPAGER='nvim +Man!'
elif (( $+commands[vim] )); then
    export EDITOR=vim
    export VISUAL=vim
fi

#--- Terminal -------------------------------------------------
export TERM=xterm-256color
export COLORTERM=truecolor
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CLICOLOR=1

#--- less -----------------------------------------------------
export LESS='-RXF'
export LESSHISTFILE=-

#--- History --------------------------------------------------
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

setopt APPEND_HISTORY          # append, don't overwrite (histappend)
setopt SHARE_HISTORY           # share history across sessions
setopt HIST_IGNORE_DUPS        # no consecutive duplicates
setopt HIST_IGNORE_SPACE       # ignore lines starting with space
setopt HIST_REDUCE_BLANKS      # strip extra blanks
setopt EXTENDED_HISTORY        # save timestamps

#--- Shell options --------------------------------------------
setopt AUTO_CD                 # type dir name to cd into it
setopt CORRECT                 # spell correction (cdspell)
setopt NO_FLOW_CONTROL         # disable Ctrl-S/Q (stty -ixon)
setopt INTERACTIVE_COMMENTS    # allow # comments in interactive shell
setopt GLOB_STAR_SHORT         # ** glob (globstar)
setopt PROMPT_SUBST            # enable $(cmd) in PROMPT

#--- Completion -----------------------------------------------
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive
zstyle ':completion:*' menu select                     # arrow-key menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true                     # auto-find new cmds

#--- Python ---------------------------------------------------
[[ -f "$HOME/.python_startup.py" ]] && export PYTHONSTARTUP="$HOME/.python_startup.py"
