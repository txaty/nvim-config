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

  -- Suppress the ColorScheme autocmd from re-saving during restore.
  -- Without this, vim.cmd.colorscheme() fires the autocmd in autocmds.lua
  -- which calls theme.save_theme() — writing the already-saved value back.
  local prev_previewing = theme._previewing
  theme._previewing = true

  local saved_theme = theme.load_saved_theme()
  local success = false
  if saved_theme then
    success = pcall(theme.restore_theme) == true
  end

  if not success then
    pcall(theme.apply, DEFAULT_THEME, { save = false, notify = false })
  end

  theme._previewing = prev_previewing
  return success
end

return M
