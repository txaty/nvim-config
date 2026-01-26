-- Command registry
-- Registers all user commands after plugins are ready
local M = {}

local command_modules = {
  "core.commands.ai",
  "core.commands.lang",
  "core.commands.cleanup",
  "core.commands.ui",
}

--- Register all user commands
function M.register_all()
  for _, mod_name in ipairs(command_modules) do
    local ok, mod = pcall(require, mod_name)
    if ok and mod.register then
      mod.register()
    end
  end
end

return M
