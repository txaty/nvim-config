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
  gruvbox = {
    variant = "dark",
    description = "Retro groove with warm colors",
    plugin_name = "gruvbox",
    colorscheme = "gruvbox",
    background = "dark",
  },
  nord = {
    variant = "dark",
    description = "Arctic, north-bluish theme",
    plugin_name = "nord",
    colorscheme = "nord",
    background = "dark",
  },
  dracula = {
    variant = "dark",
    description = "High contrast dark theme",
    plugin_name = "dracula",
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
  solarized = {
    variant = "dark",
    description = "Solarized dark - scientific color palette",
    plugin_name = "solarized",
    colorscheme = "solarized",
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
  ["solarized-light"] = {
    variant = "light",
    description = "Solarized light - scientific color palette",
    plugin_name = "solarized",
    colorscheme = "solarized",
    background = "light",
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
  ["gruvbox-light"] = {
    variant = "light",
    description = "Retro groove light - warm light colors",
    plugin_name = "gruvbox",
    colorscheme = "gruvbox",
    background = "light",
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
-- Backward-Compatible Computed Views
-- ============================================================================
-- These are computed from the registry for backward compatibility

-- Build M.themes (dark/light arrays) from registry
M.themes = { dark = {}, light = {} }
for name, info in pairs(M.registry) do
  if not info.custom then
    if info.variant == "dark" then
      table.insert(M.themes.dark, name)
    elseif info.variant == "light" then
      table.insert(M.themes.light, name)
    end
  end
end
-- Sort for consistent ordering
table.sort(M.themes.dark)
table.sort(M.themes.light)

-- Build M.theme_info from registry (for backward compatibility)
M.theme_info = {}
for name, info in pairs(M.registry) do
  M.theme_info[name] = {
    variant = info.variant,
    description = info.description,
  }
end

-- ============================================================================
-- Persistence
-- ============================================================================
local config_path = vim.fn.stdpath "data" .. "/theme_config.json"

-- Load persisted theme preference (returns full config table)
local function load_config()
  if vim.fn.filereadable(config_path) == 1 then
    local content = vim.fn.readfile(config_path)
    local raw = table.concat(content, "")
    local ok, result = pcall(vim.json.decode, raw)
    if ok and type(result) == "table" then
      return result
    elseif raw ~= "" then
      vim.notify("Theme config corrupted, using defaults. Delete " .. config_path .. " to reset.", vim.log.levels.WARN)
    end
  end
  return {}
end

-- Save config to file
local function save_config(config)
  local json_str = vim.json.encode(config)
  vim.fn.writefile(vim.split(json_str, "\n"), config_path)
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
-- Theme Application
-- ============================================================================

-- Apply theme (internal function that can skip saving)
local function apply_theme_internal(theme_name, should_save)
  local info = M.registry[theme_name]
  if not info then
    vim.notify("Theme '" .. theme_name .. "' not found in registry", vim.log.levels.WARN)
    return false
  end

  -- Ensure the plugin is loaded before applying
  ensure_plugin_loaded(theme_name)

  -- Clear any previous colorscheme state to prevent conflicts
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

  if should_save then
    M.save_theme(theme_name)
    vim.notify("Theme: " .. theme_name, vim.log.levels.INFO)
  end

  return true
end

-- Apply theme and save preference
function M.apply_theme(theme_name)
  return apply_theme_internal(theme_name, true)
end

-- Apply theme for preview only (no save, no notification).
-- This version does NOT redraw to prevent UI drift in Telescope.
function M.preview_theme(theme_name)
  local info = M.registry[theme_name]
  if not info then
    return false
  end

  ensure_plugin_loaded(theme_name)

  if info.custom then
    require("core.theme_txaty").apply(info.custom_variant or "dark", { preview = true })
    return true
  end

  if info.global then
    for key, value in pairs(info.global) do
      vim.g[key] = value
    end
  end

  if info.background then
    vim.o.background = info.background
  end

  if info.plugin_module and info.setup then
    local ok, plugin = pcall(require, info.plugin_module)
    if ok and plugin.setup then
      plugin.setup(info.setup)
    end
  end

  if info.colorscheme then
    pcall(vim.cmd.colorscheme, info.colorscheme)
  end

  return true
end

-- Restore saved theme without saving again (used on startup)
function M.restore_theme()
  local saved_theme = M.load_saved_theme()
  if saved_theme then
    return apply_theme_internal(saved_theme, false)
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
