return {
  -- Dark themes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          mason = true,
          native_lsp = { enabled = true },
          telescope = { enabled = true },
          which_key = true,
        },
      }
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      compile = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
    },
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    opts = {
      transparent = false,
      italic_comments = true,
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
  },

  -- Additional dark themes for programming
  {
    "morhetz/gruvbox",
    lazy = true,
  },

  {
    "arcticicestudio/nord-vim",
    name = "nord",
    lazy = true,
  },

  {
    "dracula/vim",
    name = "dracula",
    lazy = true,
  },

  -- Light themes for daytime coding
  {
    "yonlu/omni.vim",
    name = "omni",
    lazy = true,
  },

  {
    "NLKNguyen/papercolor-theme",
    name = "papercolor",
    lazy = true,
  },

  {
    "ayu-theme/ayu-vim",
    name = "ayu",
    lazy = true,
  },

  {
    "altercation/vim-colors-solarized",
    name = "solarized",
    lazy = true,
  },

  {
    "nanotech/jellybeans.vim",
    name = "jellybeans",
    lazy = true,
  },

  -- Colorscheme loader and switcher
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
  },

  {
    "echasnovski/mini.nvim",
    optional = true,
    name = "colorscheme-loader",
    lazy = false,
    priority = 1000,
    config = function()
      local theme = require "core.theme"

      -- Load last saved theme or default to "catppuccin"
      local saved_theme = theme.load_saved_theme()
      local default_theme = saved_theme or "catppuccin"

      -- Apply the theme
      theme.apply_theme(default_theme)
    end,
  },
}
