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
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
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
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "js-debug-adapter", "codelldb", "python", "delve" },
      automatic_installation = true,
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
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
    config = function()
      require("illuminate").configure {
        -- Configuration options go here:
        -- delay = 100,
        -- filetypes_denylist = {'NvimTree', 'packer'},
        -- modes_denylist = {'i', 'v'},
        -- providers = {'lsp', 'treesitter', 'regex'},
      }
    end,
  },
}
