-- Require Neovim 0.11+.
-- Why: vim.lsp.config() (used throughout lsp.lua) is a 0.11+ API, and the
-- nvim-treesitter main branch dropped support for 0.10 and earlier. Without
-- this guard, users on older versions get cryptic crashes inside plugin code
-- rather than a clear, actionable message. Revert risk: none — this config
-- uses 0.11+ APIs pervasively; it will not work on older versions regardless.
if vim.fn.has "nvim-0.11" == 0 then
  vim.notify(
    "This config requires Neovim 0.11 or later. Please upgrade: https://github.com/neovim/neovim/releases",
    vim.log.levels.ERROR
  )
  return
end

require "core.init"
