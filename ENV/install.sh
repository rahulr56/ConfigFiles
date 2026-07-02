#!/usr/bin/env bash
# Generic dev environment installer — no sudo, no proprietary tools
# Installs to ~/.local/ (user-local, no root needed)
# Run: bash install.sh
# Re-run anytime to update tools.

set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)


info()  { echo -e "${GREEN}[install]${NC} $*"; }
warn()  { echo -e "${YELLOW}[skip]${NC}   $*"; }
abort() { echo -e "${RED}[error]${NC}  $*"; exit 1; }
header(){ echo -e "\n${BOLD}=== $* ===${NC}"; }

BIN="$HOME/.local/bin"
OPT="$HOME/.local/opt"
mkdir -p "$BIN" "$OPT"

ARCH="$(uname -m)"   # x86_64 or aarch64
OS="$(uname -s)"     # Linux

# Detect latest GitHub release tag
gh_latest() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
        | grep '"tag_name"' | cut -d'"' -f4
}

# Check if tool already at desired version
already() {
    local cmd="$1" ver="$2"
    command -v "$cmd" >/dev/null 2>&1 && \
    "$cmd" --version 2>/dev/null | grep -qF "$ver" 2>/dev/null
}

#================================================================
# 1. Neovim
#================================================================
header "Neovim"
NVIM_TAG=$(gh_latest neovim/neovim)
NVIM_CURRENT=$(nvim --version 2>/dev/null | head -1 | grep -oP 'v[\d.]+' || echo none)

if [ "$NVIM_CURRENT" = "$NVIM_TAG" ]; then
    info "Neovim $NVIM_TAG already installed."
else
    info "Installing Neovim $NVIM_TAG..."
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    curl -fSL "$NVIM_URL" -o /tmp/nvim.tar.gz
    tar -xzf /tmp/nvim.tar.gz -C /tmp/
    rm -rf "$OPT/nvim"
    mv /tmp/nvim-linux-x86_64 "$OPT/nvim"
    ln -sf "$OPT/nvim/bin/nvim" "$BIN/nvim"
    rm /tmp/nvim.tar.gz
    info "Neovim $NVIM_TAG installed → $BIN/nvim"
fi

#================================================================
# 2. ripgrep (rg) — fast grep, used by Telescope
#================================================================
header "ripgrep"
RG_TAG=$(gh_latest BurntSushi/ripgrep)
RG_VER="${RG_TAG#v}"

if command -v rg >/dev/null 2>&1 && rg --version | grep -qF "$RG_VER"; then
    info "ripgrep $RG_TAG already installed."
else
    info "Installing ripgrep $RG_TAG..."
    RG_URL="https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-${RG_VER}-x86_64-unknown-linux-musl.tar.gz"
    curl -fSL "$RG_URL" -o /tmp/rg.tar.gz
    tar -xzf /tmp/rg.tar.gz -C /tmp/
    cp /tmp/ripgrep-${RG_VER}-x86_64-unknown-linux-musl/rg "$BIN/rg"
    chmod +x "$BIN/rg"
    rm -rf /tmp/rg.tar.gz /tmp/ripgrep-*/
    info "ripgrep installed → $BIN/rg"
fi

#================================================================
# 3. fd — fast find, used by Telescope
#================================================================
header "fd"
FD_TAG=$(gh_latest sharkdp/fd)
FD_VER="${FD_TAG#v}"

if command -v fd >/dev/null 2>&1 && fd --version | grep -qF "$FD_VER"; then
    info "fd $FD_TAG already installed."
else
    info "Installing fd $FD_TAG..."
    FD_URL="https://github.com/sharkdp/fd/releases/latest/download/fd-${FD_TAG}-x86_64-unknown-linux-musl.tar.gz"
    curl -fSL "$FD_URL" -o /tmp/fd.tar.gz
    tar -xzf /tmp/fd.tar.gz -C /tmp/
    cp /tmp/fd-${FD_TAG}-x86_64-unknown-linux-musl/fd "$BIN/fd"
    chmod +x "$BIN/fd"
    rm -rf /tmp/fd.tar.gz /tmp/fd-*/
    info "fd installed → $BIN/fd"
fi

#================================================================
# 4. fzf — fuzzy finder
#================================================================
header "fzf"
FZF_TAG=$(gh_latest junegunn/fzf)
FZF_VER="${FZF_TAG#v}"

if command -v fzf >/dev/null 2>&1 && fzf --version | grep -qF "$FZF_VER"; then
    info "fzf $FZF_TAG already installed."
