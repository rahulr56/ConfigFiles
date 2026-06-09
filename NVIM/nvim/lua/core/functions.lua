-- Helper Functions
-- Migrated from .vimrc

--================================================================
-- Initialize backup/undo/swap directories
--================================================================

function _G.InitializeDirectories()
  local separator = "."
  local parent = vim.fn.expand("$HOME")
  local prefix = ".vim"
  local dir_list = {
    backup = "backupdir",
    views = "viewdir",
    swap = "directory",
    undo = "undodir",
  }

  for dirname, settingname in pairs(dir_list) do
    local directory = parent .. "/" .. prefix .. dirname .. "/"
    if vim.fn.isdirectory(directory) == 0 then
      vim.fn.mkdir(directory, "p")
    end
    if vim.fn.isdirectory(directory) == 0 then
      print("Warning: Unable to create backup directory: " .. directory)
      print("Try: mkdir -p " .. directory)
    else
      directory = directory:gsub(" ", "\\ ")
      vim.cmd("set " .. settingname .. "=" .. directory)
    end
  end
end

-- Call the function to initialize directories
InitializeDirectories()

--================================================================
-- Visual Selection helper
--================================================================

function _G.VisualSelection(direction, extra_filter)
  local saved_reg = vim.fn.getreg('"')
  vim.cmd('normal! vgvy')
  local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
  pattern = pattern:gsub("\n", "\\n")

  if direction == "gv" then
    vim.cmd("Ack " .. pattern .. " " .. extra_filter)
  elseif direction == "replace" then
    vim.cmd("%s/" .. pattern .. "/")
  end

  vim.fn.setreg('"', saved_reg)
end

--================================================================
-- HasPaste - Check if paste mode is enabled
--================================================================

function _G.HasPaste()
  if vim.o.paste then
    return "PASTE MODE  "
  end
  return ""
end

--================================================================
-- Bclose - Close buffer without closing window
--================================================================

function _G.BufcloseCloseIt()
  local currentBufNum = vim.fn.bufnr("%")
  local alternateBufNum = vim.fn.bufnr("#")

  if vim.fn.buflisted(alternateBufNum) == 1 then
    vim.cmd("buffer #")
  else
    vim.cmd("bnext")
  end

  if vim.fn.bufnr("%") == currentBufNum then
    vim.cmd("new")
  end

  if vim.fn.buflisted(currentBufNum) == 1 then
    vim.cmd("bdelete! " .. currentBufNum)
  end
end

-- Create the Bclose command
vim.api.nvim_create_user_command("Bclose", function()
  BufcloseCloseIt()
end, {})

--================================================================
-- Clean extra spaces function
--================================================================

function _G.CleanExtraSpaces()
  local save_cursor = vim.fn.getpos(".")
  local old_query = vim.fn.getreg("/")
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
  vim.fn.setreg("/", old_query)
end

--================================================================
-- Delete till slash (for command mode)
--================================================================

function _G.DeleteTillSlash()
  local cmdline = vim.fn.getcmdline()
  local idx = cmdline:reverse():find("/")
  if idx then
    return cmdline:sub(1, #cmdline - idx)
  end
  return cmdline
end

--================================================================
-- Current file directory helper
--================================================================

function _G.CurrentFileDir(cmd)
  return cmd .. " " .. vim.fn.expand("%:p:h") .. "/"
end

--================================================================
-- LinterStatus function (for statusline)
--================================================================

function _G.LinterStatus()
  if not vim.diagnostic then
    return "OK"
  end

  local diagnostics = vim.diagnostic.get(0)
  local errors = 0
  local warnings = 0

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    end
  end

  if errors + warnings == 0 then
    return "OK"
  end

  return string.format("%dW %dE", warnings, errors)
end

--================================================================
-- CtrlP with search text helper (for file finding)
--================================================================

function _G.CtrlPWithSearchText(search_text, ctrlp_command_end)
  vim.cmd("CtrlP" .. ctrlp_command_end)
  vim.fn.feedkeys(search_text)
end
