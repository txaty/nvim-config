local options = {
  ui = {
    -- Re-use your trouble config if trouble is installed
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
    on_attach = require("nvchad.configs.lspconfig").on_attach,
    capabilities = require("nvchad.configs.lspconfig").capabilities,
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

return options
