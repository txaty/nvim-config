return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "golangci-lint",
        "delve",
        "goimports",
        "gomodifytags",
        "impl",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gotmpl", "gowork" },
          root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              completeUnimported = true,
              usePlaceholders = true,
              staticcheck = true,
            },
          },
        },
      },
    },
  },
}
