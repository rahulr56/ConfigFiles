-- Keymaps Configuration
-- Migrated from .vimrc
-- Based on original vimrc keymappings

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--================================================================
-- Leader key is set in init.lua (comma)
--================================================================

--================================================================
-- General Keymaps
--================================================================

-- Fast saving
keymap("n", "<leader>w", ":w!<CR>", opts)

-- Clear search highlighting
keymap("n", "<leader><CR>", ":noh<CR>", { silent = true })

-- Remap 0 to first non-blank character
keymap("n", "0", "^", opts)

--================================================================
-- Window Navigation
--================================================================

-- Window navigation is now handled by smart-splits plugin
-- Ctrl+h/j/k/g - Navigate windows (Ctrl+g for right to preserve Ctrl+l for clear screen)
-- Alt+h/j/k/g - Resize windows
-- See plugins/init.lua for configuration

--================================================================
-- Buffer Management
--================================================================

-- Close current buffer
keymap("n", "<leader>bd", ":Bclose<CR>:tabclose<CR>gT", opts)

-- Close all buffers
keymap("n", "<leader>ba", ":bufdo bd<CR>", opts)

-- Next and previous buffer
keymap("n", "<leader>l", ":bnext<CR>", opts)
keymap("n", "<leader>h", ":bprevious<CR>", opts)

--================================================================
-- Tab Management
--================================================================

-- Create new tab
keymap("n", "<leader>tn", ":tabnew<CR>", opts)

-- Close all other tabs
keymap("n", "<leader>to", ":tabonly<CR>", opts)

-- Move tab
keymap("n", "<leader>tm", ":tabmove ", { noremap = true })

-- Next tab
keymap("n", "<leader>t<leader>", ":tabnext ", { noremap = true })

-- Open new tab with current buffer's path
keymap("n", "<leader>te", ':tabedit <C-r>=expand("%:p:h")<CR>/', { noremap = true })

-- Tab navigation
keymap("n", "tn", ":tabn<CR>", opts)
keymap("n", "tp", ":tabp<CR>", opts)
keymap("n", "ts", ":tab split<CR>", opts)
keymap("n", "<C-S-Right>", ":tabn<CR>", opts)
keymap("i", "<C-S-Right>", "<ESC>:tabn<CR>", opts)
keymap("n", "<C-S-Left>", ":tabp<CR>", opts)
keymap("i", "<C-S-Left>", "<ESC>:tabp<CR>", opts)

--================================================================
-- Navigation with Meta keys
--================================================================

keymap("i", "<M-Right>", "<ESC><C-w>l", opts)
keymap("i", "<M-Left>", "<ESC><C-w>h", opts)
keymap("i", "<M-Up>", "<ESC><C-w>k", opts)
keymap("i", "<M-Down>", "<ESC><C-w>j", opts)

--================================================================
-- Change Directory
--================================================================

-- Switch CWD to the directory of the open buffer
keymap("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", opts)

--================================================================
-- Visual Mode
--================================================================

-- Search for current selection with * and #
keymap("v", "*", ':<C-u>call VisualSelection("", "")<CR>/<C-R>=@/<CR><CR>', { silent = true })
keymap("v", "#", ':<C-u>call VisualSelection("", "")<CR>?<C-R>=@/<CR><CR>', { silent = true })

-- Surround selections with brackets/quotes
keymap("v", "$1", "<esc>`>a)<esc>`<i(<esc>", opts)
keymap("v", "$2", "<esc>`>a]<esc>`<i[<esc>", opts)
keymap("v", "$3", "<esc>`>a}<esc>`<i{<esc>", opts)
keymap("v", "$$", '<esc>`>a"<esc>`<i"<esc>', opts)
keymap("v", "$q", "<esc>`>a'<esc>`<i'<esc>", opts)
keymap("v", "$e", '<esc>`>a"<esc>`<i"<esc>', opts)

--================================================================
-- Search Mappings
--================================================================

-- Map space to search
keymap("n", "<space>", "/", opts)
keymap("n", "<C-space>", "?", opts)

--================================================================
-- Spell Checking
--================================================================

-- Toggle spell checking
keymap("n", "<leader>ss", ":setlocal spell!<CR>", opts)

-- Spell navigation
keymap("n", "<leader>sn", "]s", opts)
keymap("n", "<leader>sp", "[s", opts)
keymap("n", "<leader>sa", "zg", opts)
keymap("n", "<leader>s?", "z=", opts)

--================================================================
-- Paste Mode Toggle
--================================================================

-- Toggle paste mode
keymap("n", "<leader>pp", ":setlocal paste!<CR>", opts)
keymap("n", "<F10>", ":set paste<CR>", opts)
keymap("n", "<F11>", ":set nopaste<CR>", opts)
keymap("i", "<F10>", "<C-O>:set paste<CR>", opts)

--================================================================
-- Quick Buffer Access
--================================================================

-- Quickly open a buffer for scribble
keymap("n", "<leader>q", ":e ~/buffer<CR>", opts)

-- Quickly open a markdown buffer for scribble
keymap("n", "<leader>x", ":e ~/buffer.md<CR>", opts)

--================================================================
-- Command Mode Mappings
--================================================================

-- Bash like keys for command line
vim.cmd([[
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
]])

--================================================================
-- Insert Mode Mappings
--================================================================

-- Move to end of line in insert mode
keymap("i", "<C-e>", "<C-o>$", opts)

-- Insert timestamp
keymap("i", "<F5>", '<C-R>=strftime("%c")<CR>', opts)

-- Backspace fix (from original config)
keymap("i", "<Char-0x07F>", "<BS>", opts)
keymap("n", "<Char-0x07F>", "<BS>", opts)

--================================================================
-- Relative Line Number Toggle
--================================================================

keymap("n", "<C-L><C-L>", ":set invrelativenumber<CR>", opts)

-- Toggle line numbers (useful for copying text without line numbers)
keymap("n", "<leader>n", ":set invnumber invrelativenumber<CR>", { desc = "Toggle line numbers" })

--================================================================
-- Misc
--================================================================

-- Remove Windows ^M line endings
keymap("n", "<Leader>m", 'mmHmt:%s/<C-V><CR>//ge<CR>\'tzt\'m', opts)

-- Exit terminal mode easily
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--================================================================
-- FZF/Telescope Keymaps (will be set in telescope config)
-- These are placeholders for reference from original vimrc
--================================================================

-- Fast file finding
keymap("n", "<leader>f", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>b", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>;", ":Telescope commands<CR>", opts)
keymap("n", "<leader>L", ":Telescope current_buffer_fuzzy_find<CR>", opts)

--================================================================
-- Note: Plugin-specific keymaps will be configured in their
-- respective plugin configuration files
--================================================================
