local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.schedule(function()
    vim.notify(
      "lazy.nvim is not installed. Automatic bootstrap is disabled; install it manually before starting Neovim.",
      vim.log.levels.ERROR
    )
  end)
  return
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = true },
  install = { missing = false },
  checker = { enabled = false }, -- disable auto-check for better performance (use :Lazy check)
  performance = {
    rtp = {
      -- disable some rtp plugins for faster startup
      disabled_plugins = {
        "gzip",
        "matchit",
        -- "matchparen", -- keep for bracket matching
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "rplugin", -- remote plugins (not used)
        "spellfile", -- spell file download (rarely used)
        "editorconfig", -- we set options explicitly
      },
    },
  },
}