else
    info "Installing fzf $FZF_TAG..."
    FZF_URL="https://github.com/junegunn/fzf/releases/latest/download/fzf-${FZF_VER}-linux_amd64.tar.gz"
    curl -fSL "$FZF_URL" -o /tmp/fzf.tar.gz
    tar -xzf /tmp/fzf.tar.gz -C "$BIN/"
    chmod +x "$BIN/fzf"
    rm /tmp/fzf.tar.gz
    info "fzf installed → $BIN/fzf"
fi

#================================================================
# 5. universal-ctags — for Tagbar (<F8>)
#================================================================
header "universal-ctags"
if command -v ctags >/dev/null 2>&1 && ctags --version 2>/dev/null | grep -qi universal; then
    info "universal-ctags already installed."
elif [ -x "$BIN/universal_ctags" ]; then
    info "universal-ctags already at $BIN/universal_ctags"
else
    CTAGS_TAG=$(gh_latest universal-ctags/ctags)
    info "Installing universal-ctags $CTAGS_TAG..."
    CTAGS_URL="https://github.com/universal-ctags/ctags-nightly-build/releases/latest/download/uctags-$(date +%Y%m%d)-linux-x86_64.tar.gz"
    # Try nightly build (pre-compiled)
    if curl -fsSL "$CTAGS_URL" -o /tmp/ctags.tar.gz 2>/dev/null; then
        tar -xzf /tmp/ctags.tar.gz -C /tmp/
        CTAGS_BIN=$(find /tmp/uctags-* -name ctags -type f 2>/dev/null | head -1)
        if [ -n "$CTAGS_BIN" ]; then
            cp "$CTAGS_BIN" "$BIN/universal_ctags"
            ln -sf "$BIN/universal_ctags" "$BIN/ctags"
            chmod +x "$BIN/universal_ctags"
            rm -rf /tmp/ctags.tar.gz /tmp/uctags-*/
            info "universal-ctags installed → $BIN/universal_ctags"
        fi
    else
        warn "ctags pre-built binary unavailable. Build from source or install via package manager."
    fi
fi

#================================================================
# 6. stylua — Lua formatter (for conform.nvim)
#================================================================
header "stylua"
STYLUA_TAG=$(gh_latest JohnnyMorganz/StyLua)
STYLUA_VER="${STYLUA_TAG#v}"

if command -v stylua >/dev/null 2>&1 && stylua --version | grep -qF "$STYLUA_VER"; then
    info "stylua $STYLUA_TAG already installed."
else
    info "Installing stylua $STYLUA_TAG..."
    STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip"
    curl -fSL "$STYLUA_URL" -o /tmp/stylua.zip
    unzip -o /tmp/stylua.zip -d "$BIN/" stylua
    chmod +x "$BIN/stylua"
    rm /tmp/stylua.zip
    info "stylua installed → $BIN/stylua"
fi

#================================================================
# 7. bat — syntax-highlighted cat
#================================================================
header "bat"
BAT_TAG=$(gh_latest sharkdp/bat)
BAT_VER="${BAT_TAG#v}"

if command -v bat >/dev/null 2>&1 && bat --version | grep -qF "$BAT_VER"; then
    info "bat $BAT_TAG already installed."
else
    info "Installing bat $BAT_TAG..."
    BAT_URL="https://github.com/sharkdp/bat/releases/latest/download/bat-${BAT_TAG}-x86_64-unknown-linux-musl.tar.gz"
    curl -fSL "$BAT_URL" -o /tmp/bat.tar.gz
    tar -xzf /tmp/bat.tar.gz -C /tmp/
    cp "/tmp/bat-${BAT_TAG}-x86_64-unknown-linux-musl/bat" "$BIN/bat"
    chmod +x "$BIN/bat"
    rm -rf /tmp/bat.tar.gz "/tmp/bat-${BAT_TAG}-x86_64-unknown-linux-musl/"
    info "bat installed → $BIN/bat"
fi

#================================================================
# 8. zoxide — frecency-based smart cd
#================================================================
header "zoxide"
ZO_TAG=$(gh_latest ajeetdsouza/zoxide)
ZO_VER="${ZO_TAG#v}"

if command -v zoxide >/dev/null 2>&1 && zoxide --version | grep -qF "$ZO_VER"; then
    info "zoxide $ZO_TAG already installed."
else
    info "Installing zoxide $ZO_TAG..."
    ZO_URL="https://github.com/ajeetdsoutu/zoxide/releases/latest/download/zoxide-${ZO_VER}-x86_64-unknown-linux-musl.tar.gz"
    curl -fSL "$ZO_URL" -o /tmp/zoxide.tar.gz
    tar -xzf /tmp/zoxide.tar.gz -C /tmp/
    cp /tmp/zoxide "$BIN/zoxide"
    chmod +x "$BIN/zoxide"
    rm -rf /tmp/zoxide.tar.gz /tmp/zoxide
    info "zoxide installed → $BIN/zoxide"
