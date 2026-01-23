-- Custom "txaty" theme: Low-saturation, pure dark, ergonomic design
-- Based on research: Too many colors impairs code reading
-- Uses limited, muted palette for sustained focus with pure dark background

local M = {}

-- Define the low-saturation, pure dark color palette
local palette = {
  bg = "#0f1419", -- Pure dark background (almost black)
  fg = "#e1e3e8", -- Off-white foreground
  bg_alt = "#19202b", -- Slightly lighter bg for contrast
  bg_dark = "#0a0f15", -- Darker for active elements

  -- Semantic colors (muted, low saturation)
  comment = "#5a6b7a", -- Muted teal comment
  string = "#a89968", -- Warm beige string
  keyword = "#8b6f9d", -- Muted purple keyword
  function_color = "#6fa8c8", -- Muted blue function
  variable = "#d1d4db", -- Subtle off-white
  operator = "#a89968", -- Warm operator/number
  type_color = "#8fa870", -- Muted green type
  builtin = "#7a87b8", -- Indigo builtin

  -- Diff and status colors
  error = "#c66f6f", -- Muted red
  warning = "#c8a876", -- Muted yellow
  success = "#7fa870", -- Muted green
  info = "#6fa8c8", -- Muted blue

  -- UI elements
  border = "#262f3e",
  line_nr = "#3a4558",
  cursor_line = "#1a212d",
  selection = "#2a3f52",
  visual_bg = "#2a3f52",
}

-- Create the colorscheme
local function create_highlight(group, fg, bg, style)
  local hl = {}
  if fg then
    hl.fg = fg
  end
  if bg then
    hl.bg = bg
  end
  if style then
    if style == "bold" then
      hl.bold = true
    elseif style == "italic" then
      hl.italic = true
    elseif style == "underline" then
      hl.underline = true
    end
  end
  vim.api.nvim_set_hl(0, group, hl)
end

