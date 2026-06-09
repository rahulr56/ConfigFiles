--================================================================
-- Neovim Configuration - Modular Setup
-- Migrated from .vimrc to modern Lua-based Neovim configuration
--
-- This is an alternative to the kickstart.nvim config
-- To use this config, rename this file to init.lua or source it
--================================================================

-- Set leader keys BEFORE loading plugins
-- Using comma as leader to match original vimrc
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

--================================================================
-- Setup custom data directory paths
-- This must be loaded BEFORE lazy.nvim bootstrap
--================================================================

require("core.custom-paths")

--================================================================
-- Bootstrap lazy.nvim plugin manager
--================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--================================================================
-- Load core configuration
--================================================================

-- Load options (vim settings)
require("core.options")

-- Load keymaps
require("core.keymaps")

-- Load autocommands
require("core.autocmds")

-- Load helper functions
require("core.functions")

-- Load tab conversion helpers
require("core.tab-helpers")

--================================================================
-- Load and setup plugins
--================================================================

require("lazy").setup({
  -- Import all plugins from plugins/init.lua
  { import = "plugins" },
}, {
  -- Lazy.nvim configuration
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

--================================================================
-- Post-plugin configuration
--================================================================

-- Set colorscheme is handled in plugins/init.lua

-- Set last tab for tab switching
vim.g.lasttab = 1

-- Python mode settings
vim.g.pymode_python = "python3"

--================================================================
-- Status line configuration
-- (lualine is configured in plugins, this is fallback)
--================================================================

vim.opt.statusline = table.concat({
  " %{v:lua.HasPaste()}",
  "%F%m%r%h",
  " %w",
  "  CWD: %r%{getcwd()}%h",
  "    Line: %l",
  "  Column: %c",
})

-- Terminal mode navigation
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move left" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move down" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move up" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move right" })

-- vim: ts=2 sts=2 sw=2 et
