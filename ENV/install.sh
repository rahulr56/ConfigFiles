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
# 12. vim-plug (for legacy Vim config)
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
# 13. nvim-update helper script
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
# 14. Wire env.sh into ~/.bashrc
#================================================================
header "Hooking env.sh into ~/.bashrc"
BASHRC="$HOME/.bashrc"
ENV_SH="$SCRIPT_DIR/env.sh"
MARKER="# dev-env (added by ENV/install.sh)"

if grep -qF "$MARKER" "$BASHRC" 2>/dev/null; then
    info "env.sh already sourced in ~/.bashrc"
else
    cat >> "$BASHRC" << ENVBLOCK

$MARKER
[ -f "$ENV_SH" ] && source "$ENV_SH"
ENVBLOCK
    info "Appended 'source $ENV_SH' to ~/.bashrc"
fi

#================================================================
# Summary
#================================================================
echo ""
echo -e "${BOLD}Installed tools:${NC}"
for cmd in nvim rg fd fzf bat zoxide tldr cheat ctags stylua black ruff cpplint nvim-update; do
    if command -v "$cmd" >/dev/null 2>&1 || [ -x "$BIN/$cmd" ]; then
        VER=$(PATH="$BIN:$PATH" "$cmd" --version 2>/dev/null | head -1 || echo "ok")
        printf "  %-14s %s\n" "$cmd" "$VER"
    else
        printf "  %-14s %s\n" "$cmd" "(not installed)"
    fi
done

echo ""
echo "Run:  source ~/.bashrc      (activate env in current shell)"
echo "Then: nvim-update          (update Neovim anytime)"
echo "      tldr --update        (fetch tldr page cache)"
