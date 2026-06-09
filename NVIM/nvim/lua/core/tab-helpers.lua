-- Tab and Space Conversion Helpers
-- Commands to convert between tabs and spaces

-- Convert all tabs to spaces in current buffer
vim.api.nvim_create_user_command("TabsToSpaces", function()
  local save_cursor = vim.fn.getpos(".")
  vim.cmd([[%retab!]])
  vim.fn.setpos(".", save_cursor)
  print("Converted all tabs to spaces")
end, { desc = "Convert all tabs to spaces in current buffer" })

-- Convert all spaces to tabs in current buffer
vim.api.nvim_create_user_command("SpacesToTabs", function()
  local save_cursor = vim.fn.getpos(".")
  local expandtab_save = vim.o.expandtab
  vim.o.expandtab = false
  vim.cmd([[%retab!]])
  vim.o.expandtab = expandtab_save
  vim.fn.setpos(".", save_cursor)
  print("Converted all spaces to tabs")
end, { desc = "Convert all spaces to tabs in current buffer" })

-- Show current tab settings
vim.api.nvim_create_user_command("TabSettings", function()
  print(string.format([[
Tab Settings:
  expandtab:    %s
  tabstop:      %d
  shiftwidth:   %d
  softtabstop:  %d
  smarttab:     %s
]],
    vim.o.expandtab and "true" or "false",
    vim.o.tabstop,
    vim.o.shiftwidth,
    vim.o.softtabstop,
    vim.o.smarttab and "true" or "false"
  ))
end, { desc = "Show current tab settings" })

-- Set tab width to N spaces (e.g., :SetTabWidth 4)
vim.api.nvim_create_user_command("SetTabWidth", function(opts)
  local width = tonumber(opts.args)
  if not width or width < 1 then
    print("Error: Please provide a valid number (e.g., :SetTabWidth 2)")
    return
  end

  vim.o.tabstop = width
  vim.o.shiftwidth = width
  vim.o.softtabstop = width
  vim.o.expandtab = true

  print(string.format("Tab width set to %d spaces (expandtab=true)", width))
end, { nargs = 1, desc = "Set tab width to N spaces" })

-- Keymaps for quick access
vim.keymap.set("n", "<leader>ts", ":TabsToSpaces<CR>", {
  desc = "Convert [T]abs to [S]paces",
  silent = true
})

vim.keymap.set("n", "<leader>ti", ":TabSettings<CR>", {
  desc = "[T]ab [I]nfo/Settings",
  silent = true
})
