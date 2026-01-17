return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "rust", "toml" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust-analyzer", "codelldb" })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" }, -- Lazy load only on rust files
    config = function()
      -- Dynamically find codelldb adapter from Mason
      local mason_registry = require "mason-registry"
      local codelldb = mason_registry.get_package "codelldb"
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb"
      
      -- OS specific liblldb extension
      local this_os = vim.loop.os_uname().sysname
      if this_os == "Linux" then
        liblldb_path = liblldb_path .. ".so"
      elseif this_os == "Windows_NT" then
        liblldb_path = liblldb_path .. ".dll"
      else
        liblldb_path = liblldb_path .. ".dylib"
      end

      local cfg = require "rustaceanvim.config"
      
      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
          on_attach = function(client, bufnr)
            -- Use the common on_attach setup
            require("configs.lspconfig").on_attach(client, bufnr)
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup {
        completion = { cmp = { enabled = true } },
      }
      -- Hook into cmp
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.setup.buffer { sources = { { name = "crates" } } }
      end
    end,
  },
}
