return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup({
  --       transparent_mode = true, -- Enable transparent background
  --     })
  --     vim.cmd("colorscheme gruvbox")
  --   end,
  -- },
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
  --       -- transparent = true,
  --       italic_comments = true,
  --       -- hide_fillchars = false,
  --       borderless_telescope = true,
  --       terminal_colors = true,
  --       -- theme = {
  --       --   variant = "light",
  --       --   saturation = 1,
  --       -- },
  --       extensions = {
  --         telescope = true,
  --         notify = true,
  --         mini = true,
  --       },
  --     })
  --     vim.cmd("colorscheme cyberdream")
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({
  --       compile = false, -- enable compiling the colorscheme
  --       undercurl = true, -- enable undercurls
  --       commentStyle = { italic = true },
  --       functionStyle = {},
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --       typeStyle = {},
  --       transparent = false, -- do not set background color
  --       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  --       terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --       colors = { -- add/modify theme and palette colors
  --         palette = {},
  --         theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  --       },
  --       overrides = function(colors) -- add/modify highlights
  --         return {}
  --       end,
  --       theme = "wave", -- Load "wave" theme when 'background' option is not set
  --       background = { -- map the value of 'background' option to a theme
  --         dark = "dragon", -- try "dragon" !
  --         light = "lotus",
  --       },
  --     })
  --     vim.cmd("colorscheme kanagawa")
  --   end,
  -- },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({
        options = {
          terminal_colors = true,
          transparent = true,
        },
      })

      vim.cmd("colorscheme github_dark_tritanopia")
    end,
  },
  -- {
  --   "loctvl842/monokai-pro.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("monokai-pro").setup()
  --   end,
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("onedark").setup({
  --       -- Main options --
  --       style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  --       transparent = true, -- Show/hide background
  --       term_colors = true, -- Change terminal color as per the selected theme style
  --       ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
  --       cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
  --
  --       -- toggle theme style ---
  --       toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  --       toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between
  --
  --       -- Change code style ---
  --       -- Options are italic, bold, underline, none
  --       -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
  --       code_style = {
  --         comments = "italic",
  --         keywords = "none",
  --         functions = "none",
  --         strings = "none",
  --         variables = "none",
  --       },
  --
  --       -- Lualine options --
  --       lualine = {
  --         transparent = false, -- lualine center bar transparency
  --       },
  --
  --       -- Plugins Config --
  --       diagnostics = {
  --         darker = true, -- darker colors for diagnostic
  --         undercurl = true, -- use undercurl instead of underline for diagnostics
  --         background = true, -- use background color for virtual text
  --       },
  --     })
  --     vim.cmd("colorscheme onedark")
  --   end,
  -- },
}
