return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "tsx", "html", "css", "json" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "prettier",
        "eslint_d",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
      },
    },
  },
}
