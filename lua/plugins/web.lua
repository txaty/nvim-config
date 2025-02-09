local function is_web_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. "/package.json") == 1 or vim.fn.filereadable(cwd .. "/tsconfig.json") == 1
end

return {
  {
    "windwp/nvim-ts-autotag",
    cond = is_web_project,
    config = function()
      require("nvim-ts-autotag").setup {}
    end,
  },

  -- Prettier for formatting
  {
    "MunifTanjim/prettier.nvim",
    cond = is_web_project,
    config = function()
      require("prettier").setup {
        bin = "prettier",
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "css", "html", "json" },
      }
    end,
  },

  -- Colorizer for inline CSS/JSX color preview
  {
    "norcalli/nvim-colorizer.lua",
    cond = is_web_project,
    config = function()
      require("colorizer").setup()
    end,
  },

  -- DAP for JS/TS debugging (vscode-js adapter)
  {
    "mfussenegger/nvim-dap",
    cond = is_web_project,
    dependencies = { "mxsdev/nvim-dap-vscode-js" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      require("dap-vscode-js").setup {
        adapters = { "node", "chrome", "pwa-node" },
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Node",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Process",
          processId = require("dap.utils").pick_process,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript
    end,
  },
}
