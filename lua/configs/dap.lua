local M = {}

local function safe_require(module)
  local ok, value = pcall(require, module)
  if ok then
    return value
  end
end

local function define_signs()
  local signs = {
    DapBreakpoint = { text = "B", texthl = "DiagnosticError", linehl = "", numhl = "" },
    DapStopped = { text = ">", texthl = "DiagnosticWarn", linehl = "DiffChange", numhl = "" },
    DapBreakpointRejected = { text = "x", texthl = "DiagnosticInfo", linehl = "", numhl = "" },
  }

  for name, sign in pairs(signs) do
    vim.fn.sign_define(name, sign)
  end
end

local function setup_keymaps()
  local dap = require "dap"
  local dapui = require "dapui"
  local wk = safe_require "which-key"

  local entries = {
    { "<leader>d", group = "Debug" },
    { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
    {
      "<leader>dB",
      function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Conditional breakpoint",
    },
    { "<leader>dc", dap.continue, desc = "Continue / run" },
    { "<leader>dl", dap.run_last, desc = "Run last" },
    { "<leader>di", dap.step_into, desc = "Step into" },
    { "<leader>do", dap.step_over, desc = "Step over" },
    { "<leader>dO", dap.step_out, desc = "Step out" },
    { "<leader>dr", dap.repl.toggle, desc = "Toggle REPL" },
    { "<leader>du", dapui.toggle, desc = "Toggle UI" },
    {
      "<leader>dx",
      function()
        dap.terminate()
        dapui.close()
      end,
      desc = "Terminate",
    },
  }

  for _, map in ipairs(entries) do
    if not map.group then
      vim.keymap.set("n", map[1], map[2], { desc = map.desc })
    end
  end

  if wk then
    wk.add(entries, { mode = "n" })
  end
end

function M.setup()
  local dap = require "dap"
  local dapui = require "dapui"

  define_signs()

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

  setup_keymaps()

  -- Preload adapters that have static configuration files.
  safe_require "dap.cpp"
end

return M
