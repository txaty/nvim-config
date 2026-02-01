-- Theme switcher module with unified registry
local M = {}

-- ============================================================================
-- Unified Theme Registry (Single Source of Truth)
-- ============================================================================
-- Each theme entry contains all metadata in one place:
--   variant: "dark" or "light"
--   description: Human-readable description
--   plugin_name: Lazy.nvim plugin name for loading (nil for builtin/custom)
--   plugin_module: Lua module name for setup() call (optional)
--   setup: Setup options passed to plugin.setup() (optional)
--   colorscheme: The vim colorscheme name to apply
--   background: "dark" or "light" vim background setting
--   global: Table of vim.g variables to set before colorscheme (optional)
--   custom: true for custom themes that use special apply logic (optional)
-- ============================================================================

M.registry = {
  -- === Dark Themes ===
  tokyonight = {
    variant = "dark",
    description = "Modern Tokyo night with vibrant colors",
    plugin_name = "tokyonight.nvim",
    plugin_module = "tokyonight",
    setup = { style = "storm" },
    colorscheme = "tokyonight",
    background = "dark",
  },
  kanagawa = {
    variant = "dark",
    description = "Japanese-inspired with wave aesthetic",
    plugin_name = "kanagawa.nvim",
    plugin_module = "kanagawa",
    setup = { theme = "dragon" },
    colorscheme = "kanagawa",
    background = "dark",
  },
  catppuccin = {
    variant = "dark",
    description = "Soothing pastel colors (mocha)",
    plugin_name = "catppuccin",
    plugin_module = "catppuccin",
    setup = { flavour = "mocha" },
    colorscheme = "catppuccin",
    background = "dark",
  },
  ["rose-pine"] = {
    variant = "dark",
    description = "Soft, elegant rose pine theme",
    plugin_name = "rose-pine",
    plugin_module = "rose-pine",
    setup = { variant = "main" },
    colorscheme = "rose-pine",
    background = "dark",
  },
  nightfox = {
    variant = "dark",
    description = "Clean dark theme with good contrast",
    plugin_name = "nightfox.nvim",
    colorscheme = "nightfox",
    background = "dark",
  },
  onedark = {
    variant = "dark",
    description = "Atom-inspired one dark theme",
    plugin_name = "onedark.nvim",
    plugin_module = "onedark",
    setup = { style = "dark" },
    colorscheme = "onedark",
    background = "dark",
  },
  cyberdream = {
    variant = "dark",
    description = "Neon cyberpunk aesthetic",
    plugin_name = "cyberdream.nvim",
    colorscheme = "cyberdream",
    background = "dark",
  },
  ["gruvbox-material"] = {
    variant = "dark",
    description = "Gruvbox with softer contrast (material palette)",
    plugin_name = "gruvbox-material",
    colorscheme = "gruvbox-material",
    background = "dark",
    global = {
      gruvbox_material_background = "medium",
      gruvbox_material_foreground = "material",
      gruvbox_material_better_performance = 1,
    },
  },
  nordic = {
    variant = "dark",
    description = "Nord-inspired with Aurora colors and darker tones",
    plugin_name = "nordic.nvim",
    plugin_module = "nordic",
    setup = {},
    colorscheme = "nordic",
    background = "dark",
  },
  dracula = {
    variant = "dark",
    description = "High contrast dark theme (Lua)",
    plugin_name = "dracula.nvim",
    plugin_module = "dracula",
    setup = {},
    colorscheme = "dracula",
    background = "dark",
  },
  ayu = {
    variant = "dark",
    description = "Ayu dark - minimalist dark theme",
    plugin_name = "ayu",
    colorscheme = "ayu",
    background = "dark",
    global = { ayucolor = "dark" },
  },
  ["solarized-osaka"] = {
    variant = "dark",
    description = "Modern solarized with enriched colors",
    plugin_name = "solarized-osaka.nvim",
    plugin_module = "solarized-osaka",
    setup = {},
    colorscheme = "solarized-osaka",
    background = "dark",
  },
  jellybeans = {
    variant = "dark",
    description = "Jellybeans dark - colorful dark theme",
    plugin_name = "jellybeans",
    colorscheme = "jellybeans",
    background = "dark",
  },
  -- GitHub dark variants
  github_dark = {
    variant = "dark",
    description = "GitHub Dark - official GitHub theme",
    plugin_name = "github-theme",
    colorscheme = "github_dark",
    background = "dark",
  },
  github_dark_default = {
    variant = "dark",
    description = "GitHub Dark Default - official default dark",
    plugin_name = "github-theme",
    colorscheme = "github_dark_default",
    background = "dark",
  },
  github_dark_dimmed = {
    variant = "dark",
    description = "GitHub Dark Dimmed - softer dark variant",
    plugin_name = "github-theme",
    colorscheme = "github_dark_dimmed",
    background = "dark",
  },
  github_dark_high_contrast = {
    variant = "dark",
    description = "GitHub Dark High Contrast - enhanced visibility",
    plugin_name = "github-theme",
    colorscheme = "github_dark_high_contrast",
    background = "dark",
  },
  github_dark_colorblind = {
    variant = "dark",
    description = "GitHub Dark Colorblind - protanopia/deuteranopia",
    plugin_name = "github-theme",
    colorscheme = "github_dark_colorblind",
    background = "dark",
  },
  github_dark_tritanopia = {
    variant = "dark",
    description = "GitHub Dark Tritanopia - tritanopia accessible",
    plugin_name = "github-theme",
    colorscheme = "github_dark_tritanopia",
    background = "dark",
  },
  -- New dark themes
  everforest = {
    variant = "dark",
    description = "Green-based comfortable colorscheme",
    plugin_name = "everforest",
    colorscheme = "everforest",
    background = "dark",
  },
  duskfox = {
    variant = "dark",
    description = "Nightfox variant with dusk tones",
    plugin_name = "nightfox.nvim",
    colorscheme = "duskfox",
    background = "dark",
  },
  nordfox = {
    variant = "dark",
    description = "Nightfox variant inspired by Nord",
    plugin_name = "nightfox.nvim",
    colorscheme = "nordfox",
    background = "dark",
  },
  terafox = {
    variant = "dark",
    description = "Nightfox variant with terra tones",
    plugin_name = "nightfox.nvim",
    colorscheme = "terafox",
    background = "dark",
  },
  carbonfox = {
    variant = "dark",
    description = "Nightfox variant with carbon tones",
    plugin_name = "nightfox.nvim",
    colorscheme = "carbonfox",
    background = "dark",
  },
  material = {
    variant = "dark",
    description = "Material design dark theme",
    plugin_name = "material.nvim",
    plugin_module = "material",
    setup = {},
    colorscheme = "material",
    background = "dark",
  },
  vscode = {
    variant = "dark",
    description = "VS Code Dark+ lookalike",
    plugin_name = "vscode.nvim",
    plugin_module = "vscode",
    setup = { style = "dark" },
    colorscheme = "vscode",
    background = "dark",
  },
  moonfly = {
    variant = "dark",
    description = "Dark theme with moonlit colors",
    plugin_name = "vim-moonfly-colors",
    colorscheme = "moonfly",
    background = "dark",
  },
  nightfly = {
    variant = "dark",
    description = "Dark theme inspired by night flights",
    plugin_name = "vim-nightfly-guicolors",
    colorscheme = "nightfly",
    background = "dark",
  },
  melange = {
    variant = "dark",
    description = "Warm, cozy dark theme",
    plugin_name = "melange-nvim",
    colorscheme = "melange",
    background = "dark",
  },
  zenbones = {
    variant = "dark",
    description = "Minimal, readability-focused dark theme",
    plugin_name = "zenbones.nvim",
    colorscheme = "zenbones",
    background = "dark",
  },
  oxocarbon = {
    variant = "dark",
    description = "IBM Carbon design system theme",
    plugin_name = "oxocarbon.nvim",
    colorscheme = "oxocarbon",
    background = "dark",
  },
  -- Dracula soft variant
  ["dracula-soft"] = {
    variant = "dark",
    description = "Dracula with softer contrast",
    plugin_name = "dracula.nvim",
    plugin_module = "dracula",
    setup = {},
    colorscheme = "dracula-soft",
    background = "dark",
  },
  -- Sonokai variants (Monokai Pro family)
  sonokai = {
    variant = "dark",
    description = "Monokai Pro-inspired with balanced contrast",
    plugin_name = "sonokai",
    colorscheme = "sonokai",
    background = "dark",
    global = { sonokai_style = "default", sonokai_better_performance = 1 },
  },
  ["sonokai-atlantis"] = {
    variant = "dark",
    description = "Sonokai Atlantis - oceanic Monokai variant",
    plugin_name = "sonokai",
    colorscheme = "sonokai",
    background = "dark",
    global = { sonokai_style = "atlantis", sonokai_better_performance = 1 },
  },
  ["sonokai-andromeda"] = {
    variant = "dark",
    description = "Sonokai Andromeda - cosmic Monokai variant",
    plugin_name = "sonokai",
    colorscheme = "sonokai",
    background = "dark",
    global = { sonokai_style = "andromeda", sonokai_better_performance = 1 },
  },
  ["sonokai-shusia"] = {
    variant = "dark",
    description = "Sonokai Shusia - warm Monokai variant",
    plugin_name = "sonokai",
    colorscheme = "sonokai",
    background = "dark",
    global = { sonokai_style = "shusia", sonokai_better_performance = 1 },
  },
  ["sonokai-maia"] = {
    variant = "dark",
    description = "Sonokai Maia - earthy Monokai variant",
    plugin_name = "sonokai",
    colorscheme = "sonokai",
    background = "dark",
    global = { sonokai_style = "maia", sonokai_better_performance = 1 },
  },
  ["sonokai-espresso"] = {
    variant = "dark",
    description = "Sonokai Espresso - coffee Monokai variant",
    plugin_name = "sonokai",
    colorscheme = "sonokai",
    background = "dark",
    global = { sonokai_style = "espresso", sonokai_better_performance = 1 },
  },
  -- Edge variants (Atom One + Material hybrid)
  edge = {
    variant = "dark",
    description = "Clean, elegant Atom One + Material hybrid",
    plugin_name = "edge",
    colorscheme = "edge",
    background = "dark",
    global = { edge_style = "default", edge_better_performance = 1 },
  },
  ["edge-aura"] = {
    variant = "dark",
    description = "Edge Aura - alternative dark palette",
    plugin_name = "edge",
    colorscheme = "edge",
    background = "dark",
    global = { edge_style = "aura", edge_better_performance = 1 },
  },
  ["edge-neon"] = {
    variant = "dark",
    description = "Edge Neon - vibrant dark variant",
    plugin_name = "edge",
    colorscheme = "edge",
    background = "dark",
    global = { edge_style = "neon", edge_better_performance = 1 },
  },
  -- Lackluster variants (monochrome/minimal)
  lackluster = {
    variant = "dark",
    description = "Monochrome - delightful mostly grayscale",
    plugin_name = "lackluster.nvim",
    colorscheme = "lackluster",
    background = "dark",
  },
  ["lackluster-hack"] = {
    variant = "dark",
    description = "Lackluster Hack - green returns, blue exceptions",
    plugin_name = "lackluster.nvim",
    colorscheme = "lackluster-hack",
    background = "dark",
  },
  ["lackluster-mint"] = {
    variant = "dark",
    description = "Lackluster Mint - green types accent",
    plugin_name = "lackluster.nvim",
    colorscheme = "lackluster-mint",
    background = "dark",
  },
  -- Bamboo variants (green-focused, low-blue)
  bamboo = {
    variant = "dark",
    description = "Green-focused, low-blue eye comfort theme",
    plugin_name = "bamboo.nvim",
    plugin_module = "bamboo",
    setup = { style = "vulgaris" },
    colorscheme = "bamboo",
    background = "dark",
  },
  ["bamboo-multiplex"] = {
    variant = "dark",
    description = "Bamboo Multiplex - greener, more saturated",
    plugin_name = "bamboo.nvim",
    plugin_module = "bamboo",
    setup = { style = "multiplex" },
    colorscheme = "bamboo",
    background = "dark",
  },
  -- Modus dark variants (WCAG AAA accessible)
  modus_vivendi = {
    variant = "dark",
    description = "WCAG AAA accessible dark theme (7:1 contrast)",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = {},
    colorscheme = "modus_vivendi",
    background = "dark",
  },
  modus_vivendi_tinted = {
    variant = "dark",
    description = "WCAG AAA dark with tinted backgrounds",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = { variant = "tinted" },
    colorscheme = "modus_vivendi",
    background = "dark",
  },
  modus_vivendi_deuteranopia = {
    variant = "dark",
    description = "WCAG AAA dark - deuteranopia optimized",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = { variant = "deuteranopia" },
    colorscheme = "modus_vivendi",
    background = "dark",
  },
  modus_vivendi_tritanopia = {
    variant = "dark",
    description = "WCAG AAA dark - tritanopia optimized",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = { variant = "tritanopia" },
    colorscheme = "modus_vivendi",
    background = "dark",
  },

  -- === Light Themes ===
  ["tokyonight-day"] = {
    variant = "light",
    description = "Tokyo day - modern light theme",
    plugin_name = "tokyonight.nvim",
    plugin_module = "tokyonight",
    setup = { style = "day" },
    colorscheme = "tokyonight",
    background = "light",
  },
  ["rose-pine-dawn"] = {
    variant = "light",
    description = "Rose pine dawn - soft light variant",
    plugin_name = "rose-pine",
    plugin_module = "rose-pine",
    setup = { variant = "dawn" },
    colorscheme = "rose-pine",
    background = "light",
  },
  ["kanagawa-lotus"] = {
    variant = "light",
    description = "Kanagawa lotus - light variant",
    plugin_name = "kanagawa.nvim",
    plugin_module = "kanagawa",
    setup = { theme = "lotus" },
    colorscheme = "kanagawa",
    background = "light",
  },
  onelight = {
    variant = "light",
    description = "Atom one light theme",
    plugin_name = "onedark.nvim",
    plugin_module = "onedark",
    setup = { style = "light" },
    colorscheme = "onedark",
    background = "light",
  },
  ["ayu-light"] = {
    variant = "light",
    description = "Ayu light - minimalist light theme",
    plugin_name = "ayu",
    colorscheme = "ayu",
    background = "light",
    global = { ayucolor = "light" },
  },
  -- Edge light
  ["edge-light"] = {
    variant = "light",
    description = "Edge Light - clean elegant light theme",
    plugin_name = "edge",
    colorscheme = "edge",
    background = "light",
    global = { edge_style = "default", edge_better_performance = 1 },
  },
  papercolor = {
    variant = "light",
    description = "PaperColor - clean paper-like appearance",
    plugin_name = "papercolor",
    colorscheme = "PaperColor",
    background = "light",
  },
  ["papercolor-light"] = {
    variant = "light",
    description = "PaperColor light - clean paper-like appearance",
    plugin_name = "papercolor",
    colorscheme = "PaperColor",
    background = "light",
  },
  omni = {
    variant = "light",
    description = "Omni - modern light theme",
    plugin_name = "omni",
    colorscheme = "omni",
    background = "light",
  },
  ["jellybeans-light"] = {
    variant = "light",
    description = "Jellybeans light - colorful light variant",
    plugin_name = "jellybeans",
    colorscheme = "jellybeans",
    background = "light",
  },
  dayfox = {
    variant = "light",
    description = "Day fox - light fox variant",
    plugin_name = "nightfox.nvim",
    colorscheme = "dayfox",
    background = "light",
  },
  ["gruvbox-material-light"] = {
    variant = "light",
    description = "Gruvbox Material light - warm soft colors",
    plugin_name = "gruvbox-material",
    colorscheme = "gruvbox-material",
    background = "light",
    global = {
      gruvbox_material_background = "medium",
      gruvbox_material_foreground = "material",
      gruvbox_material_better_performance = 1,
    },
  },
  -- GitHub light variants
  github_light = {
    variant = "light",
    description = "GitHub Light - official GitHub theme",
    plugin_name = "github-theme",
    colorscheme = "github_light",
    background = "light",
  },
  github_light_default = {
    variant = "light",
    description = "GitHub Light Default - official default light",
    plugin_name = "github-theme",
    colorscheme = "github_light_default",
    background = "light",
  },
  github_light_high_contrast = {
    variant = "light",
    description = "GitHub Light High Contrast - enhanced visibility",
    plugin_name = "github-theme",
    colorscheme = "github_light_high_contrast",
    background = "light",
  },
  github_light_colorblind = {
    variant = "light",
    description = "GitHub Light Colorblind - protanopia/deuteranopia",
    plugin_name = "github-theme",
    colorscheme = "github_light_colorblind",
    background = "light",
  },
  -- New light themes
  ["everforest-light"] = {
    variant = "light",
    description = "Green-based comfortable light colorscheme",
    plugin_name = "everforest",
    colorscheme = "everforest",
    background = "light",
  },
  dawnfox = {
    variant = "light",
    description = "Nightfox dawn variant - soft light theme",
    plugin_name = "nightfox.nvim",
    colorscheme = "dawnfox",
    background = "light",
  },
  ["material-lighter"] = {
    variant = "light",
    description = "Material design light theme",
    plugin_name = "material.nvim",
    plugin_module = "material",
    setup = { style = "lighter" },
    colorscheme = "material",
    background = "light",
  },
  ["vscode-light"] = {
    variant = "light",
    description = "VS Code Light+ lookalike",
    plugin_name = "vscode.nvim",
    plugin_module = "vscode",
    setup = { style = "light" },
    colorscheme = "vscode",
    background = "light",
  },
  ["zenbones-light"] = {
    variant = "light",
    description = "Minimal, readability-focused light theme",
    plugin_name = "zenbones.nvim",
    colorscheme = "zenbones",
    background = "light",
  },
  -- Bamboo light
  ["bamboo-light"] = {
    variant = "light",
    description = "Bamboo light - green-focused light theme",
    plugin_name = "bamboo.nvim",
    plugin_module = "bamboo",
    setup = { style = "vulgaris" },
    colorscheme = "bamboo",
    background = "light",
  },
  -- Modus light variants (WCAG AAA accessible)
  modus_operandi = {
    variant = "light",
    description = "WCAG AAA accessible light theme (7:1 contrast)",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = {},
    colorscheme = "modus_operandi",
    background = "light",
  },
  modus_operandi_tinted = {
    variant = "light",
    description = "WCAG AAA light with tinted backgrounds",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = { variant = "tinted" },
    colorscheme = "modus_operandi",
    background = "light",
  },
  modus_operandi_deuteranopia = {
    variant = "light",
    description = "WCAG AAA light - deuteranopia optimized",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = { variant = "deuteranopia" },
    colorscheme = "modus_operandi",
    background = "light",
  },
  modus_operandi_tritanopia = {
    variant = "light",
    description = "WCAG AAA light - tritanopia optimized",
    plugin_name = "modus-themes.nvim",
    plugin_module = "modus-themes",
    setup = { variant = "tritanopia" },
    colorscheme = "modus_operandi",
    background = "light",
  },

  -- === Custom Themes ===
  txaty = {
    variant = "dark",
    description = "Custom: Low-saturation ergonomic dark theme",
    plugin_name = nil,
    colorscheme = nil,
    custom = true,
    custom_variant = "dark",
  },
  ["txaty-light"] = {
    variant = "light",
    description = "Custom: Low-saturation ergonomic light theme",
    plugin_name = nil,
    colorscheme = nil,
    custom = true,
    custom_variant = "light",
  },
}

