return {
  -- === Dark themes ===
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

  -- === Light themes ===
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

  -- GitHub theme with all variants (dark, light, high contrast, colorblind)
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
    config = function()
      require("github-theme").setup {
        options = {
          compile_path = vim.fn.stdpath "cache" .. "/github-theme",
          compile_file_suffix = "_compiled",
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      }
    end,
  },

  -- === New themes (added in redesign) ===

  -- Everforest - very popular green-based comfortable theme
  {
    "sainnhe/everforest",
    name = "everforest",
    lazy = true,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
    end,
  },

  -- Material - Google Material design theme
  {
    "marko-cerovac/material.nvim",
    name = "material.nvim",
    lazy = true,
    opts = {
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        non_current_windows = false,
      },
      plugins = {
        "gitsigns",
        "nvim-cmp",
        "nvim-tree",
        "telescope",
        "which-key",
      },
    },
  },

  -- VS Code - lookalike theme
  {
    "Mofiqul/vscode.nvim",
    name = "vscode.nvim",
    lazy = true,
    opts = {
      transparent = false,
      italic_comments = true,
    },
  },

  -- Moonfly - dark theme with moonlit colors
  {
    "bluz71/vim-moonfly-colors",
    name = "vim-moonfly-colors",
    lazy = true,
  },

  -- Nightfly - dark theme inspired by night flights
  {
    "bluz71/vim-nightfly-guicolors",
    name = "vim-nightfly-guicolors",
    lazy = true,
  },

  -- Melange - warm, cozy theme
  {
    "savq/melange-nvim",
    name = "melange-nvim",
    lazy = true,
  },

  -- Zenbones - minimal, readability-focused themes (requires lush.nvim)
  {
    "mcchrish/zenbones.nvim",
    name = "zenbones.nvim",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim" },
  },

  -- Oxocarbon - IBM Carbon design system theme
  {
    "nyoom-engineering/oxocarbon.nvim",
    name = "oxocarbon.nvim",
    lazy = true,
  },
}
