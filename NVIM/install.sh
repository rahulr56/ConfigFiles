#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
abort() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

#================================================================
# Check required tools
#================================================================

info "Checking prerequisites..."

command -v git  >/dev/null 2>&1 || abort "git not found. Install git first."
command -v make >/dev/null 2>&1 || abort "make not found. Install make/build-essential first."

# Check for C compiler (needed for telescope-fzf-native, LuaSnip)
if ! command -v gcc >/dev/null 2>&1 && ! command -v cc >/dev/null 2>&1; then
    abort "No C compiler found (gcc/cc). Install gcc or build-essential first."
fi

# Check Neovim version
if ! command -v nvim >/dev/null 2>&1; then
    abort "nvim not found. Install Neovim >= 0.9 first."
fi
NVIM_VERSION=$(nvim --version | head -1 | grep -oP '\d+\.\d+' | head -1)
NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
if [ "$NVIM_MAJOR" -lt 1 ] && [ "$NVIM_MINOR" -lt 9 ]; then
    abort "Neovim >= 0.9 required. Found: $NVIM_VERSION"
fi
info "Neovim $NVIM_VERSION found."

# Warn about optional tools
for tool in rg ag ctags curl; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        case "$tool" in
            rg)    warn "ripgrep (rg) not found — Telescope find_files will be slower." ;;
            ag)    warn "silver searcher (ag) not found — ack.vim grep fallback active." ;;
            ctags) warn "ctags not found — Tagbar (<F8>) won't work." ;;
            curl)  warn "curl not found — vim-plug bootstrap may fail." ;;
        esac
    fi
done

#================================================================
# Install Neovim config
#================================================================

info "Installing Neovim config..."

NVIM_CONFIG="$HOME/.config/nvim"

if [ -d "$NVIM_CONFIG" ]; then
    BACKUP="$NVIM_CONFIG.bak.$TIMESTAMP"
    warn "Existing Neovim config found. Backing up to $BACKUP"
    mv "$NVIM_CONFIG" "$BACKUP"
fi

mkdir -p "$NVIM_CONFIG"
cp -r "$SCRIPT_DIR/nvim/"* "$NVIM_CONFIG/"
info "Neovim config installed to $NVIM_CONFIG"

#================================================================
# Install Vim config
#================================================================

info "Installing Vim config..."

if [ -f "$HOME/.vimrc" ]; then
    warn "Existing ~/.vimrc found. Backing up to ~/.vimrc.bak.$TIMESTAMP"
    cp "$HOME/.vimrc" "$HOME/.vimrc.bak.$TIMESTAMP"
fi

if [ -d "$HOME/.vim_runtime" ]; then
    warn "Existing ~/.vim_runtime found. Backing up to ~/.vim_runtime.bak.$TIMESTAMP"
    mv "$HOME/.vim_runtime" "$HOME/.vim_runtime.bak.$TIMESTAMP"
fi

cp "$SCRIPT_DIR/vim/vimrc" "$HOME/.vimrc"
cp -r "$SCRIPT_DIR/vim/vim_runtime" "$HOME/.vim_runtime"
info "Vim config installed."

#================================================================
# Create required directories
#================================================================

info "Creating required directories..."

for dir in \
    "$HOME/.vim/dirs/backups" \
    "$HOME/.vim/dirs/tmp" \
    "$HOME/.vim/dirs/undos" \
    "$HOME/.vim/templates" \
    "$HOME/.vim/plugged" \
    "$HOME/.undodir" \
    "$HOME/.vim_runtime/temp_dirs/undodir" \
    "$HOME/.local/share/fzf-history"
do
    mkdir -p "$dir"
done

info "Directories created."

#================================================================
# Install vim-plug
#================================================================

if command -v curl >/dev/null 2>&1; then
    info "Installing vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    info "vim-plug installed."
else
    warn "curl not found — skipping vim-plug install. Install manually:"
    warn "  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \\"
    warn "    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

#================================================================
# Done
#================================================================

echo ""
info "Installation complete!"
echo ""
echo "Next steps:"
echo ""
echo "  NEOVIM:"
echo "    1. Open nvim  — lazy.nvim bootstraps automatically"
echo "    2. Run :Lazy sync  — installs all plugins (versions pinned by lazy-lock.json)"
echo "    3. Run :MasonToolsInstall  — installs LSP servers (pyright, clangd, lua_ls, stylua, black, ruff, cpplint)"
echo "    4. Run :checkhealth  — verify no critical errors"
echo ""
echo "  VIM:"
echo "    1. Open vim"
echo "    2. Run :PlugInstall  — installs all vim-plug plugins"
echo ""
echo "  OPTIONAL:"
echo "    - Add Python/C++ skeleton templates to ~/.vim/templates/"
echo "      (python_skeleton.txt, cpp_skeleton.cpp)"
echo "    - Install a Nerd Font for icons (e.g. FiraCode Nerd Font)"
echo "    - Install universal-ctags to ~/.local/bin/universal_ctags for Tagbar"
