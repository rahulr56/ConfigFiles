-- Plugin Configuration
-- Using lazy.nvim plugin manager

return {
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- Which-key for keymap hints
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("which-key").setup()
      -- Document existing key chains
      require("which-key").add({
        { "<leader>c", group = "[C]ode" },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]ab/Toggle" },
      })
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("config.telescope")
    end,
  },

  -- Mason (must be set up before LSP)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- Autoformat
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable format_on_save for certain filetypes
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
      },
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end
      configs.setup({
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Statusline - vim-airline
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    config = function()
      vim.g.airline_powerline_fonts = 1
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g["airline#extensions#tabline#formatter"] = "unique_tail"
      vim.g["airline#extensions#whitespace#enabled"] = 0
      vim.g["airline#extensions#whitespace#symbol"] = '!'
      vim.g["airline#extensions#syntastic#enabled"] = 0
      vim.g["airline#extensions#branch#enabled"] = 0  -- Disable git branch (using Perforce)
      vim.g["airline#extensions#hunks#enabled"] = 0  -- Disable git diff stats
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g["airline#extensions#tabline#buffer_nr_show"] = 1
      vim.g.airline_theme = "wombat"

      -- Disable separators for cleaner look
      vim.g.airline_left_sep = ""
      vim.g.airline_left_alt_sep = ''
      vim.g.airline_right_sep = ""
      vim.g.airline_right_alt_sep = ""
      vim.g.airline_symbols.branch = ''
      vim.g.airline_symbols.readonly = ''
      vim.g.airline_symbols.linenr = ''

      -- Customize section layout
      vim.g.airline_section_z = "%p%% %l/%L≡ ℅:%c"
    end,
  },

  -- Color scheme
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
        on_highlights = function(hl, c)
          -- Override diff colors with visible backgrounds
          hl.DiffAdd = { bg = "#3d5a3d" }
          hl.DiffDelete = { bg = "#5a3d3d" }
          hl.DiffChange = { bg = "#3d4d5a" }
          hl.DiffText = { bg = "#5a5a3d", bold = true }
        end,
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment.nvim for easy commenting
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Tagbar for code navigation
  {
    "preservim/tagbar",
    keys = {
      { "<F8>", ":TagbarToggle<CR>", desc = "Toggle Tagbar" },
    },
    config = function()
      -- Tagbar settings from original vimrc
      vim.g.tagbar_autofocus = 1
      vim.g.tagbar_show_visibility = 1
      vim.g.tagbar_show_linenumbers = 1

      -- Try to use universal ctags if available
      local ctags_path = vim.fn.expand("~/.local/bin/universal_ctags")
      if vim.fn.executable(ctags_path) == 1 then
        vim.g.tagbar_ctags_bin = ctags_path
      end
    end,
  },

  -- Vim surround
  {
    "tpope/vim-surround",
  },

  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- Window picker
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
        show_prompt = false,
        filter_rules = {
          include_current_win = false,
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      })

      vim.keymap.set("n", "-", function()
        local picked_window_id = require("window-picker").pick_window()
        if picked_window_id then
          vim.api.nvim_set_current_win(picked_window_id)
        end
      end, { desc = "Pick a window" })
    end,
  },

  -- MRU - Most Recently Used files
  {
    "yegappan/mru",
    config = function()
      vim.g.MRU_Max_Entries = 400
      vim.keymap.set("n", "<leader>k", ":MRU<CR>", { desc = "Most Recently Used files" })
    end,
  },

  -- Ack/Ag integration for searching
  {
    "mileszs/ack.vim",
    config = function()
      -- Use ag (silver searcher) if available
      if vim.fn.executable("ag") == 1 then
        vim.g.ackprg = "ag --vimgrep"
      end

      -- Keymaps for Ack
      vim.keymap.set("n", ",r", ":Ack ", { desc = "Ack search" })
      vim.keymap.set("n", ",wr", ":Ack <cword><CR>", { desc = "Ack word under cursor" })
    end,
  },

  -- Perforce integration
  {
    "ngemily/vim-vp4",
  },

  -- Indent guides - shows vertical lines for indentation levels
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = true, show_end = false },
    },
  },

  -- Better quickfix window with preview and fuzzy search
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Smart splits navigation - works with tmux too
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<C-n>", function() require("smart-splits").move_cursor_down() end, desc = "Move to window below" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to window above" },
      { "<C-g>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize left" },
      { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize down" },
      { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize up" },
      { "<A-g>", function() require("smart-splits").resize_right() end, desc = "Resize right" },
    },
    opts = {},
  },

  -- Flash.nvim - jump to any location with 2-3 keystrokes
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Treesitter context - shows current function/class at top
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 3,
      min_window_height = 20,
    },
  },

  -- Better notifications - prettier popups
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        timeout = 3000,
        max_width = 50,
      })
      vim.notify = require("notify")
    end,
  },
}
