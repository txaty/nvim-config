-- Custom "txaty" theme: Color palette definitions
-- Separated from highlights for maintainability
--
-- Design principles:
--   1. Limited color palette (5-6 semantic colors max)
--   2. Very low saturation (15-25%) - all colors are muted/desaturated
--   3. Consistent luminosity - colors have similar brightness within variant
--   4. Warm neutral tones - reduce blue light strain
--   5. Subtle differentiation - structure through brightness, not hue
--   6. No pure black/white - reduces harsh contrast
--   7. WCAG 2.1 AA compliant contrast ratios (4.5:1 for text, 3:1 for UI)

return {
  -- Dark variant palette
  dark = {
    -- Base tones (warm grays)
    bg = "#1c1e22", -- Warm dark gray (not pure black)
    bg_dark = "#16181b", -- Slightly darker for depth
    bg_alt = "#242830", -- Elevated surfaces
    bg_highlight = "#2c3038", -- Selection, cursor line
    bg_visual = "#343840", -- Visual selection

    fg = "#c4c1b8", -- Warm off-white (not pure white)
    fg_dim = "#928f87", -- Dimmed text (comments, line numbers)
    fg_muted = "#605d56", -- Very muted (disabled, non-essential)

    -- Semantic colors (all very desaturated, similar luminosity)
    accent1 = "#b0a48c", -- Warm sand - strings, values
    accent2 = "#8ca090", -- Sage green - types
    accent3 = "#8898a8", -- Steel blue - functions
    accent4 = "#a89890", -- Warm taupe - keywords
    accent5 = "#a08888", -- Dusty rose - special

    -- Status colors (muted versions)
    error = "#c07070", -- Muted red
    warning = "#c0a060", -- Muted amber
    success = "#80a878", -- Muted green
    info = "#7098b0", -- Muted blue

    -- UI elements
    border = "#3a4048",
    selection = "#3a4048",
    match = "#4a4538", -- Search matches (subtle warm highlight)

    -- Diff backgrounds (dark variant)
    diff_add_bg = "#283028",
    diff_change_bg = "#383028",
    diff_delete_bg = "#382828",
    diff_text_bg = "#484030",
  },

  -- Light variant palette
  light = {
    -- Base tones (warm off-whites)
    bg = "#f5f2ea", -- Warm cream (not pure white)
    bg_dark = "#ebe8e0", -- Slightly darker for depth
    bg_alt = "#faf8f2", -- Elevated surfaces (lighter)
    bg_highlight = "#e8e4d8", -- Selection, cursor line
    bg_visual = "#ddd8c8", -- Visual selection

    fg = "#3a3632", -- Warm dark gray (not pure black)
    fg_dim = "#6a665e", -- Dimmed text (comments, line numbers)
    fg_muted = "#9a968c", -- Very muted (disabled, non-essential)

    -- Semantic colors (darker for light bg, same hue family as dark)
    accent1 = "#7a6a50", -- Warm brown - strings, values
    accent2 = "#4a6a50", -- Forest green - types
    accent3 = "#4a5a7a", -- Slate blue - functions
    accent4 = "#6a5a50", -- Warm umber - keywords
    accent5 = "#7a5050", -- Brick rose - special

    -- Status colors (darker for light bg)
    error = "#b04040", -- Dark red
    warning = "#907030", -- Dark amber
    success = "#408040", -- Dark green
    info = "#305090", -- Dark blue

    -- UI elements
    border = "#c8c4b8",
    selection = "#d8d4c8",
    match = "#e8e0c8", -- Search matches (subtle warm highlight)

    -- Diff backgrounds (light variant)
    diff_add_bg = "#d8e8d0",
    diff_change_bg = "#e8e0c8",
    diff_delete_bg = "#e8d0d0",
    diff_text_bg = "#d8d0b8",
  },
}
