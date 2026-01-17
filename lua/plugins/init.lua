return {
  -- Common Plugins
  -- Core Formatting
  {
    "stevearc/conform.nvim",
    version = "v5.*",
    event = "BufWritePre", -- Load when saving to format
    cmd = "ConformInfo",
    opts = require "configs.conform",
  },

  -- Core Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- Core Mason (Tool Installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
      ensure_installed = {
        "lua-language-server",
      },
    },
  },

  -- Core Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*", -- Pin to latest stable release
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.treesitter"
    end,
  },

  -- Core LSP
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local configs = require "configs.lspconfig"
      local on_attach = configs.on_attach
      local on_init = configs.on_init
      local capabilities = configs.capabilities

      -- Merge default configuration with the specific server config
      for name, config in pairs(opts.servers or {}) do
        -- Use vim.lsp.config (Nvim 0.10+) pattern
        vim.lsp.config(name, vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          on_init = on_init,
          capabilities = capabilities,
        }, config))

        -- Enable the server globally (so it attaches to valid filetypes)
        vim.lsp.enable(name)
      end
    end,
  },

  -- Mason Integrations (Lazy Loaded)
  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = { "conform.nvim" },
    config = function()
      require "configs.mason-conform"
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-lint" },
    config = function()
      require "configs.mason-lint"
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
    config = function()
      require "configs.mason-lspconfig"
    end,
  },

  -- Aesthetics
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure {
        delay = 120,
        modes_denylist = { "i" },
      }
    end,
  },
}
