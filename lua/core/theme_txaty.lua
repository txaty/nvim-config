-- Custom "txaty" theme: Ergonomic, low-fatigue theme for sustained focus
-- Factory pattern with dark and light variants
--
-- Split into three files for maintainability:
--   theme_txaty_colors.lua     — palette definitions (edit colors here)
--   theme_txaty_highlights.lua — highlight group definitions (edit groups here)
--   theme_txaty.lua            — this file: entry point and public API

local M = {}

local palettes = require "core.theme_txaty_colors"
local generate_highlights = require "core.theme_txaty_highlights"

-- Re-export palettes for external access
M.palettes = palettes

-- Export default palette for backward compatibility
M.palette = palettes.dark

-- ============================================================================
-- Theme Application
-- ============================================================================

function M.apply(variant)
  variant = variant or "dark"
  local p = palettes[variant]

  if not p then
    vim.notify("txaty: Unknown variant '" .. variant .. "', using dark", vim.log.levels.WARN)
    variant = "dark"
    p = palettes.dark
  end

  -- Set colorscheme metadata
  vim.g.colors_name = variant == "light" and "txaty-light" or "txaty"
  vim.o.background = variant
  vim.o.termguicolors = true

  -- Apply all highlights
  generate_highlights(p)

  -- Enable syntax and notify plugins
  vim.cmd "syntax on"
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name })
end

-- ============================================================================
-- Public API
-- ============================================================================

-- Get palette for a specific variant
function M.get_palette(variant)
  return palettes[variant or "dark"]
end

return M
