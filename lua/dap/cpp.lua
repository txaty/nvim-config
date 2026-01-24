local dap = require "dap"

local mason_root = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/"
local codelldb_path = mason_root .. "adapter/codelldb"

if not vim.uv.fs_stat(codelldb_path) then
  codelldb_path = "/opt/homebrew/opt/llvm/bin/lldb-vscode"
end

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
  },
  options = {
    detached = false,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.c = dap.configurations.cpp
