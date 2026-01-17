
return {
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
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
      })
    end,
  },

  -- Tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "storm" },
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      compile = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
    },
  },

  -- Cyberdream
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    opts = {
      transparent = true,
      italic_comments = true,
    },
  },

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },

  -- Nightfox
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },

  -- OneDark
  {
    "navarasu/onedark.nvim",
    lazy = true,
  },

  -- Meta-plugin to load the colorscheme of choice
  {
    "LazyVim/LazyVim", -- Placeholder name, we are just using the init logic
    name = "colorscheme-loader",
    lazy = false, -- Load immediately
    priority = 1000, -- Load first
    config = function()
      -- Change this line to switch themes!
      -- Options: "catppuccin", "tokyonight", "kanagawa", "cyberdream", "rose-pine", "nightfox", "onedark"
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
