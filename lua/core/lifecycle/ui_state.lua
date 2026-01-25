-- UI state lifecycle module
-- Applies UI toggle settings to windows after session restore
local M = {}

--- Initialize UI state from config
function M.init()
  local ok, ui_toggle = pcall(require, "core.ui_toggle")
  if ok then
    ui_toggle.init()
  end
end

--- Apply UI state to all windows
--- Called after session restore to ensure all windows have correct settings
function M.apply_all()
  local ok, ui_toggle = pcall(require, "core.ui_toggle")
  if ok and ui_toggle.apply_all then
    ui_toggle.apply_all()
  end
end

--- Apply UI state to current window
function M.apply()
  local ok, ui_toggle = pcall(require, "core.ui_toggle")
  if ok and ui_toggle.apply then
    ui_toggle.apply()
  end
end

return M
