-- LSP Configuration
-- Replaces ALE from original vimrc with native Neovim LSP

-- LSP servers to install and configure
local servers = {
  -- Python
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },

  -- C/C++
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
    },
  },

  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },

  -- Add other LSP servers as needed
  -- bashls = {},
  -- jsonls = {},
}

-- Tools to ensure are installed via Mason
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua", -- Lua formatter
  "black", -- Python formatter
  "ruff", -- Python linter (replaces ALE's ruff)
  "cpplint", -- C++ linter
})

require("mason-tool-installer").setup({
  ensure_installed = ensure_installed,
})

-- Setup LSP capabilities with nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- LSP attach callback
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Keymaps based on original vimrc jedi-vim mappings
    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Tab for definition in new tab (like original vimrc ,D mapping)
    map(",D", function()
      vim.cmd("tab split")
      vim.lsp.buf.definition()
    end, "Definition in new tab")

    -- Highlight references on hold
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    -- Inlay hints toggle if supported
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

-- Diagnostic configuration (similar to ALE signs from original vimrc)
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.INFO] = "ℹ",
      [vim.diagnostic.severity.HINT] = "➤",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

-- Configure sign column colors (similar to ALE clear from original vimrc)
vim.cmd([[
  highlight clear ALEErrorSign
  highlight clear ALEWarningSign
]])

-- Setup Mason LSP Config
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers or {}),
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
})

-- Custom LSP setup for clangd if P4_ROOT is set (from original vimrc)
if vim.env.P4_ROOT and vim.env.P4_ROOT ~= "" then
  local p4_root = vim.env.P4_ROOT
  if vim.fn.isdirectory(vim.env.P4_ROOT .. "/HEAD") == 1 then
    p4_root = vim.env.P4_ROOT .. "/HEAD"
  end

  -- Build include paths for clangd
  local include_paths = {
    p4_root .. "/src/shared/device/devmodel",
    p4_root .. "/src/shared/common",
    p4_root .. "/src/ext/Boost/boost_1_72_0",
    p4_root .. "/src/ext/gurobi/include",
    p4_root .. "/src/ext/",
  }

  -- Add common directories
  local common_dir = vim.env.P4_ROOT .. "/src/shared/common/common/"
  if vim.fn.isdirectory(common_dir) == 1 then
    local subdirs = vim.fn.globpath(common_dir, "*", 0, 1)
    for _, dir in ipairs(subdirs) do
      table.insert(include_paths, dir)
    end
  end

  -- Configure clangd with these paths
  if servers.clangd then
    servers.clangd.cmd = servers.clangd.cmd or { "clangd" }
    for _, path in ipairs(include_paths) do
      table.insert(servers.clangd.cmd, "-I" .. path)
    end
  end
end
