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
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    opts = {},
    config = function(_, opts)
      local mason_lspconfig = require "mason-lspconfig"

      local map = vim.keymap.set

      -- Exporting capabilities for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local blink_ok, blink = pcall(require, "blink.cmp")
      if blink_ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- LspAttach Autocmd for Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer specific mappings
          map("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "LSP: Go to declaration" })
          map("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "LSP: Go to definition" })
          map("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP: Hover documentation" })
          map("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "LSP: Go to implementation" })
          map("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "LSP: Signature help" })
          map(
            "n",
            "<leader>wa",
            vim.lsp.buf.add_workspace_folder,
            { buffer = ev.buf, desc = "LSP: Add workspace folder" }
          )
          map(
            "n",
            "<leader>wr",
            vim.lsp.buf.remove_workspace_folder,
            { buffer = ev.buf, desc = "LSP: Remove workspace folder" }
          )
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { buffer = ev.buf, desc = "LSP: List workspace folders" })
          map("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "LSP: Type definition" })
          map("n", "<leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "LSP: Rename symbol" })
          map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "LSP: Code action" })
          map("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "LSP: Show references" })
          map("n", "<leader>lf", function()
            vim.lsp.buf.format { async = true }
          end, { buffer = ev.buf, desc = "LSP: Format document" })

          -- Diagnostic navigation
          map("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "LSP: Previous diagnostic" })
          map("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "LSP: Next diagnostic" })
          map("n", "<leader>ld", vim.diagnostic.open_float, { buffer = ev.buf, desc = "LSP: Show diagnostics" })
        end,
      })

      -- Setup mason-lspconfig
      -- This will automatically enable installed servers
      mason_lspconfig.setup {
        ensure_installed = { "lua_ls", "bashls", "pyright" },
        -- Don't add rust_analyzer here - let rustaceanvim manage it
        handlers = {
          -- Default handler: auto-enable all servers
          function(server_name)
            vim.lsp.enable(server_name)
          end,
        },
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

      -- Process language-specific server configs from opts.servers
      -- (set by language files via lang_utils.extend_lspconfig)
      if opts.servers then
        for server_name, server_config in pairs(opts.servers) do
          local config = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
          }, server_config)
          vim.lsp.config(server_name, config)
        end
      end

      -- IMPORTANT: rust-analyzer is handled exclusively by rustaceanvim
      -- (in lua/plugins/rust.lua). We skip it here to avoid conflicts.
    end,
  },
}
