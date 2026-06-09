# NVIM — Portable Neovim + Vim Config

Portable editor config for both Neovim and legacy Vim.
Copy to any Linux machine, run `install.sh`, open editor.

---

## Structure

```
NVIM/
├── install.sh                    # Copies configs + creates required dirs
├── nvim/                         # Neovim config  → ~/.config/nvim/
│   ├── init.lua                  # Entry point — bootstraps lazy.nvim, loads all modules
│   ├── lazy-lock.json            # Pinned plugin versions (reproducible install)
│   └── lua/
│       ├── core/
│       │   ├── options.lua       # vim.opt settings (tabs, search, splits, backup, undo)
│       │   ├── keymaps.lua       # All keymaps (, leader)
│       │   ├── autocmds.lua      # Autocommands (python, diff, yank highlight, LSP echo)
│       │   ├── functions.lua     # Global helper functions (HasPaste, Bclose, etc.)
│       │   ├── tab-helpers.lua   # :TabsToSpaces :SpacesToTabs :SetTabWidth commands
│       │   └── custom-paths.lua  # Ensures XDG data dirs exist (no custom path needed)
│       ├── config/
│       │   ├── lsp.lua           # LSP servers, Mason, diagnostics, keymaps on attach
│       │   └── telescope.lua     # Telescope layout, pickers, all keymaps
│       ├── plugins/
│       │   └── init.lua          # All lazy.nvim plugin specs
│       └── custom/plugins/
│           └── init.lua          # Add your own plugins here (safe from upstream merges)
└── vim/                          # Legacy Vim config  → ~/.vimrc + ~/.vim_runtime/
    ├── vimrc                     # → ~/.vimrc (sources vim_runtime modules)
    └── vim_runtime/
        └── vimrcs/
            ├── basic.vim         # Core settings, keymaps, helper functions
            ├── extended.vim      # Persistent undo, command mode, tab navigation
            ├── filetypes.vim     # Python, C++ filetype configs and helpers
            ├── vundlesetup.vim   # vim-plug plugin list
            └── plugins_config.vim # Plugin settings (ALE, FZF, TagBar, Airline, etc.)
```

---

## Quick Start

### 1. Copy to new machine

```bash
scp -r ~/NVIM user@newmachine:~/NVIM
```

### 2. Run installer

```bash
bash ~/NVIM/install.sh
```

The installer:
- Backs up existing `~/.config/nvim` → `~/.config/nvim.bak.<timestamp>`
- Backs up existing `~/.vimrc` and `~/.vim_runtime/`
- Copies nvim config to `~/.config/nvim/`
- Copies vim config to `~/.vimrc` + `~/.vim_runtime/`
- Creates required dirs (`~/.vim/dirs/backups`, `tmp`, `undos`, `templates`)
- Installs vim-plug (if curl available)

### 3. First launch — Neovim

```
nvim
```

lazy.nvim bootstraps automatically on first open. Then:

```vim
:Lazy sync           " install all plugins (versions from lazy-lock.json)
:MasonToolsInstall   " install LSP servers and formatters
:checkhealth         " verify no critical errors
```

### 4. First launch — Vim

```
vim
:PlugInstall         " install all vim-plug plugins
```

---

## Prerequisites

| Tool | Required | Purpose |
|------|----------|---------|
| `nvim` >= 0.9 | Yes | Neovim itself |
| `git` | Yes | lazy.nvim bootstrap + plugin install |
| `make` | Yes | telescope-fzf-native, LuaSnip jsregexp |
| `gcc` / `cc` | Yes | native extension compilation |
| `rg` (ripgrep) | Recommended | Telescope find_files, live_grep |
| `ctags` | Optional | Tagbar (`<F8>`) |
| `ag` | Optional | ack.vim grep fallback |
| `curl` | Optional | vim-plug install |
| Nerd Font | Optional | Icons in airline, nvim-web-devicons |

---

## Neovim Plugins

### UI
| Plugin | Purpose |
|--------|---------|
| `tokyonight.nvim` | Color scheme (night style) |
| `vim-airline` + themes | Status line + tab bar |
| `nvim-notify` | Prettier notification popups |
| `indent-blankline.nvim` | Vertical indent guides |
| `nvim-treesitter-context` | Current function shown at top |
| `todo-comments.nvim` | Highlight TODO/FIXME/NOTE |

### Navigation
| Plugin | Purpose |
|--------|---------|
| `telescope.nvim` | Fuzzy finder (files, buffers, grep, LSP) |
| `telescope-fzf-native.nvim` | Native fzf sorter for telescope |
| `flash.nvim` | Jump anywhere with 2-3 keystrokes (`s`) |
| `smart-splits.nvim` | Window navigation + resize (tmux-aware) |
| `nvim-window-picker` | Pick window by letter (`-`) |
| `nvim-bqf` | Better quickfix window with preview |
| `yegappan/mru` | Most recently used files (`,k`) |
| `tagbar` | Code outline sidebar (`<F8>`) |

### LSP / Completion
| Plugin | Purpose |
|--------|---------|
| `nvim-lspconfig` | LSP client config |
| `mason.nvim` | LSP server installer |
| `mason-lspconfig.nvim` | Bridge Mason ↔ lspconfig |
| `mason-tool-installer.nvim` | Auto-install formatters/linters |
| `nvim-cmp` | Completion engine |
| `LuaSnip` | Snippet engine |
| `conform.nvim` | Autoformat on save |
| `fidget.nvim` | LSP progress indicator |

