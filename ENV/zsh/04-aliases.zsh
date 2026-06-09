# Aliases: navigation, ls, editor, git, system, python
# Identical to bash — aliases work the same in zsh

#--- Navigation -----------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias ~='cd ~'
alias -- -='cd -'

#--- ls -------------------------------------------------------
if (( $+commands[eza] )); then
    alias ls='eza --color=auto --icons'
    alias ll='eza -lh --color=auto --icons'
    alias la='eza -lah --color=auto --icons'
    alias lt='eza --tree --level=2 --color=auto'
    alias lk='eza -lhS --color=auto'
    alias lr='eza -lhR --color=auto'
else
    alias ls='ls -Fh --color=always'
    alias ll='ls -lh --color=always'
    alias la='ls -lah --color=always'
    alias lt='ls -ltrh --color=always'
    alias lk='ls -lSrh --color=always'
    alias lx='ls -lXBh --color=always'
    alias lr='ls -lRh  --color=always'
    alias lc='ls -lcrh --color=always'
    alias lu='ls -lurh --color=always'
    alias lm='ls -alh  --color=always | more'
    alias lw='ls -xAh  --color=always'
    alias labc='ls -lap --color=always'
    alias lf="ls -l | grep -v '^d'"
    alias ldir="ls -l  | grep '^d'"
fi
alias l='ls'

#--- Editor ---------------------------------------------------
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vd='nvim -d'
alias vs='nvim -S'
alias vr='nvim -R'

if (( $+commands[fzf] )) && (( $+commands[nvim] )); then
    alias vif='nvim -o $(fzf)'
fi

#--- Git ------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git pull'
alias gco='git checkout'
alias gbr='git branch'

#--- System ---------------------------------------------------
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias psg='ps aux | grep'
alias eg='env | grep'
alias h='history | grep'
alias p='ps aux | grep'
alias mkdir='mkdir -p'
alias less='less -R'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias ports='ss -tulnp'
alias svi='sudo vi'
alias c='clear'
alias o='less -R'
alias j='jobs'
alias tailf='tail -f'
alias reload='source ~/.zshrc && echo reloaded'

#--- Python ---------------------------------------------------
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source ./venv/bin/activate'

#--- tldr / cheat fallback ------------------------------------
if ! (( $+commands[tldr] )) && (( $+commands[cheat] )); then
    alias tldr='cheat'
fi
