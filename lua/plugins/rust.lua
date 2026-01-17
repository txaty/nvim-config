return {
  -- Treesitter support for Rust and TOML
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "rust", "toml" })
      end
    end,
  },

  -- Ensure Mason tools for Rust
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "rust-analyzer", -- LSP server
        "rustfmt", -- Formatter
        "clippy", -- Linter
        "codelldb", -- Debugger
      })
    end,
  },

  -- Formatting: rustfmt
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.rust = { "rustfmt" }
    end,
  },

  -- Note: Clippy linting is integrated into rust-analyzer via checkOnSave
  -- configuration (see rustaceanvim settings). No separate nvim-lint needed.

  -- PRIMARY: Rustaceanvim - Main Rust language server handler
  -- This manages rust-analyzer lifecycle and configuration exclusively
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig", -- Ensure lspconfig is loaded first
    },
    init = function()
      -- Configure rustaceanvim before plugin loads
      vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          on_attach = function(client, _bufnr)
            -- Let rustaceanvim handle most settings, but we can add custom logic here
            require("cmp_nvim_lsp").default_capabilities(client.server_capabilities)
          end,
          settings = {
            ["rust-analyzer"] = {
              -- Workspace and discovery
              workspace = {
                symbol = {
                  search = {
                    kind = "all_symbols",
                  },
                },
              },

              -- Cargo configuration
              cargo = {
                allFeatures = true, -- Analyze all feature combinations
                loadOutDirMacros = true, -- Load OUT_DIR macros
                runBuildScripts = true, -- Run build scripts (build.rs)
                features = "all", -- Check all features
              },

              -- Proc macro support
              procMacro = {
                enable = true, -- Enable procedural macro expansion
                server = "prefer", -- Prefer server-side macro expansion
              },

              -- Diagnostics
              diagnostics = {
                enable = true,
                disabled = {},
                warningsAsHint = {},
                warningsAsInfo = {},
              },

              -- Check on save
              checkOnSave = {
                enable = true,
                command = "clippy", -- Use clippy instead of check
                extraArgs = { "--all-targets", "--all-features" },
              },

              -- Hover actions
              hover = {
                documentation = true,
                actions = {
                  enabled = true,
                },
              },

              -- Inlay hints
              inlayHints = {
                enable = true,
                showParameterNames = true,
                parameterHintsPrefix = "← ",
                chainingHintsPrefix = "→ ",
              },

              -- Completion
              completion = {
                privateEditable = {
                  enable = false,
                },
              },

              -- Imports
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },

              -- Assist
              assist = {
                emitMustUse = true,
              },
            },
          },
        },

        -- DAP configuration for debugging
        -- Let rustaceanvim handle the default setup, mason-nvim-dap installs codelldb
        dap = {},

        -- Tools (will be configured by rustaceanvim)
        tools = {
          float_win_config = {
            -- Configuration for floating windows (e.g., hover, method signature)
            border = "rounded",
          },
          enable_clippy = true,
          enable_all_diagnostics = true,
          reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "← ",
            other_hints_prefix = "→ ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
        },
      }
    end,
    config = function()
      -- Keymaps specific to Rust
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map("n", "<leader>rr", function()
        vim.cmd.RustRun()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Run" }))

      map("n", "<leader>rR", function()
        vim.cmd.RustRun "release"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Run (release)" }))

      map("n", "<leader>rt", function()
        vim.cmd.RustTest()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Test" }))

      map("n", "<leader>rT", function()
        vim.cmd.RustTest { args = "--release" }
      end, vim.tbl_extend("force", opts, { desc = "Rust: Test (release)" }))

      map("n", "<leader>rc", function()
        vim.cmd.RustCheck()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Check" }))

      map("n", "<leader>rb", function()
        vim.cmd.RustBuild()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Build" }))

      map("n", "<leader>ra", function()
        vim.cmd.RustExpandMacro()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Expand macro" }))

      map("n", "<leader>rx", function()
        vim.cmd.RustExplainError()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Explain error" }))

      map("n", "<leader>rD", function()
        vim.cmd.RustDebuggables()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Debuggables" }))

      map("n", "<leader>rH", function()
        vim.cmd.RustHoverAction()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Hover action" }))

      map("n", "<leader>rl", function()
        vim.cmd.RustLint()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Lint (clippy)" }))

      map("n", "<leader>rd", function()
        vim.cmd.RustToggleInlayHints()
      end, vim.tbl_extend("force", opts, { desc = "Rust: Toggle inlay hints" }))
    end,
  },

  -- Crate management in Cargo.toml
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local crates = require "crates"
      crates.setup {
        -- Use the in-process language server for completion (replaces cmp integration)
        lsp = {
          enabled = true,
          on_attach = function(_client, bufnr)
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = bufnr }
            map("n", "<leader>Cv", crates.show_versions_popup, opts)
            map("n", "<leader>Cf", crates.show_features_popup, opts)
            map("n", "<leader>Cd", crates.show_dependencies_popup, opts)
            map("n", "<leader>Cu", crates.upgrade_crate, opts)
            map("v", "<leader>Cu", crates.upgrade_crates, opts)
            map("n", "<leader>CA", crates.upgrade_all_crates, opts)
          end,
        },
      }
    end,
  },

  -- Testing support
  {
    "nvim-neotest/neotest",
    optional = true, -- Will be loaded by test.lua if neotest is present
    opts = {
      adapters = {
        ["neotest-rust"] = {
          args = { "--all-targets", "--all-features" },
        },
      },
    },
  },
}
