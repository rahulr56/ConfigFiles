# Core exports: editor, terminal, history, shell options

#--- Editor — set for every tool that respects these vars -----
local _EDITOR_BIN=""
if (( $+commands[nvim] )); then
    _EDITOR_BIN="$(command -v nvim)"
elif (( $+commands[vim] )); then
    _EDITOR_BIN="$(command -v vim)"
fi

if [[ -n "$_EDITOR_BIN" ]]; then
    export EDITOR="$_EDITOR_BIN"
    export VISUAL="$_EDITOR_BIN"
    export SUDO_EDITOR="$_EDITOR_BIN"   # used by sudoedit / sudo -e
    export GIT_EDITOR="$_EDITOR_BIN"    # overrides core.editor for this session
    export SVN_EDITOR="$_EDITOR_BIN"
    export HGEDITOR="$_EDITOR_BIN"
    export FCEDIT="$_EDITOR_BIN"        # used by fc (history editing)
    export CVSEDITOR="$_EDITOR_BIN"

    if [[ "$_EDITOR_BIN" == *nvim* ]]; then
        export MANPAGER='nvim +Man!'
    fi
fi
unset _EDITOR_BIN

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

# autopushd — every cd auto-pushes to dir stack (zoxide-compatible)
setopt AUTO_PUSHD              # cd acts like pushd
setopt PUSHD_IGNORE_DUPS       # no duplicate entries in stack
setopt PUSHD_SILENT            # no stack printout on pushd/popd

# Arrow key prefix history search
bindkey '^[[A' history-search-backward 2>/dev/null
bindkey '^[[B' history-search-forward  2>/dev/null

# Report elapsed time for commands taking longer than N seconds
REPORTTIME=5

#--- Completion (skip if OMZ already ran compinit) ------------
if [[ -z "$ZSH" ]]; then
    autoload -Uz compinit && compinit
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive
zstyle ':completion:*' menu select                     # arrow-key menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true                     # auto-find new cmds

#--- Python ---------------------------------------------------
[[ -f "$HOME/.python_startup.py" ]] && export PYTHONSTARTUP="$HOME/.python_startup.py"
