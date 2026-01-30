-- Rust language support
local lang_toggle = require "core.lang_toggle"
if not lang_toggle.is_enabled "rust" then
  return {}
end

local lang = require "core.lang_utils"

return {
  lang.extend_treesitter { "rust", "toml" },
  lang.extend_mason { "rust-analyzer", "rustfmt", "clippy", "codelldb" },
  lang.extend_conform { rust = { "rustfmt" } },

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
      -- Keymaps specific to Rust (use <leader>R to avoid conflict with Remote <leader>r)
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      map("n", "<leader>Rr", "<cmd>RustRun<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Run" }))
      map(
        "n",
        "<leader>RR",
        "<cmd>RustRun release<cr>",
        vim.tbl_extend("force", opts, { desc = "Rust: Run (release)" })
      )
      map("n", "<leader>Rt", "<cmd>RustTest<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Test" }))
      map("n", "<leader>RT", function()
        vim.cmd.RustTest { args = "--release" }
      end, vim.tbl_extend("force", opts, { desc = "Rust: Test (release)" }))
      map("n", "<leader>Rc", "<cmd>RustCheck<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Check" }))
      map("n", "<leader>Rb", "<cmd>RustBuild<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Build" }))
      map("n", "<leader>Ra", "<cmd>RustExpandMacro<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Expand macro" }))
      map(
        "n",
        "<leader>Rx",
        "<cmd>RustExplainError<cr>",
        vim.tbl_extend("force", opts, { desc = "Rust: Explain error" })
      )
      map("n", "<leader>RD", "<cmd>RustDebuggables<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Debuggables" }))
      map("n", "<leader>RH", "<cmd>RustHoverAction<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Hover action" }))
      map("n", "<leader>Rl", "<cmd>RustLint<cr>", vim.tbl_extend("force", opts, { desc = "Rust: Lint (clippy)" }))
      map(
        "n",
        "<leader>Rd",
        "<cmd>RustToggleInlayHints<cr>",
        vim.tbl_extend("force", opts, { desc = "Rust: Toggle inlay hints" })
      )
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
}
