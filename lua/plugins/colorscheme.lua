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

  -- Gruvbox Material - replaces morhetz/gruvbox (Vimscript)
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },

  -- Nordic - replaces arcticicestudio/nord-vim (Vimscript)
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    opts = {},
  },

  -- Dracula (Lua) - replaces dracula/vim (Vimscript)
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {},
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

  -- Solarized Osaka - replaces altercation/vim-colors-solarized (Vimscript)
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    opts = {},
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

  -- === Additional themes ===

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

  -- === New colorschemes ===

  -- Sonokai - Monokai Pro-inspired with 6 style variants
  {
    "sainnhe/sonokai",
    lazy = true,
    config = function()
      vim.g.sonokai_better_performance = 1
    end,
  },

  -- Edge - Atom One + Material hybrid with dark and light variants
  {
    "sainnhe/edge",
    lazy = true,
    config = function()
      vim.g.edge_better_performance = 1
    end,
  },

  -- Lackluster - monochrome/minimal colorscheme with selective accents
  {
    "slugbyte/lackluster.nvim",
    lazy = true,
  },

  -- Modus - WCAG AAA accessible themes with deuteranopia/tritanopia variants
  {
    "miikanissi/modus-themes.nvim",
    lazy = true,
    opts = {},
  },

  -- Bamboo - green-focused, low-blue eye comfort theme
  {
    "ribru17/bamboo.nvim",
    lazy = true,
    opts = {},
  },
}
