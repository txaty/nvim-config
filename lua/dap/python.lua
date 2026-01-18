-- Python DAP configuration
-- This sets up debugpy for Python debugging
-- Note: This is called from lua/plugins/python.lua (venv-selector config)

local M = {}

function M.setup()
  -- Setup DAP with debugpy installed by mason
  local mason_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
  local python_path = vim.uv.fs_stat(mason_path) and mason_path or "python3"

  -- We use pcall just in case dap-python isn't loaded yet,
  -- though the dependency chain should ensure it.
  pcall(function()
    require("dap-python").setup(python_path)
  end)
end

return M
