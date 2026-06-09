-- Telescope Configuration
-- Replaces FZF from original vimrc

require("telescope").setup({
  defaults = {
    -- Layout configuration similar to FZF preview
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        prompt_position = "bottom",
        width = 0.8,
      },
    },

    -- File ignore patterns
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.pyc$",
      "%.o$",
      "__pycache__/",
    },

    -- Mappings
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-/>"] = "which_key", -- Preview window toggle
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
      n = {
        ["<C-/>"] = "which_key",
      },
    },

    -- Preview configuration
    preview = {
      treesitter = true,
    },

    -- Sorting configuration
    sorting_strategy = "ascending",
    prompt_prefix = "🔍 ",
    selection_caret = "▶ ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
  },

  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = false,
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      initial_mode = "normal",
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
        n = {
          ["dd"] = "delete_buffer",
        },
      },
    },
    live_grep = {
      theme = "ivy",
    },
    grep_string = {
      theme = "ivy",
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

-- Load extensions
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

-- Keymaps (similar to FZF keymaps from original vimrc)
local builtin = require("telescope.builtin")

-- Main file finding (replaces FzfFiles and CtrlP)
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>F", function()
  builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "Find All Files" })

-- Buffers (replaces FzfBuffers and CtrlPBuffer)
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find Buffers" })

-- Live grep (replaces FZF Rg and Ack)
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })

-- Command palette
vim.keymap.set("n", "<leader>;", builtin.commands, { desc = "Commands" })

-- Lines in buffer (replaces CtrlPLine)
vim.keymap.set("n", "<leader>L", builtin.current_buffer_fuzzy_find, { desc = "Lines in current buffer" })

-- Recent files (replaces CtrlPMRU)
vim.keymap.set("n", "<leader>m", builtin.oldfiles, { desc = "Recent Files (MRU)" })

-- Help tags
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

-- Keymaps
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })

-- Git files
vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "[G]it [F]iles" })

-- Git commits
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits" })

-- Git branches
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[G]it [B]ranches" })

-- LSP symbols (replaces CtrlPBufTag)
vim.keymap.set("n", ",g", builtin.lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set("n", ",G", builtin.lsp_workspace_symbols, { desc = "Workspace Symbols" })

-- Search in current buffer
vim.keymap.set("n", ",p", builtin.current_buffer_fuzzy_find, { desc = "Search in Buffer" })

-- Diagnostics
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

-- Resume last search
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

-- Search with current word pre-filled
vim.keymap.set("n", ",wf", function()
  builtin.current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Search word in buffer" })

vim.keymap.set("n", ",we", function()
  builtin.find_files({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Find files with word" })

vim.keymap.set("n", ",wg", function()
  builtin.lsp_document_symbols({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Document symbols with word" })

vim.api.nvim_create_user_command("RG", function(opts)
  builtin.grep_string({ search = opts.args })
end, { nargs = "*" })

-- History command (replaces FzfHistory)
vim.keymap.set("c", "<C-p>", function()
  builtin.command_history()
end, { desc = "Command History" })
