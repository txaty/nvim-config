return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    config = function()
      -- Derive codelldb paths without requiring Mason registry to be initialized.
      local data = vim.fn.stdpath "data"
      local extension_path = data .. "/mason/packages/codelldb/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local uname = vim.loop.os_uname().sysname
      local liblldb_path
      if uname == "Linux" then
        liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      elseif uname == "Windows_NT" then
        liblldb_path = extension_path .. "lldb/bin/liblldb.dll"
      else
        liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      end
      local cfg = require "rustaceanvim.config"

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
          on_attach = require("nvchad.configs.lspconfig").on_attach,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              procMacro = { enabled = true },
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
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.setup.buffer { sources = { { name = "crates" } } }
      end
    end,
  },
}
