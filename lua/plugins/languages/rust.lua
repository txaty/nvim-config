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
      -- Configure rustaceanvim before plugin loads.
      --
      -- Setting names below are validated against `rust-analyzer
      -- --print-config-schema`. rust-analyzer silently ignores unknown keys, so
      -- a stale name is invisible at runtime — the feature just never turns on.
      -- Several keys here were renamed upstream and have been migrated:
      --   cargo.allFeatures      -> cargo.features = "all"
      --   cargo.runBuildScripts  -> cargo.buildScripts.enable
      --   cargo.loadOutDirMacros -> (removed; covered by buildScripts.enable)
      --   checkOnSave = {table}  -> checkOnSave = <boolean> + check.*
      --   hover.documentation    -> hover.documentation.enable
      --   hover.actions.enabled  -> hover.actions.enable
      --   inlayHints.showParameterNames -> inlayHints.parameterHints.enable
      -- Inlay-hint prefixes/alignment are no longer server settings at all;
      -- rendering is the client's job (`vim.lsp.inlay_hint`).
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
                features = "all", -- Analyze all feature combinations
                buildScripts = {
                  enable = true, -- Run build scripts (build.rs) for accurate analysis
                },
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

              -- Check on save: the flag is a boolean; the command it runs lives
              -- under `check.*`. Passing a table to checkOnSave makes
              -- rust-analyzer reject the whole block, so clippy never ran.
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--all-targets", "--all-features" },
              },

              -- Hover actions
              hover = {
                documentation = { enable = true },
                actions = { enable = true },
              },

              -- Inlay hints
              inlayHints = {
                parameterHints = { enable = true },
                chainingHints = { enable = true },
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

        -- rustaceanvim's own `tools` table. Keys here are rustaceanvim options,
        -- NOT rust-tools.nvim ones — the old `enable_all_diagnostics` and the
        -- `tools.inlay_hints` block were rust-tools leftovers that rustaceanvim
        -- ignores (inlay hints are server settings + vim.lsp.inlay_hint now).
        tools = {
          float_win_config = {
            -- Configuration for floating windows (e.g., hover, method signature)
            border = "rounded",
          },
          enable_clippy = true,
          reload_workspace_from_cargo_toml = true,
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
            -- desc is required, not optional: which-key renders the <leader>C
            -- group from these, and an entry without a desc shows up blank.
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
            end
            map("n", "<leader>Cv", crates.show_versions_popup, "Crates: show versions")
            map("n", "<leader>Cf", crates.show_features_popup, "Crates: show features")
            map("n", "<leader>Cd", crates.show_dependencies_popup, "Crates: show dependencies")
            map("n", "<leader>Cu", crates.upgrade_crate, "Crates: upgrade crate")
            map("v", "<leader>Cu", crates.upgrade_crates, "Crates: upgrade selected crates")
            map("n", "<leader>CA", crates.upgrade_all_crates, "Crates: upgrade all crates")
          end,
        },
      }
    end,
  },
}
