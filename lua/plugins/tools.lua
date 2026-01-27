-- Developer tools: formatting (conform.nvim) and linting (nvim-lint)
return {
  -- Formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>lF",
        function()
          require("conform").format { formatters = { "injected" }, timeout_ms = 3000 }
        end,
        mode = { "n", "v" },
        desc = "LSP: Format injected languages",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "zapling/mason-conform.nvim",
    cmd = { "Mason", "ConformInfo" },
    dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
    opts = {},
  },

  -- Linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "InsertLeave" },
    dependencies = {
      {
        "rshkarin/mason-nvim-lint",
        dependencies = { "williamboman/mason.nvim" },
        opts = {},
      },
    },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        lua = { "luacheck" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
