# Shell functions (zsh)

# cd — auto-ls after every directory change
cd() { builtin cd "$@" && ls; }

# mcd — mkdir + cd
mcd() { mkdir -p "$1" && cd "$1"; }

# up N — go up N directories
up() {
    local d='' n="${1:-1}"
    for (( i=0; i<n; i++ )); do d="../$d"; done
    cd "$d" || return
}

# extract — universal archive extractor
extract() {
    [[ ! -f "$1" ]] && echo "'$1' is not a file" && return 1
    case "$1" in
        *.tar.bz2)  tar xjf "$1"        ;;
        *.tar.gz)   tar xzf "$1"        ;;
        *.tar.xz)   tar xJf "$1"        ;;
        *.tar.zst)  tar --zstd -xf "$1" ;;
        *.bz2)      bunzip2 "$1"        ;;
        *.gz)       gunzip "$1"         ;;
        *.tar)      tar xf "$1"         ;;
        *.tbz2)     tar xjf "$1"        ;;
        *.tgz)      tar xzf "$1"        ;;
        *.zip)      unzip "$1"          ;;
        *.Z)        uncompress "$1"     ;;
        *.7z)       7z x "$1"           ;;
        *)          echo "Cannot extract '$1'" ;;
    esac
}

# backup — copy with timestamp suffix
backup() {
    [[ -z "$1" ]] && echo "Usage: backup <file>" && return 1
    cp -av "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

# ff — find file by name
ff() { find . -iname "*$1*" 2>/dev/null; }

# fv — fzf → open in nvim
if (( $+commands[fzf] )) && (( $+commands[nvim] )); then
    fv() { local f; f=$(fzf --preview 'head -50 {}') && nvim "$f"; }
fi

# path — show PATH one entry per line
path() { echo "$PATH" | tr ':' '\n'; }

# serve — quick HTTP server
serve() { python3 -m http.server "${1:-8000}"; }

# topcpu — top 10 CPU-hungry processes
topcpu() { ps -eo pcpu,pid,user,args | sort -k1 -r | head -10; }

# colors — show all 256 terminal colors
colors() {
    echo "=== 16 basic ==="
    for i in {0..15}; do
        printf "\e[38;5;%dm %4d \e[0m" "$i" "$i"
        (( (i+1) % 8 == 0 )) && echo
    done
    echo -e "\n=== 216 color cube ==="
    for i in {16..231}; do
        printf "\e[38;5;%dm %4d \e[0m" "$i" "$i"
        (( (i-15) % 6 == 0 )) && echo
    done
    echo -e "\n=== 24 grayscale ==="
    for i in {232..255}; do
        printf "\e[38;5;%dm %4d \e[0m" "$i" "$i"
    done
    printf "\e[0m\n"
}
