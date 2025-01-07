-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})

require("lazyvim.util").on_load("neo-tree.nvim", function()
  require("neo-tree").setup({
    window = {
      width = 30, -- Set desired width
    },
  })
end)