fi

#================================================================
# 9. tealdeer (tldr) — simplified man pages
#================================================================
header "tldr (tealdeer)"
if command -v tldr >/dev/null 2>&1; then
    info "tldr already installed."
else
    info "Installing tealdeer (tldr)..."
    TLDR_URL="https://github.com/dbrgn/tealdeer/releases/latest/download/tealdeer-linux-x86_64-musl"
    curl -fSL "$TLDR_URL" -o "$BIN/tldr"
    chmod +x "$BIN/tldr"
    # Pre-fetch cache
    "$BIN/tldr" --update 2>/dev/null || true
    info "tldr installed → $BIN/tldr"
fi

#================================================================
# 10. cheat — community cheatsheets
#================================================================
header "cheat"
if command -v cheat >/dev/null 2>&1; then
    info "cheat already installed."
else
    info "Installing cheat..."
    CHEAT_URL="https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz"
    curl -fSL "$CHEAT_URL" -o /tmp/cheat.gz
    gunzip /tmp/cheat.gz
    mv /tmp/cheat "$BIN/cheat"
    chmod +x "$BIN/cheat"
    info "cheat installed → $BIN/cheat"
fi

#================================================================
# 11. Python tools — black, ruff, cpplint
#================================================================
header "Python tools (black / ruff / cpplint)"
if command -v pip3 >/dev/null 2>&1 || command -v pip >/dev/null 2>&1; then
    PIP=$(command -v pip3 || command -v pip)
    info "Using $PIP"
    "$PIP" install --user --quiet --upgrade black ruff cpplint
    info "black / ruff / cpplint installed (pip --user)"
else
    warn "pip3/pip not found — skipping Python tools. Install Python 3 first."
fi

#================================================================
# 12. bash-preexec (preexec/precmd hooks for bash)
#================================================================
header "bash-preexec"
PREEXEC_DIR="$HOME/.local/share/bash-preexec"
PREEXEC_FILE="$PREEXEC_DIR/bash-preexec.sh"
if [ -f "$PREEXEC_FILE" ]; then
    info "bash-preexec already installed."
else
    info "Installing bash-preexec..."
    mkdir -p "$PREEXEC_DIR"
    curl -fsSL https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh \
        -o "$PREEXEC_FILE"
    info "bash-preexec installed → $PREEXEC_FILE"
fi

#================================================================
# 13. zsh plugins — autosuggestions + syntax-highlighting
#================================================================
header "zsh plugins"
ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"
mkdir -p "$ZSH_PLUGINS"

