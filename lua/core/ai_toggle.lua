-- AI feature toggle module
-- Manages AI plugin loading state with persistence across sessions
-- Similar to Zed's "Disable AI" feature

local M = {}

local persist = require "core.persist"

-- Path to store AI toggle state
local config_path = vim.fn.stdpath "data" .. "/ai_config.json"

-- Initialize cache immediately at module load
persist.load_json(config_path, { enabled = true })

--- Check if AI features are enabled
--- @return boolean true if AI is enabled, false otherwise
function M.is_enabled()
  local config = persist.load_json(config_path, { enabled = true })
  return config.enabled ~= false
end

--- Toggle AI features on/off
function M.toggle()
  local current = M.is_enabled()
  local new_state = not current

  persist.save_json(config_path, { enabled = new_state })

  local status = new_state and "enabled" or "disabled"
  local icon = new_state and "✓" or "✗"
  vim.notify(string.format("%s AI features %s. Restart Neovim to apply changes.", icon, status), vim.log.levels.INFO)
end

--- Explicitly enable AI features
function M.enable()
  persist.save_json(config_path, { enabled = true })
  vim.notify("✓ AI features enabled. Restart Neovim to apply changes.", vim.log.levels.INFO)
end

--- Explicitly disable AI features
function M.disable()
  persist.save_json(config_path, { enabled = false })
  vim.notify("✗ AI features disabled. Restart Neovim to apply changes.", vim.log.levels.INFO)
end

--- Get current status as a string
--- @return string "enabled" or "disabled"
function M.status()
  return M.is_enabled() and "enabled" or "disabled"
end

return M
