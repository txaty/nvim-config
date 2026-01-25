-- Colorscheme restoration lifecycle module
-- Handles theme restoration at startup (before UI plugins render)
local M = {}

local DEFAULT_THEME = "catppuccin"

--- Restore saved colorscheme or apply default
--- Called synchronously before session restore to ensure UI consistency
function M.restore()
  local ok, theme = pcall(require, "core.theme")
  if not ok then
    -- Fallback if theme module fails to load
    pcall(vim.cmd.colorscheme, DEFAULT_THEME)
    return false
  end

  local saved_theme = theme.load_saved_theme()
  if saved_theme then
    -- Restore saved theme without re-saving (avoid circular save)
    local success = pcall(theme.restore_theme)
    if success then
      return true
    end
  end

  -- Apply default theme
  pcall(theme.apply_theme, DEFAULT_THEME)
  return false
end

return M