### LSP Servers (auto-installed via Mason)
| Server | Language |
|--------|---------|
| `pyright` | Python |
| `clangd` | C / C++ |
| `lua_ls` | Lua |
| `stylua` | Lua formatter |
| `black` | Python formatter |
| `ruff` | Python linter |
| `cpplint` | C++ linter |

### Editing
| Plugin | Purpose |
|--------|---------|
| `nvim-autopairs` | Auto-close brackets/quotes |
| `Comment.nvim` | `gcc` / `gc` to comment |
| `vim-surround` | `ys`, `cs`, `ds` surround operations |
| `vim-visual-multi` | Multiple cursors |
| `nvim-treesitter` | Syntax highlighting, indentation |
| `which-key.nvim` | Keymap hints popup |
| `nvim-autopairs` | Auto-close brackets |
| `vim-sleuth` | Auto-detect tab/indent settings |

### Integrations
| Plugin | Purpose |
|--------|---------|
| `vim-vp4` | Perforce integration |
| `ack.vim` | Grep with ack/ag (`,r` `,wr`) |
| `mileszs/ack.vim` | Search in files |

---

## Neovim Keymaps

**Leader key: `,` (comma)**

### Files & Search
| Key | Action |
|-----|--------|
| `,f` | Find files (Telescope) |
| `,F` | Find all files including hidden |
| `,b` | Find open buffers |
| `,sg` | Live grep |
| `,sw` | Grep word under cursor |
| `,L` | Search lines in current buffer |
| `,m` | Recent files (MRU) |
| `,k` | MRU list |
| `,r` | Ack search |
| `,wr` | Ack word under cursor |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `gD` | Go to declaration |
| `,D` | Definition in new tab |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>sd` | Search diagnostics |

### Navigation
| Key | Action |
|-----|--------|
| `<C-h>` | Move to left window |
| `<C-k>` | Move to window above |
| `<C-n>` | Move to window below |
| `<C-g>` | Move to right window |
| `<A-h/j/k/g>` | Resize windows |
| `-` | Pick window by letter |
| `s` | Flash jump |
| `S` | Flash treesitter jump |

### Tabs & Buffers
| Key | Action |
|-----|--------|
| `tn` / `tp` | Next / previous tab |
| `ts` | Split into new tab |
| `<leader>tn` | New tab |
| `<leader>l` / `<leader>h` | Next / previous buffer |
| `<leader>bd` | Close buffer |

### Editing
| Key | Action |
|-----|--------|
| `<leader>w` | Fast save |
| `<leader>F` | Format buffer |
| `<leader>pp` | Toggle paste mode |
| `<F8>` | Toggle Tagbar |
| `<F10>` | Set paste mode |
| `<F11>` | Unset paste mode |
| `<C-L><C-L>` | Toggle relative line numbers |
| `<leader>n` | Toggle line numbers |
| `<leader>ts` | Tabs to spaces |
| `<leader>ti` | Show tab settings |

### Telescope Extra
| Key | Action |
|-----|--------|
| `,g` | Document symbols |
| `,G` | Workspace symbols |
| `,p` | Search in buffer |
| `,wf` | Search word in buffer |
| `,we` | Find files with word |
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>sr` | Resume last search |

---

## Vim Plugins (vim-plug)

| Plugin | Purpose |
|--------|---------|
| `vim-airline` + themes | Status line |
| `ctrlp.vim` | File/buffer finder (`Ctrl-F`) |
| `fzf` + `fzf.vim` | Fuzzy finder (`,f` `,b` `,;`) |
| `dense-analysis/ale` | Async linting (ruff, cpplint) + fixing (black) |
| `tagbar` | Code outline (`<F8>`) |
| `vim-vp4` | Perforce integration |
| `ack.vim` | File search (`,r` `,wr`) |
| `mru` | Most recently used files |
| `vim-autoclose` | Auto-close brackets |
| `vim-choosewin` | Pick window (`-`) |
| `vim-rainbow` | Rainbow bracket colors |
| `vim-polyglot` | Language packs |
| `tpope/vim-fugitive` | Git integration |
| `tabman.vim` | Tab management |
| `ctrlpvim/ctrlp.vim` | CtrlP file finder |

---

## Key Differences from Original Config

| Change | Reason |
|--------|--------|
| Copilot removed | Plugin excluded (requires auth per machine) |
| `claude-code.nvim` removed | Depends on AMD-internal genie binary |
| `custom-paths.lua` simplified | Removed `/proj/...` hardcoded path; uses XDG defaults |
| vim-plug path changed | `~/.vim/plugged` instead of `/proj/...` |
| `lazy-lock.json` included | Pins exact plugin versions for reproducibility |

---

## Adding Your Own Plugins

Add to `nvim/lua/custom/plugins/init.lua` — this file is never overwritten by updates:

```lua
return {
  {
    "author/plugin-name",
    config = function()
      require("plugin-name").setup({})
    end,
  },
}
```

---

## Updating

```bash
# Update all nvim plugins to latest
nvim -c ":Lazy update" -c "q"

# Re-pin versions after updating
nvim -c ":Lazy lock" -c "q"

# Update vim plugins
vim -c ":PlugUpdate" -c "q"
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Mason fails to install tools | `pip3 install black ruff cpplint` directly; comment out from `lsp.lua` ensure_installed |
| `nvim-notify` error on startup | Already disabled; re-check `plugins/init.lua` |
| Treesitter missing parsers | `:TSUpdate` inside nvim |
| Telescope fzf sorter missing | Run `make` in `~/.local/share/nvim/lazy/telescope-fzf-native.nvim/` |
| Tagbar shows no symbols | Install `ctags`: `~/.local/bin/universal_ctags` |
| No icons showing | Install a Nerd Font and set terminal to use it |
