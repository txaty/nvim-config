local dap = require "dap"

-- dap-vscode-js is configured in plugins/dap.lua via opts
-- This file only defines the configurations

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
