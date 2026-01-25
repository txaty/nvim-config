-- UI toggle module with session-based persistence
-- Stores state in vim.g.ui_* globals which are saved/restored via persistence.nvim
local M = {}

-- Default states (used when no session exists)
local defaults = {
  wrap = false,
  spell = false,
  number = true,
  relativenumber = true,
  conceallevel = 2,
}

-- Throttle apply() calls to avoid excessive work during rapid window operations
local last_apply_time = 0
local APPLY_THROTTLE_MS = 50 -- Minimum ms between apply() calls

--- Initialize UI state from globals or defaults
function M.init()
  for opt, default in pairs(defaults) do
    local global_key = "ui_" .. opt
    if vim.g[global_key] == nil then
      vim.g[global_key] = default
    end
  end
end

--- Apply current UI state to a window (throttled to avoid excessive calls)
---@param win? number Window handle (0 for current window)
function M.apply(win)
  -- Throttle rapid calls (e.g., during session restore with many windows)
  local now = vim.uv.now()
  if now - last_apply_time < APPLY_THROTTLE_MS then
    return
  end
  last_apply_time = now

  win = win or 0
  vim.wo[win].wrap = vim.g.ui_wrap
  vim.wo[win].spell = vim.g.ui_spell
  vim.wo[win].number = vim.g.ui_number
  vim.wo[win].relativenumber = vim.g.ui_relativenumber
  vim.wo[win].conceallevel = vim.g.ui_conceallevel
end

--- Toggle a UI option
---@param opt string Option name (wrap, spell, number, relativenumber, conceallevel)
function M.toggle(opt)
  local global_key = "ui_" .. opt
  local current = vim.g[global_key]

  if opt == "conceallevel" then
    -- Toggle between 0 and 2
    vim.g[global_key] = current == 0 and 2 or 0
  else
    -- Boolean toggle
    vim.g[global_key] = not current
  end

  -- Apply to current window
  vim.wo[opt] = vim.g[global_key]

  -- Notify user
  local display = vim.g[global_key]
  if type(display) == "boolean" then
    display = display and "ON" or "OFF"
  end
  vim.notify(opt .. ": " .. tostring(display))
end

--- Get current state of an option
---@param opt string Option name
---@return any
function M.get(opt)
  return vim.g["ui_" .. opt]
end

return M