-- Apply the theme
local function apply_theme()
  -- Clear any previous colorscheme state
  vim.cmd "syntax off"
  vim.cmd "highlight clear"
  if vim.fn.exists "syntax_on" then
    vim.cmd "syntax reset"
  end

  -- Set colorscheme metadata and options
  vim.g.colors_name = "txaty"
  vim.o.background = "dark"
  vim.o.termguicolors = true

  -- Force syntax on
  vim.cmd "syntax on"

  -- Editor backgrounds
  create_highlight("Normal", palette.fg, palette.bg)
  create_highlight("NormalFloat", palette.fg, palette.bg_alt)
  create_highlight("FloatBorder", palette.border, palette.bg_alt)
  create_highlight("Cursor", palette.bg, palette.fg)
  create_highlight("CursorLine", nil, palette.cursor_line)
  create_highlight("CursorLineNr", palette.fg, palette.cursor_line, "bold")
  create_highlight("LineNr", palette.line_nr, palette.bg)
  create_highlight("SignColumn", nil, palette.bg)

  -- Search and selection (FIX: correct foreground/background relationship)
  create_highlight("Search", palette.bg, palette.operator, "bold")
  create_highlight("IncSearch", palette.bg, palette.warning, "bold")
  create_highlight("Visual", nil, palette.visual_bg)
  create_highlight("VisualNOS", nil, palette.visual_bg)
  create_highlight("Selection", nil, palette.selection)

  -- Syntax highlighting
  create_highlight("Comment", palette.comment, nil, "italic")
  create_highlight("String", palette.string)
  create_highlight("Character", palette.string)
  create_highlight("Number", palette.operator)
  create_highlight("Boolean", palette.operator)
  create_highlight("Float", palette.operator)

  create_highlight("Keyword", palette.keyword, nil, "bold")
  create_highlight("Function", palette.function_color, nil, "bold")
  create_highlight("Identifier", palette.variable)
  create_highlight("Type", palette.type_color, nil, "bold")
  create_highlight("TypeDef", palette.type_color, nil, "bold")
  create_highlight("StorageClass", palette.keyword, nil, "bold")
  create_highlight("Operator", palette.operator)
  create_highlight("Delimiter", palette.operator)
  create_highlight("Punctuation", palette.operator)
  create_highlight("Special", palette.builtin)
  create_highlight("SpecialKey", palette.builtin)
  create_highlight("Todo", palette.warning, nil, "bold")
  create_highlight("Error", palette.error, nil, "bold")
  create_highlight("ErrorMsg", palette.error, nil, "bold")
  create_highlight("WarningMsg", palette.warning, nil, "bold")
  create_highlight("MoreMsg", palette.success)
  create_highlight("ModeMsg", palette.info)
  create_highlight("Question", palette.info, nil, "bold")

  -- UI components
  create_highlight("StatusLine", palette.variable, palette.bg_alt)
  create_highlight("StatusLineNC", palette.line_nr, palette.bg_alt)
  create_highlight("VertSplit", palette.border)
  create_highlight("Folded", palette.comment, palette.bg_dark)
  create_highlight("FoldColumn", palette.comment, palette.bg)
  create_highlight("DiffAdd", palette.success, palette.bg_dark)
  create_highlight("DiffChange", palette.warning, palette.bg_dark)
  create_highlight("DiffDelete", palette.error, palette.bg_dark)
  create_highlight("DiffText", palette.fg, palette.warning, "bold")

  -- Pmenu (completion menu)
  create_highlight("Pmenu", palette.fg, palette.bg_alt)
  create_highlight("PmenuSel", palette.bg, palette.function_color, "bold")
  create_highlight("PmenuSbar", nil, palette.bg_dark)
  create_highlight("PmenuThumb", nil, palette.border)

  -- Treesitter highlights
  create_highlight("@comment", palette.comment, nil, "italic")
  create_highlight("@string", palette.string)
  create_highlight("@number", palette.operator)
  create_highlight("@constant", palette.operator)
  create_highlight("@constant.builtin", palette.operator)
  create_highlight("@keyword", palette.keyword, nil, "bold")
  create_highlight("@keyword.function", palette.keyword, nil, "bold")
  create_highlight("@function", palette.function_color, nil, "bold")
  create_highlight("@function.builtin", palette.builtin, nil, "bold")
  create_highlight("@type", palette.type_color, nil, "bold")
  create_highlight("@type.builtin", palette.builtin)
  create_highlight("@variable", palette.variable)
  create_highlight("@variable.builtin", palette.operator)
  create_highlight("@operator", palette.operator)
  create_highlight("@punctuation", palette.operator)
  create_highlight("@punctuation.bracket", palette.operator)
  create_highlight("@punctuation.delimiter", palette.operator)

  -- LSP
  create_highlight("DiagnosticError", palette.error)
  create_highlight("DiagnosticWarn", palette.warning)
  create_highlight("DiagnosticInfo", palette.info)
  create_highlight("DiagnosticHint", palette.comment)
  create_highlight("DiagnosticUnderlineError", palette.error, nil, "underline")
  create_highlight("DiagnosticUnderlineWarn", palette.warning, nil, "underline")
  create_highlight("DiagnosticUnderlineInfo", palette.info, nil, "underline")
  create_highlight("DiagnosticUnderlineHint", palette.comment, nil, "underline")

  -- Git signs
  create_highlight("GitSignsAdd", palette.success)
  create_highlight("GitSignsChange", palette.warning)
  create_highlight("GitSignsDelete", palette.error)

  -- Telescope (FIX: use light foreground for selection text visibility)
  create_highlight("TelescopeNormal", palette.fg, palette.bg)
  create_highlight("TelescopeBorder", palette.border, palette.bg_alt)
  create_highlight("TelescopeSelection", palette.fg, palette.function_color, "bold")
  create_highlight("TelescopeMatching", palette.operator, nil, "bold")

  -- CMP
  create_highlight("CmpItemAbbrMatch", palette.operator, nil, "bold")
  create_highlight("CmpItemAbbrMatchFuzzy", palette.operator, nil, "bold")
  create_highlight("CmpItemKindSnippet", palette.string)
  create_highlight("CmpItemKindKeyword", palette.keyword)
  create_highlight("CmpItemKindText", palette.variable)
  create_highlight("CmpItemKindMethod", palette.function_color)
  create_highlight("CmpItemKindFunction", palette.function_color)
  create_highlight("CmpItemKindClass", palette.type_color)
  create_highlight("CmpItemKindModule", palette.type_color)
  create_highlight("CmpItemKindStruct", palette.type_color)
  create_highlight("CmpItemKindEnum", palette.type_color)
  create_highlight("CmpItemKindInterface", palette.type_color)
  create_highlight("CmpItemKindVariable", palette.variable)
  create_highlight("CmpItemKindField", palette.variable)
  create_highlight("CmpItemKindProperty", palette.variable)
  create_highlight("CmpItemKindValue", palette.operator)
  create_highlight("CmpItemKindOperator", palette.operator)

  -- Which-key
  create_highlight("WhichKey", palette.keyword)
  create_highlight("WhichKeyGroup", palette.function_color)
  create_highlight("WhichKeySeperator", palette.operator)
  create_highlight("WhichKeyDesc", palette.variable)

  -- Gitsigns
  create_highlight("Gitsigns", palette.info)

  -- NvimTree
  create_highlight("NvimTreeFolderIcon", palette.function_color)
  create_highlight("NvimTreeOpenedFolderIcon", palette.warning)
  create_highlight("NvimTreeRootFolder", palette.keyword, nil, "bold")
  create_highlight("NvimTreeWindowPicker", palette.fg, palette.warning)

  -- Todo comments
  create_highlight("TodoFgTODO", palette.warning, nil, "bold")
  create_highlight("TodoFgFIXME", palette.error, nil, "bold")
  create_highlight("TodoFgHACK", palette.info, nil, "bold")
  create_highlight("TodoFgNOTE", palette.success, nil, "bold")

  -- Bufferline (tab bar)
  create_highlight("BufferLineFill", nil, palette.bg_dark)
  create_highlight("BufferLineBackground", palette.line_nr, palette.bg_dark)
  create_highlight("BufferLineBufferVisible", palette.variable, palette.bg_alt)
  create_highlight("BufferLineBufferSelected", palette.fg, palette.bg, "bold")
  create_highlight("BufferLineTab", palette.line_nr, palette.bg_dark)
  create_highlight("BufferLineTabSelected", palette.fg, palette.bg, "bold")
  create_highlight("BufferLineTabClose", palette.error, palette.bg_dark)
  create_highlight("BufferLineCloseButton", palette.line_nr, palette.bg_dark)
  create_highlight("BufferLineCloseButtonVisible", palette.variable, palette.bg_alt)
  create_highlight("BufferLineCloseButtonSelected", palette.fg, palette.bg)
  create_highlight("BufferLineSeparator", palette.bg_dark, palette.bg_dark)
  create_highlight("BufferLineSeparatorVisible", palette.bg_alt, palette.bg_alt)
  create_highlight("BufferLineSeparatorSelected", palette.bg, palette.bg)
  create_highlight("BufferLineIndicatorSelected", palette.function_color, palette.bg)
  create_highlight("BufferLineModified", palette.warning, palette.bg_dark)
  create_highlight("BufferLineModifiedVisible", palette.warning, palette.bg_alt)
  create_highlight("BufferLineModifiedSelected", palette.warning, palette.bg)
  create_highlight("BufferLineDuplicate", palette.comment, palette.bg_dark)
  create_highlight("BufferLineDuplicateVisible", palette.comment, palette.bg_alt)
  create_highlight("BufferLineDuplicateSelected", palette.variable, palette.bg)
  create_highlight("BufferLineDiagnostic", palette.line_nr, palette.bg_dark)
  create_highlight("BufferLineDiagnosticVisible", palette.variable, palette.bg_alt)
  create_highlight("BufferLineDiagnosticSelected", palette.fg, palette.bg)
  create_highlight("BufferLineError", palette.error, palette.bg_dark)
  create_highlight("BufferLineErrorVisible", palette.error, palette.bg_alt)
  create_highlight("BufferLineErrorSelected", palette.error, palette.bg)
  create_highlight("BufferLineErrorDiagnostic", palette.error, palette.bg_dark)
  create_highlight("BufferLineErrorDiagnosticVisible", palette.error, palette.bg_alt)
  create_highlight("BufferLineErrorDiagnosticSelected", palette.error, palette.bg)
  create_highlight("BufferLineWarning", palette.warning, palette.bg_dark)
  create_highlight("BufferLineWarningVisible", palette.warning, palette.bg_alt)
  create_highlight("BufferLineWarningSelected", palette.warning, palette.bg)
  create_highlight("BufferLineWarningDiagnostic", palette.warning, palette.bg_dark)
  create_highlight("BufferLineWarningDiagnosticVisible", palette.warning, palette.bg_alt)
  create_highlight("BufferLineWarningDiagnosticSelected", palette.warning, palette.bg)
  create_highlight("BufferLineInfo", palette.info, palette.bg_dark)
  create_highlight("BufferLineInfoVisible", palette.info, palette.bg_alt)
  create_highlight("BufferLineInfoSelected", palette.info, palette.bg)
  create_highlight("BufferLineInfoDiagnostic", palette.info, palette.bg_dark)
  create_highlight("BufferLineInfoDiagnosticVisible", palette.info, palette.bg_alt)
  create_highlight("BufferLineInfoDiagnosticSelected", palette.info, palette.bg)
  create_highlight("BufferLineHint", palette.comment, palette.bg_dark)
  create_highlight("BufferLineHintVisible", palette.comment, palette.bg_alt)
  create_highlight("BufferLineHintSelected", palette.comment, palette.bg)
  create_highlight("BufferLineHintDiagnostic", palette.comment, palette.bg_dark)
  create_highlight("BufferLineHintDiagnosticVisible", palette.comment, palette.bg_alt)
  create_highlight("BufferLineHintDiagnosticSelected", palette.comment, palette.bg)

  -- Additional highlight groups for better coverage
  create_highlight("MatchParen", palette.warning, palette.bg_alt, "bold")
  create_highlight("NonText", palette.line_nr)
  create_highlight("Whitespace", palette.line_nr)
  create_highlight("EndOfBuffer", palette.line_nr)
end

-- Apply theme function (can be called multiple times)
function M.apply()
  apply_theme()
end

return M