if [ -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
    info "zsh-autosuggestions already installed."
else
    info "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_PLUGINS/zsh-autosuggestions"
    info "zsh-autosuggestions installed."
fi

if [ -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
    info "zsh-syntax-highlighting already installed."
else
    info "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_PLUGINS/zsh-syntax-highlighting"
    info "zsh-syntax-highlighting installed."
fi

#================================================================
# 14. fastfetch — system info on terminal open
#================================================================
header "fastfetch"
FF_TAG=$(gh_latest fastfetch-cli/fastfetch)
FF_VER="${FF_TAG#v}"

if command -v fastfetch >/dev/null 2>&1 && fastfetch --version 2>/dev/null | grep -qF "$FF_VER"; then
    info "fastfetch $FF_TAG already installed."
else
    info "Installing fastfetch $FF_TAG..."
    FF_URL="https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz"
    if curl -fSL "$FF_URL" -o /tmp/fastfetch.tar.gz 2>/dev/null; then
        tar -xzf /tmp/fastfetch.tar.gz -C /tmp/
        cp /tmp/fastfetch-linux-amd64/usr/bin/fastfetch "$BIN/fastfetch" 2>/dev/null || \
        find /tmp/fastfetch-* -name fastfetch -type f -exec cp {} "$BIN/fastfetch" \;
        chmod +x "$BIN/fastfetch"
        rm -rf /tmp/fastfetch.tar.gz /tmp/fastfetch-*/
        info "fastfetch installed → $BIN/fastfetch"
    else
        warn "fastfetch download failed — install neofetch via package manager as fallback"
    fi
fi

#================================================================
# 15. vim-plug (for legacy Vim config)
#================================================================
header "vim-plug"
PLUG="$HOME/.vim/autoload/plug.vim"
if [ -f "$PLUG" ]; then
    info "vim-plug already installed."
else
    mkdir -p "$(dirname "$PLUG")"
    curl -fsSL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o "$PLUG"
    info "vim-plug installed → $PLUG"
fi

#================================================================
# 16. nvim-update helper script
#================================================================
header "nvim-update script"
cat > "$BIN/nvim-update" << 'NVIMUPDATE'
#!/usr/bin/env bash
set -e
LATEST=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
CURRENT=$(nvim --version 2>/dev/null | head -1 | grep -oP 'v[\d.]+' || echo none)
echo "Installed: $CURRENT   Latest: $LATEST"
[ "$CURRENT" = "$LATEST" ] && echo "Already up to date." && exit 0
echo "Updating to $LATEST..."
curl -fSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz
tar -xzf /tmp/nvim.tar.gz -C /tmp/
rm -rf "$HOME/.local/opt/nvim"
mv /tmp/nvim-linux-x86_64 "$HOME/.local/opt/nvim"
ln -sf "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
rm /tmp/nvim.tar.gz
echo "Done: $(nvim --version | head -1)"
NVIMUPDATE
chmod +x "$BIN/nvim-update"
info "nvim-update script → $BIN/nvim-update"

#================================================================
# 17. Register nvim/vim as system default editor
#================================================================
header "System default editor"

_EDITOR_BIN=""
if [ -x "$BIN/nvim" ]; then
    _EDITOR_BIN="$BIN/nvim"
elif command -v nvim >/dev/null 2>&1; then
    _EDITOR_BIN="$(command -v nvim)"
elif command -v vim >/dev/null 2>&1; then
    _EDITOR_BIN="$(command -v vim)"
fi

if [ -z "$_EDITOR_BIN" ]; then
    warn "No nvim/vim found — skipping system editor registration."
else
    _EDITOR_NAME="$(basename "$_EDITOR_BIN")"
    info "Registering $_EDITOR_BIN as system default editor..."

    # Set git global editor (no sudo needed)
    git config --global core.editor "$_EDITOR_BIN" 2>/dev/null && \
        info "git config: core.editor = $_EDITOR_BIN"

    # Debian/Ubuntu: update-alternatives
    if command -v update-alternatives >/dev/null 2>&1; then
        if sudo -n true 2>/dev/null; then
            sudo update-alternatives --install /usr/bin/editor editor "$_EDITOR_BIN" 100
            sudo update-alternatives --set editor "$_EDITOR_BIN"
            info "update-alternatives: editor → $_EDITOR_BIN"
        else
            warn "sudo needed for update-alternatives — run manually:"
            warn "  sudo update-alternatives --install /usr/bin/editor editor $_EDITOR_BIN 100"
            warn "  sudo update-alternatives --set editor $_EDITOR_BIN"
        fi

    # RHEL/CentOS: alternatives
    elif command -v alternatives >/dev/null 2>&1; then
        if sudo -n true 2>/dev/null; then
            sudo alternatives --install /usr/bin/editor editor "$_EDITOR_BIN" 100
            sudo alternatives --set editor "$_EDITOR_BIN"
            info "alternatives: editor → $_EDITOR_BIN"
        else
            warn "sudo needed for alternatives — run manually:"
            warn "  sudo alternatives --install /usr/bin/editor editor $_EDITOR_BIN 100"
            warn "  sudo alternatives --set editor $_EDITOR_BIN"
        fi

    else
        # Fallback: symlink into ~/.local/bin so 'editor' resolves to nvim/vim
        ln -sf "$_EDITOR_BIN" "$BIN/editor"
        info "No alternatives system found — symlinked: $BIN/editor → $_EDITOR_BIN"
    fi

    unset _EDITOR_BIN _EDITOR_NAME
fi

#================================================================
# 18. Wire env.sh into shell rc file(s)
#================================================================
header "Shell configuration"

ENV_SH="$SCRIPT_DIR/env.sh"
MARKER="# dev-env (added by ENV/install.sh)"

_wire_shell() {
    local rc="$1" shell_name="$2"
    if [ ! -f "$rc" ]; then
        warn "$rc not found — skipping $shell_name"
        return
    fi
    if grep -qF "$MARKER" "$rc" 2>/dev/null; then
        info "env.sh already sourced in $rc"
    else
        cat >> "$rc" << ENVBLOCK

$MARKER
[ -f "$ENV_SH" ] && source "$ENV_SH"
ENVBLOCK
        info "Appended 'source $ENV_SH' to $rc"
    fi
}

# Determine which shells to configure
if [ -n "${SHELL_TARGET:-}" ]; then
    TARGET="$SHELL_TARGET"
else
    echo ""
    echo "Which shell(s) should use this config?"
    echo "  1) bash"
    echo "  2) zsh  (plain)"
    echo "  3) zsh  + Oh My Zsh"
    echo "  4) both (bash + zsh plain)"
    echo "  5) both (bash + zsh + Oh My Zsh)"
    printf "Choice [1-5] (default: 1): "
    read -r _choice
    case "${_choice:-1}" in
        2) TARGET="zsh"      ;;
        3) TARGET="zsh-omz"  ;;
        4) TARGET="both"     ;;
        5) TARGET="both-omz" ;;
        *) TARGET="bash"     ;;
    esac
