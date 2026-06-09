-- Autocommands Configuration
-- Migrated from .vimrc

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-----------------------------------------------------------
-- Core diff options
-----------------------------------------------------------
-- Better diff algorithm & layout
vim.opt.diffopt = vim.opt.diffopt
  + {
    "filler",            -- keep lines aligned
    "internal",          -- use internal diff engine
    "indent-heuristic",  -- better diff around indentation
    "algorithm:histogram",
    "linematch:60",      -- try to align lines within hunks
  }

-- Makes horizontal splits more natural for side-by-side diffs
vim.o.splitright = true
vim.o.splitbelow = true


--================================================================
-- Python-specific settings
--================================================================

local python_group = augroup("python_prog", { clear = true })

autocmd("FileType", {
  group = python_group,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.wrap = false
  end,
})

--================================================================
-- Python filetype-specific configurations
--================================================================

local py_filetype = augroup("py_filetype", { clear = true })

-- Define folds by indentation
autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

-- Space bar to toggle folds
autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  command = "nnoremap <buffer> <space> za",
})

-- Highlight trailing whitespace in red
autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  command = "syn match BadWhitespace /\\s\\+$/",
})

autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  command = "highlight BadWhitespace ctermbg=red guibg=darkred",
})

-- Execute Python script with F9 and F10
autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  command = "nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<CR>",
})

autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  command = "nnoremap <buffer> <F10> :exec '!python -i' shellescape(@%, 1)<CR>",
})

-- Abbreviation for if __name__ == '__main__':
autocmd("FileType", {
  group = py_filetype,
  pattern = "python",
  command = "iabbrev <buffer> namemain if __name__ == '__main__':",
})

--================================================================
-- Format options (do not auto-wrap comments or auto-insert comment leader)
--================================================================

autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "o" })
  end,
})

--================================================================
-- Clean extra spaces on save for specific filetypes
--================================================================

autocmd("BufWritePre", {
  pattern = { "*.txt", "*.js", "*.py", "*.wiki", "*.sh", "*.coffee" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    local old_query = vim.fn.getreg("/")
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
    vim.fn.setreg("/", old_query)
  end,
})

--================================================================
-- Return to last edit position when opening files
--================================================================

autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--================================================================
-- Template system for new files
--================================================================

local templates_group = augroup("templates", { clear = true })

-- Python template
autocmd("BufNewFile", {
  group = templates_group,
  pattern = "*.py",
  callback = function()
    local template_path = vim.fn.expand("$HOME/.vim/templates/python_skeleton.txt")
    if vim.fn.filereadable(template_path) == 1 then
      vim.cmd("silent! 0r " .. template_path)
    end
  end,
})

-- C++ template
autocmd("BufNewFile", {
  group = templates_group,
  pattern = "*.cpp",
  callback = function()
    local template_path = vim.fn.expand("$HOME/.vim/templates/cpp_skeleton.cpp")
    if vim.fn.filereadable(template_path) == 1 then
      vim.cmd("silent! 0r " .. template_path)
    end
  end,
})

-- Template variable substitution
autocmd("BufNewFile", {
  group = templates_group,
  pattern = "*",
  callback = function()
    vim.cmd([[silent! %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge]])
  end,
})

--================================================================
-- Tab leave tracking for tab switching
--================================================================

autocmd("TabLeave", {
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

--================================================================
-- Highlight when yanking text
--================================================================

autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--================================================================
-- Python omnifunc
--================================================================

autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.omnifunc = "pythoncomplete#Complete"
  end,
})

--================================================================
-- C/C++ LSP omnifunc (if clangd is available)
--================================================================

if vim.fn.executable("clangd") == 1 then
  local lsp_clangd = augroup("lsp_clangd", { clear = true })

  autocmd("FileType", {
    group = lsp_clangd,
    pattern = { "c", "cpp", "objc", "objcpp" },
    callback = function()
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
end

--================================================================
-- Custom highlights (MatchParen + Diff colors)
--================================================================

local function set_custom_highlights()
  -- MatchParen - cyan background for high visibility
  vim.api.nvim_set_hl(0, 'MatchParen', {
    fg = '#000000',
    bg = '#00FFFF',
    bold = true,
    underline = false
  })

  vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#71A171', fg = "NONE", bold = false })
  vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#CF9191', fg = "NONE", bold = false })
  vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#0066cc', fg = "NONE" })
  vim.api.nvim_set_hl(0, 'DiffText', { bg = '#4d4d1a', fg = '#ffff00', bold = true })
end

-- Apply on colorscheme change
autocmd("ColorScheme", {
  pattern = "*",
  callback = set_custom_highlights
})

-- Apply immediately at startup
set_custom_highlights()

-----------------------------------------------------------
-- Optional: diff-specific tweaks
-----------------------------------------------------------
-- Make wrapped lines off in diff so alignment is clearer
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.wo.diff then
      vim.wo.wrap = false
      vim.wo.cursorline = true
    end
  end,
})

--================================================================
-- Show LSP diagnostics in command line when cursor is idle
--================================================================

local diagnostic_display = augroup("diagnostic_display", { clear = true })

autocmd({ "CursorHold", "CursorHoldI" }, {
  group = diagnostic_display,
  callback = function()
    local line = vim.fn.line('.') - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = line })

    if #diagnostics > 0 then
      local diag = diagnostics[1]
      local severity = diag.severity

      local hl_group = "Normal"
      if severity == vim.diagnostic.severity.ERROR then
        hl_group = "DiagnosticError"
      elseif severity == vim.diagnostic.severity.WARN then
        hl_group = "DiagnosticWarn"
      elseif severity == vim.diagnostic.severity.INFO then
        hl_group = "DiagnosticInfo"
      elseif severity == vim.diagnostic.severity.HINT then
        hl_group = "DiagnosticHint"
      end

      vim.api.nvim_echo({{diag.message, hl_group}}, false, {})
    else
      vim.api.nvim_echo({{"", "Normal"}}, false, {})
    end
  end,
})
