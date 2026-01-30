-- Flutter/Dart language support
local lang_toggle = require "core.lang_toggle"
if not lang_toggle.is_enabled "flutter" then
  return {}
end

local lang = require "core.lang_utils"

return {
  -- Extend treesitter with Dart parser
  lang.extend_treesitter { "dart" },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Recommended for UI
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup {
        ui = {
          border = "rounded",
          notification_style = "plugin",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          register_configurations = function(paths)
            local dap = require "dap"
            dap.configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter",
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        lsp = {
          -- on_attach handled by LspAttach autocmd
          capabilities = (function()
            local caps = vim.lsp.protocol.make_client_capabilities()
            local ok, blink = pcall(require, "blink.cmp")
            if ok then
              caps = blink.get_lsp_capabilities(caps)
            end
            return caps
          end)(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand "$HOME/.pub-cache",
              vim.fn.expand "/opt/homebrew/",
              vim.fn.expand "$HOME/snap/",
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>FR", "<cmd>FlutterRun<cr>", desc = "Flutter: Run app" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: Quit app" },
      { "<leader>Fr", "<cmd>FlutterRestart<cr>", desc = "Flutter: Hot restart" },
      { "<leader>Fl", "<cmd>FlutterReload<cr>", desc = "Flutter: Hot reload" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: Select device" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: Launch emulator" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: Toggle outline" },
      { "<leader>FL", "<cmd>FlutterLogToggle<cr>", desc = "Flutter: Toggle logs" },
    },
  },
}
