return {
  -- Incremental LSP rename: see changes live as you type
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>lr",
        function()
          return ":IncRename " .. vim.fn.expand "<cword>"
        end,
        expr = true,
        desc = "LSP: Incremental Rename",
      },
    },
    opts = {
      input_buffer_type = "dressing",
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "LSP: Mason" } },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Custom command to clean install
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd { cmd = "MasonInstall", args = opts.ensure_installed }
      end, {})
    end,
  },

  -- Mason-LSPconfig bridge (explicit plugin spec for language file extensions)
  -- Language files use lang_utils.extend_mason_lspconfig() to add servers.
  -- This spec ensures mason-lspconfig has a configuration point that language
  -- files can merge into via opts functions.
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true, -- Loaded as dependency of lspconfig
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "bashls", "marksman" },
      -- Keep server enable timing under our control in lspconfig.config()
      -- so vim.lsp.config() runs before clients are started.
      automatic_enable = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
      { "saghen/blink.cmp", optional = true },
      -- CRITICAL ORDERING: navic must load BEFORE lspconfig attaches LSP clients.
      --
      -- Reason: navic.opts.lsp.auto_attach registers an LspAttach autocmd during
      -- navic's setup(). This handler must be registered BEFORE lspconfig attaches
      -- any clients, otherwise the first buffer will miss breadcrumb attachment.
      --
      -- Mechanism: By declaring navic as a dependency of lspconfig, lazy.nvim
      -- guarantees that navic's config function runs before lspconfig's config.
      -- Both plugins load on the same event (BufReadPre), so dependency order
      -- is the only way to ensure correctness.
      --
      -- Verification: Run `nvim --cmd "let g:debug_plugin_load=1" file.lua` and
      -- check `:LoadOrder` — nvim-navic must appear before nvim-lspconfig.
      { "SmiteshP/nvim-navic" },
    },
    opts = {},
    config = function(_, opts)
      local capabilities = require("util.lsp_capabilities").get()

      local map = vim.keymap.set

      -- LspAttach Autocmd for Keymaps
      -- Use a unique augroup name to avoid conflicts with other plugins
      -- The augroup is created once with clear=true to ensure a clean slate
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("NvimConfig_LspKeymaps", { clear = true }),
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
          -- Note: <leader>lr is mapped to inc-rename.nvim at the top-level (keys table)
          -- This provides a fallback if inc-rename is not loaded
          if not pcall(require, "inc_rename") then
            map("n", "<leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "LSP: Rename symbol" })
          end
          map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "LSP: Code action" })
          map("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "LSP: Show references" })
          map("n", "<leader>lf", function()
            local ok, conform = pcall(require, "conform")
            if ok then
              conform.format { async = true, lsp_fallback = true }
            else
              vim.lsp.buf.format { async = true }
            end
          end, { buffer = ev.buf, desc = "LSP: Format document" })

          -- Diagnostic navigation (vim.diagnostic.jump replaces deprecated goto_prev/goto_next)
          map("n", "[d", function()
            vim.diagnostic.jump { count = -1 }
          end, { buffer = ev.buf, desc = "LSP: Previous diagnostic" })
          map("n", "]d", function()
            vim.diagnostic.jump { count = 1 }
          end, { buffer = ev.buf, desc = "LSP: Next diagnostic" })
          map("n", "<leader>ld", vim.diagnostic.open_float, { buffer = ev.buf, desc = "LSP: Show diagnostics" })
        end,
      })

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

      -- Enable installed servers after all vim.lsp.config() calls above.
      -- mason-lspconfig v2 removed setup_handlers(); get_installed_servers() is
      -- the stable API to enumerate installed servers.
      local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not ok then
        vim.notify("mason-lspconfig not available, skipping server enable", vim.log.levels.WARN)
        return
      end

      if not mason_lspconfig.get_installed_servers then
        vim.notify("mason-lspconfig.get_installed_servers not available", vim.log.levels.ERROR)
        return
      end

      -- rust_analyzer is managed exclusively by rustaceanvim to avoid conflicts
      -- ltex is skipped because grammar checking in markdown is noisy/unhelpful
      local skip = { rust_analyzer = true, ltex = true }
      for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
        if not skip[server_name] then
          vim.lsp.enable(server_name)
        end
      end

      -- IMPORTANT: rust-analyzer is handled exclusively by rustaceanvim
      -- (in lua/plugins/rust.lua). We skip it here to avoid conflicts.
    end,
  },
}
