-- Session persistence toggle module
-- Persists the `vim.g.enable_session_persistence` flag across restarts.
-- Must be init()'d at require-time, before the lifecycle session step runs.

local M = {}

local persist = require "core.persist"

local config_path = vim.fn.stdpath "data" .. "/session_config.json"
local default = { enabled = true }

--- Read the persisted enabled state.
--- @return boolean
function M.is_enabled()
  local config = persist.load_json(config_path, default)
  return config.enabled ~= false
end

--- Apply the persisted flag to vim.g. Call from core/init.lua so the
--- lifecycle session step and VimLeavePre auto-save see the correct value.
function M.init()
  vim.g.enable_session_persistence = M.is_enabled()
end

local function set(enabled, verb)
  persist.save_json(config_path, { enabled = enabled })
  vim.g.enable_session_persistence = enabled
  local icon = enabled and "✓" or "✗"
  vim.notify(
    string.format("%s Session persistence %s. Takes effect on next startup for auto-restore.", icon, verb),
    vim.log.levels.INFO
  )
end

function M.toggle()
  local new_state = not M.is_enabled()
  set(new_state, new_state and "enabled" or "disabled")
end

function M.enable()
  set(true, "enabled")
end

function M.disable()
  set(false, "disabled")
end

--- @return string
function M.status()
  return M.is_enabled() and "enabled" or "disabled"
end

return M
