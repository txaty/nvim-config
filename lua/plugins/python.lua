return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "mypy",
        "black",
        "isort",
        "debugpy",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black", "isort" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "strict",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeHints = true,
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {},
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    ft = "python", -- Lazy load on python filetype
    cmd = "VenvSelect",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python: select virtualenv" },
    },
    opts = {
      name = "venv",
      stay_on_window = true,
    },
    config = function(_, opts)
      local selector = require "venv-selector"
      selector.setup(opts)

      -- Setup DAP with debugpy installed by mason
      local mason_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      local python_path = vim.uv.fs_stat(mason_path) and mason_path or "python3"

      -- We use pcall just in case dap-python isn't loaded yet,
      -- though the dependency chain should ensure it.
      pcall(function()
        require("dap-python").setup(python_path)
      end)
    end,
  },
}