-- ============================================================================
-- Backward-Compatible Computed Views (lazy-initialized on first access)
-- ============================================================================

local function build_themes()
  local themes = { dark = {}, light = {} }
  for name, info in pairs(M.registry) do
    if not info.custom then
      if info.variant == "dark" then
        table.insert(themes.dark, name)
      elseif info.variant == "light" then
        table.insert(themes.light, name)
      end
    end
  end
  table.sort(themes.dark)
  table.sort(themes.light)
  return themes
end

local function build_theme_info()
  local info_map = {}
  for name, info in pairs(M.registry) do
    info_map[name] = {
      variant = info.variant,
      description = info.description,
    }
  end
  return info_map
end

-- Lazy init: build on first access, then cache as regular fields
setmetatable(M, {
  __index = function(t, k)
    if k == "themes" then
      local v = build_themes()
      rawset(t, k, v)
      return v
    elseif k == "theme_info" then
      local v = build_theme_info()
      rawset(t, k, v)
      return v
    end
  end,
})

-- ============================================================================
-- Persistence
-- ============================================================================
local config_path = vim.fn.stdpath "data" .. "/theme_config.json"

-- Load persisted theme preference (returns full config table)
local function load_config()
  local stat = vim.uv.fs_stat(config_path)
  if not stat then
    return {}
  end

  local fd = vim.uv.fs_open(config_path, "r", 438)
  if not fd then
    return {}
  end

  local content = vim.uv.fs_read(fd, stat.size, 0)
  vim.uv.fs_close(fd)

  if not content or content == "" then
    return {}
  end

  local ok, result = pcall(vim.json.decode, content)
  if ok and type(result) == "table" then
    return result
  end

  vim.notify("Theme config corrupted, using defaults. Delete " .. config_path .. " to reset.", vim.log.levels.WARN)
  return {}
