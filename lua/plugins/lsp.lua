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
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason_lspconfig = require "mason-lspconfig"

      local map = vim.keymap.set

      -- Exporting capabilities for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_nvim_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

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

      -- Setup mason-lspconfig
      -- This will automatically enable installed servers (automatic_enable is true by default)
      mason_lspconfig.setup {
        ensure_installed = { "lua_ls", "bashls", "pyright" },
        -- Don't add rust_analyzer here - let rustaceanvim manage it
      }

      -- Configure servers using new vim.lsp.config API (Neovim 0.11+)
      -- This replaces the deprecated require('lspconfig') framework
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- IMPORTANT: rust-analyzer is handled exclusively by rustaceanvim
      -- (in lua/plugins/rust.lua). We skip it here to avoid conflicts.
    end,
  },
}
