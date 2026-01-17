return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Signs
      local signs = {
        DapBreakpoint = { text = "B", texthl = "DiagnosticError", linehl = "", numhl = "" },
        DapStopped = { text = ">", texthl = "DiagnosticWarn", linehl = "DiffChange", numhl = "" },
        DapBreakpointRejected = { text = "x", texthl = "DiagnosticInfo", linehl = "", numhl = "" },
      }

      for name, sign in pairs(signs) do
        vim.fn.sign_define(name, sign)
      end

      -- DAP UI Setup
      dapui.setup {
        floating = { border = "rounded" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.60 },
              { id = "stacks", size = 0.20 },
              { id = "watches", size = 0.20 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 12,
          },
        },
      }

      -- Listeners
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

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end, { desc = "Conditional breakpoint" })
      map("n", "<leader>dc", dap.continue, { desc = "Continue / run" })
      map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
      map("n", "<leader>di", dap.step_into, { desc = "Step into" })
      map("n", "<leader>do", dap.step_over, { desc = "Step over" })
      map("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      map("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
      map("n", "<leader>dx", function()
        dap.terminate()
        dapui.close()
      end, { desc = "Terminate" })

      -- Preload cpp if available (optional)
      pcall(require, "dap.cpp")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "codelldb", "python", "js-debug-adapter", "delve" },
      automatic_installation = true,
    },
  },
}