end

-- Save config to file
local function save_config(config)
  local json_str = vim.json.encode(config)
  local fd = vim.uv.fs_open(config_path, "w", 438)
  if fd then
    vim.uv.fs_write(fd, json_str, 0)
    vim.uv.fs_close(fd)
  end
end

-- Load saved theme name (public API for backward compatibility)
function M.load_saved_theme()
  local config = load_config()
  return config.theme
end

-- Save theme preference (updates theme and last_dark/last_light)
function M.save_theme(theme_name)
  local config = load_config()
  config.theme = theme_name

  -- Update per-category last-used
  local info = M.registry[theme_name]
  if info then
    if info.variant == "dark" then
      config.last_dark = theme_name
    elseif info.variant == "light" then
      config.last_light = theme_name
    end
  end

  save_config(config)
end

-- ============================================================================
-- Plugin Loading
-- ============================================================================

-- Load a colorscheme plugin if needed (for lazy-loaded plugins)
local function ensure_plugin_loaded(theme_name)
  local info = M.registry[theme_name]
  if info and info.plugin_name then
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
      lazy.load { plugins = { info.plugin_name } }
    end
  end
  return true
end

-- ============================================================================
-- UI Refresh
-- ============================================================================

-- Refresh UI components after theme change
local function refresh_ui()
  vim.schedule(function()
    -- Refresh lualine if available
    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine and lualine.refresh then
      pcall(lualine.refresh)
    end

    -- Refresh nvim-tree if available
    local ok_nvimtree, nvimtree_api = pcall(require, "nvim-tree.api")
    if ok_nvimtree and nvimtree_api.tree and nvimtree_api.tree.reload then
      pcall(nvimtree_api.tree.reload)
    end

    -- Force redraw tabline (bufferline handles its own refresh via ColorScheme autocmd)
    vim.cmd "redrawtabline"
  end)
