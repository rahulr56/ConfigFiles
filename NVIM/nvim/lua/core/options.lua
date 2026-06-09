-- Options Configuration
-- Migrated from .vimrc
-- Based on original vimrc settings from basic.vim and extended.vim

local opt = vim.opt

--================================================================
-- General Settings
--================================================================

-- History
opt.history = 500

-- File handling
opt.autoread = true  -- Auto read when file is changed from outside
opt.encoding = "utf-8"
opt.fileformats = "unix,dos,mac"

-- Wildmenu
opt.wildmenu = true
opt.wildignorecase = true
opt.wildignore = { "*.o", "*~", "*.pyc", "*/.git/*", "*/.hg/*", "*/.svn/*", "*/.DS_Store" }
opt.wildmode = "list:longest,full"

--================================================================
-- UI Settings
--================================================================

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.ruler = true

-- Command line
opt.cmdheight = 2
opt.laststatus = 2

-- Scrolling
opt.scrolloff = 3  -- Keep 3 lines visible when scrolling
opt.so = 7  -- Set 7 lines to the cursor when moving vertically

-- Visual
opt.showmode = true
opt.showcmd = true
opt.cursorline = true
opt.showmatch = true  -- Show matching brackets
opt.mat = 2  -- Blink time for matching brackets (tenths of a second)

-- Folding
opt.foldcolumn = "1"
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 5

-- Mouse and bells
opt.mouse = ""  -- Disable mouse to allow terminal text selection
opt.errorbells = false
opt.visualbell = false

-- Splits
opt.splitright = true
opt.splitbelow = true

-- No vi compatibility
opt.compatible = false

-- Hidden buffers
opt.hidden = true

-- Fast redraw
opt.lazyredraw = true
opt.ttyfast = true

--================================================================
-- Search Settings
--================================================================

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.magic = true
opt.gdefault = true

--================================================================
-- Indentation and Tabs
--================================================================

opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

opt.autoindent = true
opt.smartindent = true

-- Clipboard - use system clipboard
opt.clipboard = "unnamedplus"

-- Wrapping
opt.wrap = true
opt.linebreak = true
opt.textwidth = 500

--================================================================
-- Backspace behavior
--================================================================

opt.backspace = { "eol", "start", "indent" }
opt.whichwrap:append("<,>,h,l")

--================================================================
-- Backup, Undo, and Swap
--================================================================

-- Backup directories
opt.backup = true
opt.backupdir = vim.fn.expand("~/.vim/dirs/backups")

-- Swap files
opt.directory = vim.fn.expand("~/.vim/dirs/tmp")

-- Undo
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/dirs/undos")
opt.undolevels = 10000  -- More undo history

-- ShaDa (Neovim's replacement for viminfo) - use default location
-- Neovim handles this automatically via XDG_STATE_HOME

--================================================================
-- Completion
--================================================================

opt.completeopt = "menu,menuone,noinsert"

--================================================================
-- Performance
--================================================================

opt.updatetime = 250
opt.timeoutlen = 300

--================================================================
-- Diff
--================================================================

opt.diffopt:remove("internal")
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")  -- Better diff alignment
opt.diffopt:append("linematch:60")      -- Better word diff (Neovim 0.9+)

--================================================================
-- List characters
--================================================================

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

--================================================================
-- Color scheme settings
--================================================================

opt.background = "dark"
opt.termguicolors = true  -- True color support
vim.cmd("syntax enable")

--================================================================
-- Confirm before quit with unsaved changes
--================================================================

opt.confirm = true

--================================================================
-- Create necessary directories
--================================================================

local function ensure_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

ensure_dir(vim.fn.expand("~/.vim/dirs/backups"))
ensure_dir(vim.fn.expand("~/.vim/dirs/tmp"))
ensure_dir(vim.fn.expand("~/.vim/dirs/undos"))

-- Signcolumn
opt.signcolumn = "yes"

-- Preview substitutions
opt.inccommand = "split"

-- Additional quality of life improvements
opt.virtualedit = "block"  -- Allow cursor past end of line in visual block mode
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true  -- Smooth scrolling (Neovim 0.10+)
end
