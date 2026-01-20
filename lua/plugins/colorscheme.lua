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

  -- GitHub theme with all variants (dark, light, high contrast, colorblind)
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
    config = function()
      require("github-theme").setup {
        options = {
          -- Compile to cache for better performance
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
}