end

-- ============================================================================
-- Safe Colorscheme Application
-- ============================================================================

local DEFAULT_FALLBACK = "default"

-- Safely apply a colorscheme with error handling and fallback
local function safe_colorscheme(colorscheme_name)
  local ok, err = pcall(vim.cmd.colorscheme, colorscheme_name)
  if not ok then
    vim.notify(
      string.format(
        "Failed to load colorscheme '%s': %s. Falling back to '%s'",
        colorscheme_name,
        err,
        DEFAULT_FALLBACK
      ),
      vim.log.levels.WARN
    )
    pcall(vim.cmd.colorscheme, DEFAULT_FALLBACK)
    return false
  end
  return true
end

-- ============================================================================
-- Preview State
-- ============================================================================

-- When true, the ColorScheme autocmd in autocmds.lua skips auto-saving.
-- Set by the theme picker during live preview.
M._previewing = false

-- ============================================================================
-- Theme Application (Unified)
-- ============================================================================

--- Apply a theme by registry name.
--- Single codepath for all theme changes (preview, confirm, restore).
---@param theme_name string  Registry key (e.g. "catppuccin", "txaty")
---@param opts? {save: boolean, notify: boolean}  Defaults: save=true, notify=true
---@return boolean success
function M.apply(theme_name, opts)
  opts = vim.tbl_extend("keep", opts or {}, { save = true, notify = true })

  local info = M.registry[theme_name]
  if not info then
    vim.notify("Theme '" .. theme_name .. "' not found in registry", vim.log.levels.WARN)
    return false
  end

  -- Ensure the plugin is loaded before applying
  ensure_plugin_loaded(theme_name)

  -- Always clear previous state for a clean slate (prevents highlight leaks)
  vim.cmd "highlight clear"
  if vim.fn.exists "syntax_on" then
    vim.cmd "syntax reset"
  end

  -- Handle custom theme (txaty and txaty-light)
  if info.custom then
    local custom_variant = info.custom_variant or "dark"
    require("core.theme_txaty").apply(custom_variant)
  else
    -- Set global variables if specified
    if info.global then
      for key, value in pairs(info.global) do
        vim.g[key] = value
      end
    end

    -- Set background before applying (some themes need this)
    if info.background then
      vim.o.background = info.background
    end

    -- Run plugin setup if specified
    if info.plugin_module and info.setup then
      local ok, plugin = pcall(require, info.plugin_module)
      if ok and plugin.setup then
        plugin.setup(info.setup)
      end
    end

    -- Apply colorscheme with error handling
    if info.colorscheme then
      if not safe_colorscheme(info.colorscheme) then
        return false
      end
    end
  end

  refresh_ui()

  if opts.save then
    M.save_theme(theme_name)
  end
  if opts.notify then
    vim.notify("Theme: " .. theme_name, vim.log.levels.INFO)
  end

  return true
