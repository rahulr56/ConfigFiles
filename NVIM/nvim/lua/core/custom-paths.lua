-- Custom Data Directory Configuration
-- Uses standard XDG defaults:
--   data:   ~/.local/share/nvim
--   state:  ~/.local/state/nvim
--   cache:  ~/.cache/nvim
--   config: ~/.config/nvim

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_dir(vim.fn.stdpath("data"))
ensure_dir(vim.fn.stdpath("state"))
ensure_dir(vim.fn.stdpath("cache"))
ensure_dir(vim.fn.stdpath("data") .. "/lazy")
ensure_dir(vim.fn.stdpath("data") .. "/mason")
