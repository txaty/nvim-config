return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Recommended for UI
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup({
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
            local dap = require("dap")
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
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand("$HOME/.pub-cache"),
              vim.fn.expand("/opt/homebrew/"),
              vim.fn.expand("$HOME/snap/"),
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>cF", "<cmd>FlutterRun<cr>", desc = "Flutter: run" },
      { "<leader>cq", "<cmd>FlutterQuit<cr>", desc = "Flutter: quit" },
      { "<leader>cr", "<cmd>FlutterRestart<cr>", desc = "Flutter: hot restart" },
      { "<leader>cR", "<cmd>FlutterReload<cr>", desc = "Flutter: hot reload" },
      { "<leader>cd", "<cmd>FlutterDevices<cr>", desc = "Flutter: devices" },
      { "<leader>ce", "<cmd>FlutterEmulators<cr>", desc = "Flutter: emulators" },
      { "<leader>co", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: outline" },
      { "<leader>cl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter: log" },
    },
  },
}