fi

# Install Oh My Zsh if requested
_install_omz() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info "Oh My Zsh already installed."
    else
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended --keep-zshrc
        info "Oh My Zsh installed."
    fi

    # Clone zsh-users plugins into OMZ custom plugins dir
    OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    for plugin_repo in \
        "zsh-users/zsh-autosuggestions" \
        "zsh-users/zsh-syntax-highlighting"
    do
        plugin_name="${plugin_repo##*/}"
        plugin_dir="$OMZ_CUSTOM/plugins/$plugin_name"
        if [ -d "$plugin_dir" ]; then
            info "$plugin_name already in OMZ custom plugins."
        else
            info "Cloning $plugin_name into OMZ custom plugins..."
            git clone --depth=1 "https://github.com/$plugin_repo" "$plugin_dir"
        fi
    done
}

# Write zsh rc with OMZ block
_wire_zsh_omz() {
    local rc="$HOME/.zshrc"
    local MARKER_OMZ="# dev-env OMZ (added by ENV/install.sh)"
    local MARKER_ENV="# dev-env (added by ENV/install.sh)"
    local OMZ_CONFIG="$SCRIPT_DIR/zsh/omz-config.zsh"

    if grep -qF "$MARKER_OMZ" "$rc" 2>/dev/null; then
        info "OMZ + env.sh already wired in ~/.zshrc"
        return
    fi

    # Back up existing .zshrc if it has content
    if [ -s "$rc" ]; then
        TIMESTAMP=$(date "+%Y_%m_%d__%H_%M_%S" )
        cp "$rc" "${rc}.bak.$TIMESTAMP"
        warn "Backed up existing ~/.zshrc to ${rc}.bak.$TIMESTAMP"
    fi

    cat >> "$rc" << ZSHOMZ

$MARKER_OMZ
# 1. Our OMZ settings (theme, plugins) — must come before OMZ loads
[ -f "$OMZ_CONFIG" ] && source "$OMZ_CONFIG"

# 2. Oh My Zsh
export ZSH="\$HOME/.oh-my-zsh"
[ -f "\$ZSH/oh-my-zsh.sh" ] && source "\$ZSH/oh-my-zsh.sh"

# 3. Our customizations on top of OMZ
$MARKER_ENV
[ -f "$ENV_SH" ] && source "$ENV_SH"
ZSHOMZ
    info "Wired OMZ + env.sh into ~/.zshrc"
}

case "$TARGET" in
    bash)
        _wire_shell "$HOME/.bashrc" "bash"
        ;;
    zsh)
        _wire_shell "$HOME/.zshrc" "zsh"
        ;;
    zsh-omz)
        _install_omz
        _wire_zsh_omz
        ;;
    both)
        _wire_shell "$HOME/.bashrc" "bash"
        _wire_shell "$HOME/.zshrc"  "zsh"
        ;;
    both-omz)
        _wire_shell "$HOME/.bashrc" "bash"
        _install_omz
        _wire_zsh_omz
        ;;
esac

#================================================================
# Summary
#================================================================
echo ""
echo -e "${BOLD}Installed tools:${NC}"
for cmd in nvim rg fd fzf bat zoxide tldr cheat fastfetch ctags stylua black ruff cpplint nvim-update; do
    if command -v "$cmd" >/dev/null 2>&1 || [ -x "$BIN/$cmd" ]; then
        VER=$(PATH="$BIN:$PATH" "$cmd" --version 2>/dev/null | head -1 || echo "ok")
        printf "  %-14s %s\n" "$cmd" "$VER"
    else
        printf "  %-14s %s\n" "$cmd" "(not installed)"
    fi
done

echo ""
case "$TARGET" in
    bash) echo "Run: source ~/.bashrc" ;;
    zsh)  echo "Run: source ~/.zshrc"  ;;
    both) echo "Run: source ~/.bashrc   or   source ~/.zshrc" ;;
esac
echo "     nvim-update          (update Neovim anytime)"
echo "     tldr --update        (fetch tldr page cache)"
