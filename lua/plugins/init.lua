return {
  -- Common Plugins
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",
        -- Python
        "pyright",
        "ruff",
        "mypy",
        "black",
        "isort",
        -- Go
        "gopls",
        "golangci-lint",
        "delve",
        "goimports",
        "gomodifytags",
        "impl",
        -- Web / TS
        "typescript-language-server",
        "eslint_d",
        "prettierd",
        "prettier",
        -- C/C++
        "clangd",
        "clang-format",
        -- TeX / Typst
        "texlab",
        "latexindent",
        "tinymist",
        -- Rust
        "rust-analyzer",
        "codelldb",
        "debugpy",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.treesitter"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = { "conform.nvim" },
    config = function()
      require "configs.mason-conform"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
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