end

-- ============================================================================
-- Backward-Compatibility Shims
-- ============================================================================

--- Apply theme and save preference (legacy API)
function M.apply_theme(theme_name)
  return M.apply(theme_name)
end

--- Restore saved theme without saving again (used on startup)
function M.restore_theme()
  local saved_theme = M.load_saved_theme()
  if saved_theme then
    return M.apply(saved_theme, { save = false, notify = false })
  end
  return false
end

-- ============================================================================
-- Smart Variant Switching (remembers last-used per category)
-- ============================================================================

-- Switch to last-used dark theme (or first dark theme if none saved)
function M.switch_to_dark()
  local config = load_config()
  local target = config.last_dark

  -- Validate target exists and is dark
  if not target or not M.registry[target] or M.registry[target].variant ~= "dark" then
    -- Fall back to first dark theme
    if #M.themes.dark > 0 then
      target = M.themes.dark[1]
    else
      vim.notify("No dark themes available", vim.log.levels.WARN)
      return false
    end
  end

  return M.apply_theme(target)
end

-- Switch to last-used light theme (or first light theme if none saved)
function M.switch_to_light()
  local config = load_config()
  local target = config.last_light

  -- Validate target exists and is light
  if not target or not M.registry[target] or M.registry[target].variant ~= "light" then
    -- Fall back to first light theme
    if #M.themes.light > 0 then
      target = M.themes.light[1]
    else
      vim.notify("No light themes available", vim.log.levels.WARN)
      return false
    end
  end

  return M.apply_theme(target)
end

-- ============================================================================
-- Public API
-- ============================================================================

-- Get all available themes (flat list)
function M.get_all_themes()
  local all_themes = {}
  for _, theme in ipairs(M.themes.dark) do
    table.insert(all_themes, theme)
  end
  for _, theme in ipairs(M.themes.light) do
    table.insert(all_themes, theme)
  end
  -- Add custom themes
  table.insert(all_themes, "txaty")
  table.insert(all_themes, "txaty-light")
  return all_themes
end

-- Get theme variants (dark/light)
function M.get_themes_by_variant(variant)
  if variant == "dark" then
    return M.themes.dark
  elseif variant == "light" then
    return M.themes.light
  else
    return {}
  end
end

-- Get registry entry for a theme (new API)
function M.get_theme_info(theme_name)
  return M.registry[theme_name]
end

return M
