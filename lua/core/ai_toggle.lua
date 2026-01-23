-- AI feature toggle module
-- Manages AI plugin loading state with persistence across sessions
-- Similar to Zed's "Disable AI" feature

local M = {}

-- Path to store AI toggle state
local config_path = vim.fn.stdpath "data" .. "/ai_config.json"

--- Check if AI features are enabled
--- @return boolean true if AI is enabled, false otherwise
function M.is_enabled()
  local ok, content = pcall(vim.fn.readfile, config_path)
  if not ok then
    return true -- Default: AI enabled
  end

  local ok2, config = pcall(vim.json.decode, table.concat(content, "\n"))
  if not ok2 then
    return true -- Fallback to enabled on parse error
  end

  return config.enabled ~= false
end

--- Toggle AI features on/off
function M.toggle()
  local current = M.is_enabled()
  local new_state = not current

  local config = { enabled = new_state }
  local encoded = vim.json.encode(config)
  vim.fn.writefile({ encoded }, config_path)

  local status = new_state and "enabled" or "disabled"
  local icon = new_state and "✓" or "✗"
  vim.notify(string.format("%s AI features %s. Restart Neovim to apply changes.", icon, status), vim.log.levels.INFO)
end

--- Explicitly enable AI features
function M.enable()
  vim.fn.writefile({ vim.json.encode { enabled = true } }, config_path)
  vim.notify("✓ AI features enabled. Restart Neovim to apply changes.", vim.log.levels.INFO)
end

--- Explicitly disable AI features
function M.disable()
  vim.fn.writefile({ vim.json.encode { enabled = false } }, config_path)
  vim.notify("✗ AI features disabled. Restart Neovim to apply changes.", vim.log.levels.INFO)
end

--- Get current status as a string
--- @return string "enabled" or "disabled"
function M.status()
  return M.is_enabled() and "enabled" or "disabled"
end

return M
