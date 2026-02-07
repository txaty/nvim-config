-- Rust language support
local lang_toggle = require "core.lang_toggle"
if not lang_toggle.is_enabled "rust" then
  return {}
end

local lang = require "util.lang_utils"

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
      -- Uses rustaceanvim's :RustLsp command API (not deprecated rust-tools.nvim commands)
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Run/Build operations
      map("n", "<leader>Rr", function()
        vim.cmd.RustLsp "runnables"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Runnables" }))
      map("n", "<leader>RR", function()
        vim.cmd.RustLsp { "runnables", bang = true }
      end, vim.tbl_extend("force", opts, { desc = "Rust: Rerun last" }))
      map("n", "<leader>Rt", function()
        vim.cmd.RustLsp "testables"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Testables" }))
      map("n", "<leader>RT", function()
        vim.cmd.RustLsp { "testables", bang = true }
      end, vim.tbl_extend("force", opts, { desc = "Rust: Rerun last test" }))

      -- Analysis/Debugging
      map("n", "<leader>Ra", function()
        vim.cmd.RustLsp "expandMacro"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Expand macro" }))
      map("n", "<leader>Rx", function()
        vim.cmd.RustLsp "explainError"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Explain error" }))
      map("n", "<leader>RD", function()
        vim.cmd.RustLsp "debuggables"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Debuggables" }))
      map("n", "<leader>Rd", function()
        vim.cmd.RustLsp "debug"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Debug target" }))
      map("n", "<leader>RH", function()
        vim.cmd.RustLsp { "hover", "actions" }
      end, vim.tbl_extend("force", opts, { desc = "Rust: Hover actions" }))
      map("n", "<leader>Rc", function()
        vim.cmd.RustLsp "openCargo"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Open Cargo.toml" }))
      map("n", "<leader>Rp", function()
        vim.cmd.RustLsp "parentModule"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Parent module" }))
      map("n", "<leader>Rj", function()
        vim.cmd.RustLsp "joinLines"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Join lines" }))
      map("n", "<leader>RS", function()
        vim.cmd.RustLsp "ssr"
      end, vim.tbl_extend("force", opts, { desc = "Rust: Structural search/replace" }))

      -- Symbol Discovery: workspace-wide search
      map("n", "<leader>Rw", function()
        local snacks_ok, Snacks = pcall(require, "snacks")
        if not snacks_ok then
          vim.notify("Snacks picker not available", vim.log.levels.WARN)
          return
        end
        Snacks.picker.lsp_workspace_symbols {
          title = "Rust Symbols (Workspace)",
        }
      end, vim.tbl_extend("force", opts, { desc = "Rust: Workspace symbols" }))
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
