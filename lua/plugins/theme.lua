return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true, -- Enable transparent background
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
  --
  -- add tokyonight
  -- { "folke/tokyonight.nvim" },
  -- { "catppuccin/nvim", name = "catppuccin" },
  -- {
  --   "Shatur/neovim-ayu",
  --   config = function ()
  --     require('ayu').setup({
  --       mirage = false,
  --       terminal = true,
  --       overrides = {},
  --     })
  --     require('ayu').colorscheme()
  --   end,
  -- },
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup({
  --       cache = true,
  --       transparent = true,
  --       italic_comments = true,
  --       hide_fillchars = false,
  --       borderless_telescope = true,
  --       terminal_colors = true,
  --       theme = {
  --         variant = "auto",
  --         saturation = 1,
  --       },
  --       extensions = {
  --         telescope = true,
  --         notify = true,
  --         mini = true,
  --       },
  --     })
  --     vim.cmd("colorscheme cyberdream")
  --   end,
  -- },
}
