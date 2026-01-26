-- Custom "txaty" theme: Ergonomic, low-fatigue theme for sustained focus
-- Factory pattern with dark and light variants
--
-- Design principles:
--   1. Limited color palette (5-6 semantic colors max)
--   2. Very low saturation (15-25%) - all colors are muted/desaturated
--   3. Consistent luminosity - colors have similar brightness within variant
--   4. Warm neutral tones - reduce blue light strain
--   5. Subtle differentiation - structure through brightness, not hue
--   6. No pure black/white - reduces harsh contrast
--   7. WCAG 2.1 AA compliant contrast ratios (4.5:1 for text, 3:1 for UI)

local M = {}

-- ============================================================================
-- Dual Palette Definitions
-- ============================================================================

M.palettes = {
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

-- ============================================================================
-- Highlight Generator (Factory Function)
-- ============================================================================

local function generate_highlights(p)
  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- ==========================================================================
  -- Editor UI (~30 groups)
  -- ==========================================================================
  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalFloat", { fg = p.fg, bg = p.bg_alt })
  hl("NormalNC", { fg = p.fg_dim, bg = p.bg })
  hl("FloatBorder", { fg = p.border, bg = p.bg_alt })
  hl("FloatTitle", { fg = p.fg, bg = p.bg_alt, bold = true })

  hl("Cursor", { fg = p.bg, bg = p.fg })
  hl("CursorLine", { bg = p.bg_highlight })
  hl("CursorColumn", { bg = p.bg_highlight })
  hl("CursorLineNr", { fg = p.fg, bg = p.bg_highlight })
  hl("LineNr", { fg = p.fg_muted })
  hl("SignColumn", { bg = p.bg })
  hl("FoldColumn", { fg = p.fg_muted, bg = p.bg })
  hl("Folded", { fg = p.fg_dim, bg = p.bg_dark })

  hl("VertSplit", { fg = p.border })
  hl("WinSeparator", { fg = p.border })
  hl("StatusLine", { fg = p.fg, bg = p.bg_alt })
  hl("StatusLineNC", { fg = p.fg_muted, bg = p.bg_dark })
  hl("TabLine", { fg = p.fg_dim, bg = p.bg_dark })
  hl("TabLineFill", { bg = p.bg_dark })
  hl("TabLineSel", { fg = p.fg, bg = p.bg, bold = true })

  -- Search and selection
  hl("Search", { fg = p.fg, bg = p.match })
  hl("IncSearch", { fg = p.bg, bg = p.accent1 })
  hl("CurSearch", { fg = p.bg, bg = p.accent1, bold = true })
  hl("Visual", { bg = p.bg_visual })
  hl("VisualNOS", { bg = p.bg_visual })

  -- Popup menu
  hl("Pmenu", { fg = p.fg, bg = p.bg_alt })
  hl("PmenuSel", { fg = p.fg, bg = p.bg_highlight, bold = true })
  hl("PmenuSbar", { bg = p.bg_dark })
  hl("PmenuThumb", { bg = p.border })

  -- Messages
  hl("ErrorMsg", { fg = p.error })
  hl("WarningMsg", { fg = p.warning })
  hl("MoreMsg", { fg = p.accent2 })
  hl("ModeMsg", { fg = p.fg_dim })
  hl("Question", { fg = p.accent3 })

  -- Misc UI
  hl("MatchParen", { fg = p.fg, bg = p.bg_highlight, bold = true })
  hl("NonText", { fg = p.fg_muted })
  hl("Whitespace", { fg = p.fg_muted })
  hl("EndOfBuffer", { fg = p.fg_muted })
  hl("SpecialKey", { fg = p.fg_muted })
  hl("Directory", { fg = p.accent3 })
  hl("Title", { fg = p.fg, bold = true })
  hl("Conceal", { fg = p.fg_dim })
  hl("ColorColumn", { bg = p.bg_highlight })

  -- ==========================================================================
  -- Syntax (~25 groups)
  -- ==========================================================================
  hl("Comment", { fg = p.fg_dim, italic = true })
  hl("Constant", { fg = p.accent1 })
  hl("String", { fg = p.accent1 })
  hl("Character", { fg = p.accent1 })
  hl("Number", { fg = p.accent1 })
  hl("Boolean", { fg = p.accent1 })
  hl("Float", { fg = p.accent1 })

  hl("Identifier", { fg = p.fg })
  hl("Function", { fg = p.accent3 })

  hl("Statement", { fg = p.accent4 })
  hl("Conditional", { fg = p.accent4 })
  hl("Repeat", { fg = p.accent4 })
  hl("Label", { fg = p.accent4 })
  hl("Operator", { fg = p.fg_dim })
  hl("Keyword", { fg = p.accent4 })
  hl("Exception", { fg = p.accent4 })

  hl("PreProc", { fg = p.accent4 })
  hl("Include", { fg = p.accent4 })
  hl("Define", { fg = p.accent4 })
  hl("Macro", { fg = p.accent4 })
  hl("PreCondit", { fg = p.accent4 })

  hl("Type", { fg = p.accent2 })
  hl("StorageClass", { fg = p.accent4 })
  hl("Structure", { fg = p.accent2 })
  hl("Typedef", { fg = p.accent2 })

  hl("Special", { fg = p.accent5 })
  hl("SpecialChar", { fg = p.accent5 })
  hl("Tag", { fg = p.accent3 })
  hl("Delimiter", { fg = p.fg_dim })
  hl("SpecialComment", { fg = p.fg_dim, italic = true })
  hl("Debug", { fg = p.accent5 })

  hl("Underlined", { fg = p.accent3, underline = true })
  hl("Error", { fg = p.error })
  hl("Todo", { fg = p.warning, bold = true })

  -- ==========================================================================
  -- Treesitter (~50 groups)
  -- ==========================================================================
  hl("@comment", { link = "Comment" })
  hl("@comment.documentation", { fg = p.fg_dim, italic = true })
  hl("@comment.error", { fg = p.error, italic = true })
  hl("@comment.warning", { fg = p.warning, italic = true })
  hl("@comment.todo", { fg = p.info, bold = true })
  hl("@comment.note", { fg = p.success, italic = true })

  hl("@constant", { link = "Constant" })
  hl("@constant.builtin", { fg = p.accent1 })
  hl("@constant.macro", { fg = p.accent1 })

  hl("@string", { link = "String" })
  hl("@string.escape", { fg = p.accent5 })
  hl("@string.special", { fg = p.accent5 })
  hl("@string.regex", { fg = p.accent5 })
  hl("@string.special.url", { fg = p.accent3, underline = true })
  hl("@string.special.path", { fg = p.accent1 })

  hl("@character", { link = "Character" })
  hl("@character.special", { fg = p.accent5 })
  hl("@number", { link = "Number" })
  hl("@number.float", { link = "Float" })
  hl("@boolean", { link = "Boolean" })
  hl("@float", { link = "Float" })

  hl("@function", { link = "Function" })
  hl("@function.builtin", { fg = p.accent3 })
  hl("@function.macro", { fg = p.accent3 })
  hl("@function.method", { fg = p.accent3 })
  hl("@function.call", { fg = p.accent3 })
  hl("@method", { fg = p.accent3 })
  hl("@method.call", { fg = p.accent3 })

  hl("@constructor", { fg = p.accent2 })
  hl("@parameter", { fg = p.fg })

  hl("@keyword", { link = "Keyword" })
  hl("@keyword.function", { fg = p.accent4 })
  hl("@keyword.operator", { fg = p.fg_dim })
  hl("@keyword.return", { fg = p.accent4 })
  hl("@keyword.import", { fg = p.accent4 })
  hl("@keyword.export", { fg = p.accent4 })
  hl("@keyword.coroutine", { fg = p.accent4 })
  hl("@keyword.conditional", { fg = p.accent4 })
  hl("@keyword.repeat", { fg = p.accent4 })
  hl("@keyword.exception", { fg = p.accent4 })

  hl("@conditional", { link = "Conditional" })
  hl("@repeat", { link = "Repeat" })
  hl("@label", { link = "Label" })
  hl("@operator", { link = "Operator" })
  hl("@exception", { link = "Exception" })

  hl("@variable", { fg = p.fg })
  hl("@variable.builtin", { fg = p.accent1 })
  hl("@variable.parameter", { fg = p.fg })
  hl("@variable.member", { fg = p.fg })

  hl("@type", { link = "Type" })
  hl("@type.builtin", { fg = p.accent2 })
  hl("@type.definition", { fg = p.accent2 })
  hl("@type.qualifier", { fg = p.accent4 })

  hl("@storageclass", { link = "StorageClass" })
  hl("@attribute", { fg = p.accent4 })
  hl("@attribute.builtin", { fg = p.accent4 })
  hl("@property", { fg = p.fg })
  hl("@field", { fg = p.fg })

  hl("@namespace", { fg = p.fg_dim })
  hl("@module", { fg = p.fg_dim })
  hl("@module.builtin", { fg = p.fg_dim })
  hl("@include", { link = "Include" })

  hl("@punctuation", { fg = p.fg_dim })
  hl("@punctuation.bracket", { fg = p.fg_dim })
  hl("@punctuation.delimiter", { fg = p.fg_dim })
  hl("@punctuation.special", { fg = p.accent5 })

  hl("@tag", { fg = p.accent3 })
  hl("@tag.attribute", { fg = p.fg })
  hl("@tag.delimiter", { fg = p.fg_dim })
  hl("@tag.builtin", { fg = p.accent3 })

  hl("@text", { fg = p.fg })
  hl("@text.strong", { bold = true })
  hl("@text.emphasis", { italic = true })
  hl("@text.underline", { underline = true })
  hl("@text.strike", { strikethrough = true })
  hl("@text.title", { fg = p.fg, bold = true })
  hl("@text.uri", { fg = p.accent3, underline = true })
  hl("@text.todo", { fg = p.warning, bold = true })
  hl("@text.note", { fg = p.info })
  hl("@text.warning", { fg = p.warning })
  hl("@text.danger", { fg = p.error })
  hl("@text.literal", { fg = p.accent1 })
  hl("@text.reference", { fg = p.accent3 })
  hl("@text.diff.add", { fg = p.success })
  hl("@text.diff.delete", { fg = p.error })

  -- New treesitter captures (nvim 0.9+)
  hl("@markup", { fg = p.fg })
  hl("@markup.heading", { fg = p.fg, bold = true })
  hl("@markup.heading.1", { fg = p.fg, bold = true })
  hl("@markup.heading.2", { fg = p.fg, bold = true })
  hl("@markup.heading.3", { fg = p.fg, bold = true })
  hl("@markup.heading.4", { fg = p.fg, bold = true })
  hl("@markup.heading.5", { fg = p.fg, bold = true })
  hl("@markup.heading.6", { fg = p.fg, bold = true })
  hl("@markup.strong", { bold = true })
  hl("@markup.italic", { italic = true })
  hl("@markup.strikethrough", { strikethrough = true })
  hl("@markup.underline", { underline = true })
  hl("@markup.link", { fg = p.accent3 })
  hl("@markup.link.url", { fg = p.accent3, underline = true })
  hl("@markup.link.label", { fg = p.accent3 })
  hl("@markup.raw", { fg = p.accent1 })
  hl("@markup.raw.block", { fg = p.accent1 })
  hl("@markup.list", { fg = p.accent3 })
  hl("@markup.list.checked", { fg = p.success })
  hl("@markup.list.unchecked", { fg = p.fg_dim })
  hl("@markup.quote", { fg = p.fg_dim, italic = true })
  hl("@markup.math", { fg = p.accent1 })
  hl("@markup.environment", { fg = p.accent4 })

  hl("@diff.plus", { fg = p.success })
  hl("@diff.minus", { fg = p.error })
  hl("@diff.delta", { fg = p.warning })

  -- ==========================================================================
  -- LSP Semantic Tokens (~15 groups)
  -- ==========================================================================
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.decorator", { link = "@attribute" })
  hl("@lsp.type.enum", { link = "@type" })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.interface", { link = "@type" })
  hl("@lsp.type.macro", { link = "@constant.macro" })
  hl("@lsp.type.method", { link = "@method" })
  hl("@lsp.type.namespace", { link = "@namespace" })
  hl("@lsp.type.parameter", { link = "@parameter" })
  hl("@lsp.type.property", { link = "@property" })
  hl("@lsp.type.struct", { link = "@type" })
  hl("@lsp.type.type", { link = "@type" })
  hl("@lsp.type.typeParameter", { link = "@type" })
  hl("@lsp.type.variable", { link = "@variable" })
  hl("@lsp.type.comment", { link = "@comment" })
  hl("@lsp.type.string", { link = "@string" })
  hl("@lsp.type.keyword", { link = "@keyword" })
  hl("@lsp.type.number", { link = "@number" })
  hl("@lsp.type.regexp", { link = "@string.regex" })
  hl("@lsp.type.operator", { link = "@operator" })

  hl("@lsp.mod.deprecated", { strikethrough = true })
  hl("@lsp.mod.readonly", { italic = true })
  hl("@lsp.mod.defaultLibrary", { fg = p.accent3 })

  -- ==========================================================================
  -- Diagnostics (~20 groups)
  -- ==========================================================================
  hl("DiagnosticError", { fg = p.error })
  hl("DiagnosticWarn", { fg = p.warning })
  hl("DiagnosticInfo", { fg = p.info })
  hl("DiagnosticHint", { fg = p.fg_dim })
  hl("DiagnosticOk", { fg = p.success })

  hl("DiagnosticUnderlineError", { sp = p.error, undercurl = true })
  hl("DiagnosticUnderlineWarn", { sp = p.warning, undercurl = true })
  hl("DiagnosticUnderlineInfo", { sp = p.info, undercurl = true })
  hl("DiagnosticUnderlineHint", { sp = p.fg_dim, undercurl = true })
  hl("DiagnosticUnderlineOk", { sp = p.success, undercurl = true })

  hl("DiagnosticVirtualTextError", { fg = p.error, bg = p.bg_dark })
  hl("DiagnosticVirtualTextWarn", { fg = p.warning, bg = p.bg_dark })
  hl("DiagnosticVirtualTextInfo", { fg = p.info, bg = p.bg_dark })
  hl("DiagnosticVirtualTextHint", { fg = p.fg_dim, bg = p.bg_dark })
  hl("DiagnosticVirtualTextOk", { fg = p.success, bg = p.bg_dark })

  hl("DiagnosticSignError", { fg = p.error })
  hl("DiagnosticSignWarn", { fg = p.warning })
  hl("DiagnosticSignInfo", { fg = p.info })
  hl("DiagnosticSignHint", { fg = p.fg_dim })
  hl("DiagnosticSignOk", { fg = p.success })

  hl("DiagnosticFloatingError", { fg = p.error })
  hl("DiagnosticFloatingWarn", { fg = p.warning })
  hl("DiagnosticFloatingInfo", { fg = p.info })
  hl("DiagnosticFloatingHint", { fg = p.fg_dim })
  hl("DiagnosticFloatingOk", { fg = p.success })

  -- ==========================================================================
  -- Diff/Git (~15 groups)
  -- ==========================================================================
  hl("DiffAdd", { bg = p.diff_add_bg })
  hl("DiffChange", { bg = p.diff_change_bg })
  hl("DiffDelete", { bg = p.diff_delete_bg })
  hl("DiffText", { bg = p.diff_text_bg })

  hl("diffAdded", { fg = p.success })
  hl("diffRemoved", { fg = p.error })
  hl("diffChanged", { fg = p.warning })
  hl("diffFile", { fg = p.accent3 })
  hl("diffLine", { fg = p.fg_dim })
  hl("diffIndexLine", { fg = p.accent4 })

  -- Git Signs
  hl("GitSignsAdd", { fg = p.success })
  hl("GitSignsChange", { fg = p.warning })
  hl("GitSignsDelete", { fg = p.error })
  hl("GitSignsAddNr", { fg = p.success })
  hl("GitSignsChangeNr", { fg = p.warning })
  hl("GitSignsDeleteNr", { fg = p.error })
  hl("GitSignsAddLn", { bg = p.diff_add_bg })
  hl("GitSignsChangeLn", { bg = p.diff_change_bg })
  hl("GitSignsDeleteLn", { bg = p.diff_delete_bg })
  hl("GitSignsCurrentLineBlame", { fg = p.fg_muted, italic = true })
  hl("GitSignsAddInline", { bg = p.diff_add_bg })
  hl("GitSignsChangeInline", { bg = p.diff_change_bg })
  hl("GitSignsDeleteInline", { bg = p.diff_delete_bg })

  -- ==========================================================================
  -- Plugin: Telescope (~15 groups)
  -- ==========================================================================
  hl("TelescopeNormal", { fg = p.fg, bg = p.bg })
  hl("TelescopeBorder", { fg = p.border, bg = p.bg })
  hl("TelescopePromptNormal", { fg = p.fg, bg = p.bg_alt })
  hl("TelescopePromptBorder", { fg = p.border, bg = p.bg_alt })
  hl("TelescopePromptTitle", { fg = p.fg, bg = p.bg_alt, bold = true })
  hl("TelescopePromptPrefix", { fg = p.accent3 })
  hl("TelescopePromptCounter", { fg = p.fg_dim })
  hl("TelescopePreviewNormal", { fg = p.fg, bg = p.bg })
  hl("TelescopePreviewBorder", { fg = p.border, bg = p.bg })
  hl("TelescopePreviewTitle", { fg = p.fg, bg = p.bg, bold = true })
  hl("TelescopeResultsNormal", { fg = p.fg, bg = p.bg })
  hl("TelescopeResultsBorder", { fg = p.border, bg = p.bg })
  hl("TelescopeResultsTitle", { fg = p.fg, bg = p.bg, bold = true })
  hl("TelescopeSelection", { fg = p.fg, bg = p.bg_highlight })
  hl("TelescopeSelectionCaret", { fg = p.accent3, bg = p.bg_highlight })
  hl("TelescopeMatching", { fg = p.accent1, bold = true })
  hl("TelescopeMultiSelection", { fg = p.accent5 })
  hl("TelescopeMultiIcon", { fg = p.accent5 })

  -- ==========================================================================
  -- Plugin: NvimTree (~15 groups)
  -- ==========================================================================
  hl("NvimTreeNormal", { fg = p.fg, bg = p.bg })
  hl("NvimTreeNormalNC", { fg = p.fg_dim, bg = p.bg })
  hl("NvimTreeRootFolder", { fg = p.fg_dim, bold = true })
  hl("NvimTreeFolderIcon", { fg = p.accent3 })
  hl("NvimTreeFolderName", { fg = p.fg })
  hl("NvimTreeOpenedFolderName", { fg = p.fg, bold = true })
  hl("NvimTreeEmptyFolderName", { fg = p.fg_dim })
  hl("NvimTreeIndentMarker", { fg = p.fg_muted })
  hl("NvimTreeGitDirty", { fg = p.warning })
  hl("NvimTreeGitNew", { fg = p.success })
  hl("NvimTreeGitDeleted", { fg = p.error })
  hl("NvimTreeGitStaged", { fg = p.success })
  hl("NvimTreeGitMerge", { fg = p.warning })
  hl("NvimTreeGitRenamed", { fg = p.warning })
  hl("NvimTreeSpecialFile", { fg = p.accent5 })
  hl("NvimTreeImageFile", { fg = p.fg })
  hl("NvimTreeWindowPicker", { fg = p.fg, bg = p.accent3 })
  hl("NvimTreeSymlink", { fg = p.accent3 })
  hl("NvimTreeExecFile", { fg = p.success, bold = true })
  hl("NvimTreeBookmark", { fg = p.accent5 })

  -- ==========================================================================
  -- Plugin: Bufferline (~50 groups)
  -- ==========================================================================
  local bl_bg = p.bg_dark
  local bl_bg_vis = p.bg_alt
  local bl_bg_sel = p.bg

  hl("BufferLineFill", { bg = bl_bg })
  hl("BufferLineBackground", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineBuffer", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineBufferVisible", { fg = p.fg_dim, bg = bl_bg_vis })
  hl("BufferLineBufferSelected", { fg = p.fg, bg = bl_bg_sel, bold = true })

  hl("BufferLineTab", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineTabSelected", { fg = p.fg, bg = bl_bg_sel, bold = true })
  hl("BufferLineTabClose", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineTabSeparator", { fg = bl_bg, bg = bl_bg })
  hl("BufferLineTabSeparatorSelected", { fg = bl_bg, bg = bl_bg_sel })

  hl("BufferLineCloseButton", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineCloseButtonVisible", { fg = p.fg_dim, bg = bl_bg_vis })
  hl("BufferLineCloseButtonSelected", { fg = p.fg, bg = bl_bg_sel })

  hl("BufferLineSeparator", { fg = bl_bg, bg = bl_bg })
  hl("BufferLineSeparatorVisible", { fg = bl_bg, bg = bl_bg_vis })
  hl("BufferLineSeparatorSelected", { fg = bl_bg, bg = bl_bg_sel })

  hl("BufferLineIndicatorSelected", { fg = p.accent3, bg = bl_bg_sel })
  hl("BufferLineIndicatorVisible", { fg = p.fg_muted, bg = bl_bg_vis })

  hl("BufferLineModified", { fg = p.warning, bg = bl_bg })
  hl("BufferLineModifiedVisible", { fg = p.warning, bg = bl_bg_vis })
  hl("BufferLineModifiedSelected", { fg = p.warning, bg = bl_bg_sel })

  hl("BufferLineDuplicate", { fg = p.fg_muted, bg = bl_bg, italic = true })
  hl("BufferLineDuplicateVisible", { fg = p.fg_dim, bg = bl_bg_vis, italic = true })
  hl("BufferLineDuplicateSelected", { fg = p.fg_dim, bg = bl_bg_sel, italic = true })

  hl("BufferLineDiagnostic", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineDiagnosticVisible", { fg = p.fg_dim, bg = bl_bg_vis })
  hl("BufferLineDiagnosticSelected", { fg = p.fg, bg = bl_bg_sel })

  hl("BufferLineError", { fg = p.error, bg = bl_bg })
  hl("BufferLineErrorVisible", { fg = p.error, bg = bl_bg_vis })
  hl("BufferLineErrorSelected", { fg = p.error, bg = bl_bg_sel })
  hl("BufferLineErrorDiagnostic", { fg = p.error, bg = bl_bg })
  hl("BufferLineErrorDiagnosticVisible", { fg = p.error, bg = bl_bg_vis })
  hl("BufferLineErrorDiagnosticSelected", { fg = p.error, bg = bl_bg_sel })

  hl("BufferLineWarning", { fg = p.warning, bg = bl_bg })
  hl("BufferLineWarningVisible", { fg = p.warning, bg = bl_bg_vis })
  hl("BufferLineWarningSelected", { fg = p.warning, bg = bl_bg_sel })
  hl("BufferLineWarningDiagnostic", { fg = p.warning, bg = bl_bg })
  hl("BufferLineWarningDiagnosticVisible", { fg = p.warning, bg = bl_bg_vis })
  hl("BufferLineWarningDiagnosticSelected", { fg = p.warning, bg = bl_bg_sel })

  hl("BufferLineInfo", { fg = p.info, bg = bl_bg })
  hl("BufferLineInfoVisible", { fg = p.info, bg = bl_bg_vis })
  hl("BufferLineInfoSelected", { fg = p.info, bg = bl_bg_sel })
  hl("BufferLineInfoDiagnostic", { fg = p.info, bg = bl_bg })
  hl("BufferLineInfoDiagnosticVisible", { fg = p.info, bg = bl_bg_vis })
  hl("BufferLineInfoDiagnosticSelected", { fg = p.info, bg = bl_bg_sel })

  hl("BufferLineHint", { fg = p.fg_dim, bg = bl_bg })
  hl("BufferLineHintVisible", { fg = p.fg_dim, bg = bl_bg_vis })
  hl("BufferLineHintSelected", { fg = p.fg_dim, bg = bl_bg_sel })
  hl("BufferLineHintDiagnostic", { fg = p.fg_dim, bg = bl_bg })
  hl("BufferLineHintDiagnosticVisible", { fg = p.fg_dim, bg = bl_bg_vis })
  hl("BufferLineHintDiagnosticSelected", { fg = p.fg_dim, bg = bl_bg_sel })

  hl("BufferLineNumbers", { fg = p.fg_muted, bg = bl_bg })
  hl("BufferLineNumbersVisible", { fg = p.fg_dim, bg = bl_bg_vis })
  hl("BufferLineNumbersSelected", { fg = p.fg, bg = bl_bg_sel })

  hl("BufferLineOffsetSeparator", { fg = p.border, bg = p.bg })
  hl("BufferLineTruncMarker", { fg = p.fg_muted, bg = bl_bg })

  hl("BufferLinePick", { fg = p.accent5, bg = bl_bg, bold = true })
  hl("BufferLinePickVisible", { fg = p.accent5, bg = bl_bg_vis, bold = true })
  hl("BufferLinePickSelected", { fg = p.accent5, bg = bl_bg_sel, bold = true })

  -- ==========================================================================
  -- Plugin: Lualine
  -- ==========================================================================
  hl("lualine_a_normal", { fg = p.bg, bg = p.accent3, bold = true })
  hl("lualine_b_normal", { fg = p.fg, bg = p.bg_alt })
  hl("lualine_c_normal", { fg = p.fg_dim, bg = p.bg_dark })

  hl("lualine_a_insert", { fg = p.bg, bg = p.success, bold = true })
  hl("lualine_b_insert", { fg = p.fg, bg = p.bg_alt })
  hl("lualine_c_insert", { fg = p.fg_dim, bg = p.bg_dark })

  hl("lualine_a_visual", { fg = p.bg, bg = p.accent5, bold = true })
  hl("lualine_b_visual", { fg = p.fg, bg = p.bg_alt })
  hl("lualine_c_visual", { fg = p.fg_dim, bg = p.bg_dark })

  hl("lualine_a_replace", { fg = p.bg, bg = p.error, bold = true })
  hl("lualine_b_replace", { fg = p.fg, bg = p.bg_alt })
  hl("lualine_c_replace", { fg = p.fg_dim, bg = p.bg_dark })

  hl("lualine_a_command", { fg = p.bg, bg = p.warning, bold = true })
  hl("lualine_b_command", { fg = p.fg, bg = p.bg_alt })
  hl("lualine_c_command", { fg = p.fg_dim, bg = p.bg_dark })

  hl("lualine_a_inactive", { fg = p.fg_muted, bg = p.bg_dark })
  hl("lualine_b_inactive", { fg = p.fg_muted, bg = p.bg_dark })
  hl("lualine_c_inactive", { fg = p.fg_muted, bg = p.bg_dark })

  -- ==========================================================================
  -- Plugin: Which-key
  -- ==========================================================================
  hl("WhichKey", { fg = p.accent3 })
  hl("WhichKeyGroup", { fg = p.accent4 })
  hl("WhichKeyDesc", { fg = p.fg })
  hl("WhichKeySeparator", { fg = p.fg_muted })
  hl("WhichKeyFloat", { bg = p.bg_alt })
  hl("WhichKeyBorder", { fg = p.border, bg = p.bg_alt })
  hl("WhichKeyValue", { fg = p.fg_dim })
  hl("WhichKeyNormal", { fg = p.fg, bg = p.bg_alt })

  -- ==========================================================================
  -- Plugin: CMP (Completion) (~25 groups)
  -- ==========================================================================
  hl("CmpItemAbbr", { fg = p.fg })
  hl("CmpItemAbbrDeprecated", { fg = p.fg_muted, strikethrough = true })
  hl("CmpItemAbbrMatch", { fg = p.accent1, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.accent1 })
  hl("CmpItemKind", { fg = p.fg_dim })
  hl("CmpItemMenu", { fg = p.fg_muted })

  hl("CmpItemKindText", { fg = p.fg })
  hl("CmpItemKindMethod", { fg = p.accent3 })
  hl("CmpItemKindFunction", { fg = p.accent3 })
  hl("CmpItemKindConstructor", { fg = p.accent2 })
  hl("CmpItemKindField", { fg = p.fg })
  hl("CmpItemKindVariable", { fg = p.fg })
  hl("CmpItemKindClass", { fg = p.accent2 })
  hl("CmpItemKindInterface", { fg = p.accent2 })
  hl("CmpItemKindModule", { fg = p.fg_dim })
  hl("CmpItemKindProperty", { fg = p.fg })
  hl("CmpItemKindUnit", { fg = p.accent1 })
  hl("CmpItemKindValue", { fg = p.accent1 })
  hl("CmpItemKindEnum", { fg = p.accent2 })
  hl("CmpItemKindKeyword", { fg = p.accent4 })
  hl("CmpItemKindSnippet", { fg = p.accent5 })
  hl("CmpItemKindColor", { fg = p.accent5 })
  hl("CmpItemKindFile", { fg = p.fg })
  hl("CmpItemKindReference", { fg = p.accent5 })
  hl("CmpItemKindFolder", { fg = p.accent3 })
  hl("CmpItemKindEnumMember", { fg = p.accent1 })
  hl("CmpItemKindConstant", { fg = p.accent1 })
  hl("CmpItemKindStruct", { fg = p.accent2 })
  hl("CmpItemKindEvent", { fg = p.accent5 })
  hl("CmpItemKindOperator", { fg = p.fg_dim })
  hl("CmpItemKindTypeParameter", { fg = p.accent2 })
  hl("CmpItemKindCopilot", { fg = p.success })

  -- ==========================================================================
  -- Plugin: Indent Blankline
  -- ==========================================================================
  hl("IblIndent", { fg = p.fg_muted })
  hl("IblScope", { fg = p.border })
  hl("IblWhitespace", { fg = p.fg_muted })

  -- ==========================================================================
  -- Plugin: Illuminate (word highlight)
  -- ==========================================================================
  hl("IlluminatedWordText", { bg = p.bg_highlight })
  hl("IlluminatedWordRead", { bg = p.bg_highlight })
  hl("IlluminatedWordWrite", { bg = p.bg_highlight })

  -- ==========================================================================
  -- Plugin: Todo Comments
  -- ==========================================================================
  hl("TodoBgTODO", { fg = p.bg, bg = p.info, bold = true })
  hl("TodoBgFIX", { fg = p.bg, bg = p.error, bold = true })
  hl("TodoBgHACK", { fg = p.bg, bg = p.warning, bold = true })
  hl("TodoBgWARN", { fg = p.bg, bg = p.warning, bold = true })
  hl("TodoBgNOTE", { fg = p.bg, bg = p.success, bold = true })
  hl("TodoBgPERF", { fg = p.bg, bg = p.accent5, bold = true })
  hl("TodoBgTEST", { fg = p.bg, bg = p.accent3, bold = true })

  hl("TodoFgTODO", { fg = p.info })
  hl("TodoFgFIX", { fg = p.error })
  hl("TodoFgHACK", { fg = p.warning })
  hl("TodoFgWARN", { fg = p.warning })
  hl("TodoFgNOTE", { fg = p.success })
  hl("TodoFgPERF", { fg = p.accent5 })
  hl("TodoFgTEST", { fg = p.accent3 })

  hl("TodoSignTODO", { fg = p.info })
  hl("TodoSignFIX", { fg = p.error })
  hl("TodoSignHACK", { fg = p.warning })
  hl("TodoSignWARN", { fg = p.warning })
  hl("TodoSignNOTE", { fg = p.success })
  hl("TodoSignPERF", { fg = p.accent5 })
  hl("TodoSignTEST", { fg = p.accent3 })

  -- ==========================================================================
  -- Plugin: Lazy.nvim
  -- ==========================================================================
  hl("LazyH1", { fg = p.bg, bg = p.accent3, bold = true })
  hl("LazyH2", { fg = p.fg, bold = true })
  hl("LazyButton", { fg = p.fg, bg = p.bg_alt })
  hl("LazyButtonActive", { fg = p.bg, bg = p.accent3 })
  hl("LazySpecial", { fg = p.accent3 })
  hl("LazyProgressDone", { fg = p.success })
  hl("LazyProgressTodo", { fg = p.fg_muted })
  hl("LazyCommit", { fg = p.fg_dim })
  hl("LazyReasonCmd", { fg = p.accent4 })
  hl("LazyReasonEvent", { fg = p.warning })
  hl("LazyReasonFt", { fg = p.accent2 })
  hl("LazyReasonImport", { fg = p.accent3 })
  hl("LazyReasonKeys", { fg = p.accent5 })
  hl("LazyReasonPlugin", { fg = p.accent1 })
  hl("LazyReasonSource", { fg = p.fg_dim })
  hl("LazyReasonStart", { fg = p.success })

  -- ==========================================================================
  -- Plugin: Mason
  -- ==========================================================================
  hl("MasonHeader", { fg = p.bg, bg = p.accent3, bold = true })
  hl("MasonHighlight", { fg = p.accent3 })
  hl("MasonHighlightBlock", { fg = p.bg, bg = p.accent3 })
  hl("MasonHighlightBlockBold", { fg = p.bg, bg = p.accent3, bold = true })
  hl("MasonMuted", { fg = p.fg_muted })
  hl("MasonMutedBlock", { fg = p.fg_muted, bg = p.bg_alt })
  hl("MasonHeaderSecondary", { fg = p.bg, bg = p.accent2, bold = true })
  hl("MasonHighlightSecondary", { fg = p.accent2 })
  hl("MasonHighlightBlockSecondary", { fg = p.bg, bg = p.accent2 })

  -- ==========================================================================
  -- Plugin: Noice
  -- ==========================================================================
  hl("NoiceCmdline", { fg = p.fg, bg = p.bg_alt })
  hl("NoiceCmdlineIcon", { fg = p.accent3 })
  hl("NoiceCmdlineIconSearch", { fg = p.warning })
  hl("NoiceCmdlinePopup", { fg = p.fg, bg = p.bg_alt })
  hl("NoiceCmdlinePopupBorder", { fg = p.border, bg = p.bg_alt })
  hl("NoiceCmdlinePopupTitle", { fg = p.fg, bg = p.bg_alt, bold = true })
  hl("NoiceConfirm", { fg = p.fg, bg = p.bg_alt })
  hl("NoiceConfirmBorder", { fg = p.border, bg = p.bg_alt })
  hl("NoiceMini", { fg = p.fg_dim, bg = p.bg_dark })
  hl("NoicePopup", { fg = p.fg, bg = p.bg_alt })
  hl("NoicePopupBorder", { fg = p.border, bg = p.bg_alt })
  hl("NoiceVirtualText", { fg = p.fg_dim })

  -- ==========================================================================
  -- Plugin: Flash
  -- ==========================================================================
  hl("FlashLabel", { fg = p.bg, bg = p.accent5, bold = true })
  hl("FlashMatch", { fg = p.fg, bg = p.match })
  hl("FlashCurrent", { fg = p.fg, bg = p.bg_highlight })
  hl("FlashBackdrop", { fg = p.fg_muted })
  hl("FlashPrompt", { fg = p.fg, bg = p.bg_alt })
  hl("FlashPromptIcon", { fg = p.accent3 })

  -- ==========================================================================
  -- Plugin: Trouble
  -- ==========================================================================
  hl("TroubleNormal", { fg = p.fg, bg = p.bg })
  hl("TroubleText", { fg = p.fg })
  hl("TroubleCount", { fg = p.accent5 })
  hl("TroubleSource", { fg = p.fg_dim })
  hl("TroubleFile", { fg = p.accent3 })
  hl("TroubleLocation", { fg = p.fg_dim })
  hl("TroubleCode", { fg = p.fg_dim })
  hl("TroublePos", { fg = p.fg_muted })
  hl("TroubleFoldIcon", { fg = p.accent3 })
  hl("TroubleIndent", { fg = p.fg_muted })
  hl("TroubleIndentFoldClosed", { fg = p.fg_muted })
  hl("TroubleIndentFoldOpen", { fg = p.fg_muted })
  hl("TroubleIndentLast", { fg = p.fg_muted })
  hl("TroubleIndentMiddle", { fg = p.fg_muted })
  hl("TroubleIndentTop", { fg = p.fg_muted })
  hl("TroubleIndentWs", { fg = p.fg_muted })

  -- ==========================================================================
  -- Plugin: DAP (Debug Adapter Protocol)
  -- ==========================================================================
  hl("DapBreakpoint", { fg = p.error })
  hl("DapLogPoint", { fg = p.info })
  hl("DapStopped", { fg = p.warning })
  hl("DapStoppedLine", { bg = p.bg_highlight })
  hl("DapBreakpointCondition", { fg = p.warning })
  hl("DapBreakpointRejected", { fg = p.fg_muted })

  hl("DapUIScope", { fg = p.accent3 })
  hl("DapUIType", { fg = p.accent2 })
  hl("DapUIModifiedValue", { fg = p.warning, bold = true })
  hl("DapUIDecoration", { fg = p.accent3 })
  hl("DapUIThread", { fg = p.success })
  hl("DapUIStoppedThread", { fg = p.accent3 })
  hl("DapUISource", { fg = p.accent5 })
  hl("DapUILineNumber", { fg = p.fg_dim })
  hl("DapUIFloatBorder", { fg = p.border })
  hl("DapUIWatchesEmpty", { fg = p.fg_muted })
  hl("DapUIWatchesValue", { fg = p.success })
  hl("DapUIWatchesError", { fg = p.error })
  hl("DapUIBreakpointsPath", { fg = p.accent3 })
  hl("DapUIBreakpointsInfo", { fg = p.success })
  hl("DapUIBreakpointsCurrentLine", { fg = p.fg, bold = true })
  hl("DapUIBreakpointsLine", { link = "DapUILineNumber" })
  hl("DapUIBreakpointsDisabledLine", { fg = p.fg_muted })
  hl("DapUICurrentFrameName", { link = "DapUIBreakpointsCurrentLine" })
  hl("DapUIStepOver", { fg = p.accent3 })
  hl("DapUIStepInto", { fg = p.accent3 })
  hl("DapUIStepBack", { fg = p.accent3 })
  hl("DapUIStepOut", { fg = p.accent3 })
  hl("DapUIStop", { fg = p.error })
  hl("DapUIPlayPause", { fg = p.success })
  hl("DapUIRestart", { fg = p.success })
  hl("DapUIUnavailable", { fg = p.fg_muted })
  hl("DapUIWinSelect", { fg = p.accent3, bold = true })

  -- ==========================================================================
  -- Plugin: Markdown
  -- ==========================================================================
  hl("markdownH1", { fg = p.fg, bold = true })
  hl("markdownH2", { fg = p.fg, bold = true })
  hl("markdownH3", { fg = p.fg, bold = true })
  hl("markdownH4", { fg = p.fg, bold = true })
  hl("markdownH5", { fg = p.fg, bold = true })
  hl("markdownH6", { fg = p.fg, bold = true })
  hl("markdownHeadingDelimiter", { fg = p.fg_dim })
  hl("markdownCode", { fg = p.accent1, bg = p.bg_dark })
  hl("markdownCodeBlock", { fg = p.accent1 })
  hl("markdownCodeDelimiter", { fg = p.fg_muted })
  hl("markdownBlockquote", { fg = p.fg_dim, italic = true })
  hl("markdownListMarker", { fg = p.accent3 })
  hl("markdownOrderedListMarker", { fg = p.accent3 })
  hl("markdownRule", { fg = p.fg_muted })
  hl("markdownLinkText", { fg = p.accent3 })
  hl("markdownUrl", { fg = p.fg_dim, underline = true })
  hl("markdownBold", { bold = true })
  hl("markdownItalic", { italic = true })
  hl("markdownId", { fg = p.accent4 })
  hl("markdownIdDeclaration", { fg = p.accent4 })
  hl("markdownIdDelimiter", { fg = p.fg_dim })

  -- ==========================================================================
  -- Plugin: Render-markdown
  -- ==========================================================================
  hl("RenderMarkdownH1", { fg = p.fg, bold = true })
  hl("RenderMarkdownH2", { fg = p.fg, bold = true })
  hl("RenderMarkdownH3", { fg = p.fg, bold = true })
  hl("RenderMarkdownH4", { fg = p.fg, bold = true })
  hl("RenderMarkdownH5", { fg = p.fg, bold = true })
  hl("RenderMarkdownH6", { fg = p.fg, bold = true })
  hl("RenderMarkdownH1Bg", { bg = p.bg_highlight })
  hl("RenderMarkdownH2Bg", { bg = p.bg_highlight })
  hl("RenderMarkdownH3Bg", { bg = p.bg_highlight })
  hl("RenderMarkdownH4Bg", { bg = p.bg_highlight })
  hl("RenderMarkdownH5Bg", { bg = p.bg_highlight })
  hl("RenderMarkdownH6Bg", { bg = p.bg_highlight })
  hl("RenderMarkdownCode", { bg = p.bg_dark })
  hl("RenderMarkdownCodeInline", { fg = p.accent1, bg = p.bg_dark })
  hl("RenderMarkdownBullet", { fg = p.accent3 })
  hl("RenderMarkdownQuote", { fg = p.fg_dim, italic = true })
  hl("RenderMarkdownDash", { fg = p.fg_muted })
  hl("RenderMarkdownLink", { fg = p.accent3 })
  hl("RenderMarkdownMath", { fg = p.accent1 })
  hl("RenderMarkdownChecked", { fg = p.success })
  hl("RenderMarkdownUnchecked", { fg = p.fg_muted })
  hl("RenderMarkdownTableHead", { fg = p.fg, bold = true })
  hl("RenderMarkdownTableRow", { fg = p.fg })
  hl("RenderMarkdownTableFill", { fg = p.fg_muted })

  -- ==========================================================================
  -- Plugin: Neominimap
  -- ==========================================================================
  hl("NeominimapBackground", { bg = p.bg_dark })
  hl("NeominimapBorder", { fg = p.border })
  hl("NeominimapCursorLine", { bg = p.bg_highlight })
  hl("NeominimapCursorLineSign", { fg = p.accent3 })
  hl("NeominimapCursorLineNr", { fg = p.fg })

  -- ==========================================================================
  -- Plugin: nvim-notify
  -- ==========================================================================
  hl("NotifyERRORBorder", { fg = p.error })
  hl("NotifyWARNBorder", { fg = p.warning })
  hl("NotifyINFOBorder", { fg = p.info })
  hl("NotifyDEBUGBorder", { fg = p.fg_muted })
  hl("NotifyTRACEBorder", { fg = p.accent5 })
  hl("NotifyERRORIcon", { fg = p.error })
  hl("NotifyWARNIcon", { fg = p.warning })
  hl("NotifyINFOIcon", { fg = p.info })
  hl("NotifyDEBUGIcon", { fg = p.fg_muted })
  hl("NotifyTRACEIcon", { fg = p.accent5 })
  hl("NotifyERRORTitle", { fg = p.error })
  hl("NotifyWARNTitle", { fg = p.warning })
  hl("NotifyINFOTitle", { fg = p.info })
  hl("NotifyDEBUGTitle", { fg = p.fg_muted })
  hl("NotifyTRACETitle", { fg = p.accent5 })
  hl("NotifyERRORBody", { fg = p.fg })
  hl("NotifyWARNBody", { fg = p.fg })
  hl("NotifyINFOBody", { fg = p.fg })
  hl("NotifyDEBUGBody", { fg = p.fg })
  hl("NotifyTRACEBody", { fg = p.fg })

  -- ==========================================================================
  -- Plugin: nvim-dap-virtual-text
  -- ==========================================================================
  hl("NvimDapVirtualText", { fg = p.fg_dim, italic = true })
  hl("NvimDapVirtualTextChanged", { fg = p.warning, italic = true })
  hl("NvimDapVirtualTextError", { fg = p.error, italic = true })
  hl("NvimDapVirtualTextInfo", { fg = p.info, italic = true })

  -- ==========================================================================
  -- Plugin: vim-illuminate
  -- ==========================================================================
  hl("IlluminatedWord", { bg = p.bg_highlight })
  hl("IlluminatedCurWord", { bg = p.bg_highlight })
  hl("IlluminatedWordText", { bg = p.bg_highlight })
  hl("IlluminatedWordRead", { bg = p.bg_highlight })
  hl("IlluminatedWordWrite", { bg = p.bg_highlight })

  -- ==========================================================================
  -- Plugin: gitsigns (additional groups)
  -- ==========================================================================
  hl("GitSignsAddPreview", { fg = p.success })
  hl("GitSignsDeletePreview", { fg = p.error })
  hl("GitSignsTopdelete", { fg = p.error })
  hl("GitSignsUntracked", { fg = p.fg_muted })
  hl("GitSignsChangedelete", { fg = p.warning })

  -- ==========================================================================
  -- Plugin: nvim-surround
  -- ==========================================================================
  hl("NvimSurroundHighlight", { fg = p.bg, bg = p.accent5 })

  -- ==========================================================================
  -- Plugin: leap.nvim / flash.nvim extras
  -- ==========================================================================
  hl("LeapMatch", { fg = p.fg, bg = p.match, bold = true })
  hl("LeapLabelPrimary", { fg = p.bg, bg = p.accent5, bold = true })
  hl("LeapLabelSecondary", { fg = p.bg, bg = p.accent3, bold = true })
  hl("LeapBackdrop", { fg = p.fg_muted })

  -- ==========================================================================
  -- Plugin: nvim-spectre
  -- ==========================================================================
  hl("SpectreHeader", { fg = p.fg, bold = true })
  hl("SpectreBody", { fg = p.fg })
  hl("SpectreFile", { fg = p.accent3 })
  hl("SpectreDir", { fg = p.fg_dim })
  hl("SpectreSearch", { fg = p.bg, bg = p.error })
  hl("SpectreReplace", { fg = p.bg, bg = p.success })
  hl("SpectreBorder", { fg = p.border })

  -- ==========================================================================
  -- Plugin: neo-tree
  -- ==========================================================================
  hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
  hl("NeoTreeNormalNC", { fg = p.fg_dim, bg = p.bg })
  hl("NeoTreeDirectoryName", { fg = p.fg })
  hl("NeoTreeDirectoryIcon", { fg = p.accent3 })
  hl("NeoTreeRootName", { fg = p.fg_dim, bold = true })
  hl("NeoTreeFileName", { fg = p.fg })
  hl("NeoTreeFileIcon", { fg = p.fg })
  hl("NeoTreeFileNameOpened", { fg = p.fg, bold = true })
  hl("NeoTreeIndentMarker", { fg = p.fg_muted })
  hl("NeoTreeGitAdded", { fg = p.success })
  hl("NeoTreeGitDeleted", { fg = p.error })
  hl("NeoTreeGitModified", { fg = p.warning })
  hl("NeoTreeGitConflict", { fg = p.error, bold = true })
  hl("NeoTreeGitUntracked", { fg = p.fg_muted })
  hl("NeoTreeGitIgnored", { fg = p.fg_muted })
  hl("NeoTreeGitStaged", { fg = p.success })
  hl("NeoTreeFloatBorder", { fg = p.border })
  hl("NeoTreeFloatTitle", { fg = p.fg, bold = true })
  hl("NeoTreeCursorLine", { bg = p.bg_highlight })
  hl("NeoTreeDimText", { fg = p.fg_muted })
  hl("NeoTreeDotfile", { fg = p.fg_muted })
  hl("NeoTreeSymbolicLinkTarget", { fg = p.accent3 })
  hl("NeoTreeTitleBar", { fg = p.fg, bg = p.bg_alt, bold = true })
  hl("NeoTreeWinSeparator", { fg = p.border })

  -- ==========================================================================
  -- Plugin: mini.nvim
  -- ==========================================================================
  hl("MiniIndentscopeSymbol", { fg = p.border })
  hl("MiniIndentscopePrefix", { fg = p.border })

  hl("MiniJump", { fg = p.bg, bg = p.accent5, bold = true })
  hl("MiniJump2dSpot", { fg = p.accent5, bold = true })
  hl("MiniJump2dSpotAhead", { fg = p.accent3 })
  hl("MiniJump2dSpotUnique", { fg = p.warning })

  hl("MiniStatuslineDevinfo", { fg = p.fg, bg = p.bg_alt })
  hl("MiniStatuslineFileinfo", { fg = p.fg, bg = p.bg_alt })
  hl("MiniStatuslineFilename", { fg = p.fg_dim, bg = p.bg_dark })
  hl("MiniStatuslineInactive", { fg = p.fg_muted, bg = p.bg_dark })
  hl("MiniStatuslineModeCommand", { fg = p.bg, bg = p.warning, bold = true })
  hl("MiniStatuslineModeInsert", { fg = p.bg, bg = p.success, bold = true })
  hl("MiniStatuslineModeNormal", { fg = p.bg, bg = p.accent3, bold = true })
  hl("MiniStatuslineModeOther", { fg = p.bg, bg = p.accent5, bold = true })
  hl("MiniStatuslineModeReplace", { fg = p.bg, bg = p.error, bold = true })
  hl("MiniStatuslineModeVisual", { fg = p.bg, bg = p.accent5, bold = true })

  hl("MiniSurround", { fg = p.bg, bg = p.accent5 })
  hl("MiniTablineCurrent", { fg = p.fg, bg = p.bg, bold = true })
  hl("MiniTablineFill", { bg = p.bg_dark })
  hl("MiniTablineHidden", { fg = p.fg_muted, bg = p.bg_dark })
  hl("MiniTablineModifiedCurrent", { fg = p.warning, bg = p.bg, bold = true })
  hl("MiniTablineModifiedHidden", { fg = p.warning, bg = p.bg_dark })
  hl("MiniTablineModifiedVisible", { fg = p.warning, bg = p.bg_alt })
  hl("MiniTablineTabpagesection", { fg = p.fg, bg = p.bg_alt })
  hl("MiniTablineVisible", { fg = p.fg_dim, bg = p.bg_alt })

  hl("MiniTestEmphasis", { bold = true })
  hl("MiniTestFail", { fg = p.error, bold = true })
  hl("MiniTestPass", { fg = p.success, bold = true })

  hl("MiniTrailspace", { bg = p.error })

  -- ==========================================================================
  -- Plugin: neotest
  -- ==========================================================================
  hl("NeotestPassed", { fg = p.success })
  hl("NeotestFailed", { fg = p.error })
  hl("NeotestRunning", { fg = p.warning })
  hl("NeotestSkipped", { fg = p.fg_muted })
  hl("NeotestNamespace", { fg = p.accent2 })
  hl("NeotestFile", { fg = p.accent3 })
  hl("NeotestDir", { fg = p.accent3 })
  hl("NeotestIndent", { fg = p.fg_muted })
  hl("NeotestExpandMarker", { fg = p.fg_muted })
  hl("NeotestAdapterName", { fg = p.accent5, bold = true })
  hl("NeotestWinSelect", { fg = p.accent3, bold = true })
  hl("NeotestMarked", { fg = p.accent5, bold = true })
  hl("NeotestTarget", { fg = p.error })
  hl("NeotestTest", { fg = p.fg })
  hl("NeotestUnknown", { fg = p.fg_muted })
  hl("NeotestWatching", { fg = p.warning })
  hl("NeotestFocused", { bold = true, underline = true })

  -- ==========================================================================
  -- Plugin: copilot
  -- ==========================================================================
  hl("CopilotSuggestion", { fg = p.fg_muted, italic = true })
  hl("CopilotAnnotation", { fg = p.fg_muted, italic = true })

  -- ==========================================================================
  -- Misc / Built-in
  -- ==========================================================================
  hl("healthSuccess", { fg = p.success })
  hl("healthWarning", { fg = p.warning })
  hl("healthError", { fg = p.error })

  hl("qfFileName", { fg = p.accent3 })
  hl("qfLineNr", { fg = p.fg_dim })

  hl("helpCommand", { fg = p.accent1, bg = p.bg_dark })
  hl("helpExample", { fg = p.fg_dim })
  hl("helpHeader", { fg = p.fg, bold = true })
  hl("helpSectionDelim", { fg = p.fg_muted })

  hl("WildMenu", { fg = p.bg, bg = p.accent3 })
  hl("WinBar", { fg = p.fg, bg = p.bg })
  hl("WinBarNC", { fg = p.fg_dim, bg = p.bg })

  hl("debugPC", { bg = p.bg_highlight })
  hl("debugBreakpoint", { fg = p.error })

  hl("TermCursor", { fg = p.bg, bg = p.fg })
  hl("TermCursorNC", { fg = p.bg, bg = p.fg_dim })

  hl("SpellBad", { sp = p.error, undercurl = true })
  hl("SpellCap", { sp = p.warning, undercurl = true })
  hl("SpellLocal", { sp = p.info, undercurl = true })
  hl("SpellRare", { sp = p.accent5, undercurl = true })

  -- Neovim 0.10+ WinBar
  hl("WinBarModified", { fg = p.warning })
  hl("WinBarFileName", { fg = p.fg })
  hl("WinBarPath", { fg = p.fg_dim })
  hl("WinBarFileIcon", { fg = p.accent3 })
end

-- ============================================================================
-- Theme Application
-- ============================================================================

function M.apply(variant, opts)
  opts = opts or {}
  variant = variant or "dark"
  local p = M.palettes[variant]
  local is_preview = opts.preview

  if not p then
    vim.notify("txaty: Unknown variant '" .. variant .. "', using dark", vim.log.levels.WARN)
    variant = "dark"
    p = M.palettes.dark
  end

  -- Reset (skip during preview to avoid destroying active Telescope/UI state)
  if not is_preview then
    vim.cmd "highlight clear"
    if vim.fn.exists "syntax_on" then
      vim.cmd "syntax reset"
    end
  end

  -- Set colorscheme metadata
  vim.g.colors_name = variant == "light" and "txaty-light" or "txaty"
  if is_preview then
    vim.cmd("noautocmd set background=" .. variant)
  else
    vim.o.background = variant
  end
  vim.o.termguicolors = true

  -- Apply all highlights
  generate_highlights(p)

  -- Enable syntax
  if not is_preview then
    vim.cmd "syntax on"
  end

  -- Trigger ColorScheme autocmd so plugins can refresh (skip during preview
  -- to avoid cascading side effects that disrupt Telescope rendering)
  if not is_preview then
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name })
  end
end

-- ============================================================================
-- Public API
-- ============================================================================

-- Export palettes for other modules if needed
M.palette = M.palettes.dark -- default export for backward compatibility

-- Get palette for a specific variant
function M.get_palette(variant)
  return M.palettes[variant or "dark"]
end

return M
