return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "LSP: Mason" } },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Custom command to clean install
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require "lspconfig"
      local mason_lspconfig = require "mason-lspconfig"

      local map = vim.keymap.set

      -- Exporting capabilities for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- LspAttach Autocmd for Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer specific mappings
          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "gi", vim.lsp.buf.implementation, opts)
          map("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          map("n", "<leader>lr", vim.lsp.buf.rename, opts)
          map("n", "<leader>la", vim.lsp.buf.code_action, opts)
          map("n", "gr", vim.lsp.buf.references, opts)
          map("n", "<leader>lf", function()
            vim.lsp.buf.format { async = true }
          end, opts)

          -- Diagnostic navigation
          map("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "LSP: Previous diagnostic" })
          map("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "LSP: Next diagnostic" })
          map("n", "<leader>ld", vim.diagnostic.open_float, { buffer = ev.buf, desc = "LSP: Show diagnostics" })
        end,
      })

      -- setup mason-lspconfig
      mason_lspconfig.setup {
        ensure_installed = { "lua_ls", "bashls", "pyright" },
      }

      mason_lspconfig.setup_handlers {
        -- Default handler
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,

        -- Specific overrides example
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
              },
            },
          }
        end,
      }
    end,
  },
}
