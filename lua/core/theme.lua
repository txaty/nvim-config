-- Theme switcher module for seamless theme switching
local M = {}

-- Theme configuration
M.themes = {
  -- Dark themes (optimized for coding)
  dark = {
    "tokyonight",
    "kanagawa",
    "catppuccin",
    "rose-pine",
    "nightfox",
    "onedark",
    "cyberdream",
    "gruvbox",
    "nord",
    "dracula",
    "ayu",
    "solarized",
    "jellybeans",
    "github_dark",
    "github_dark_default",
    "github_dark_dimmed",
    "github_dark_high_contrast",
    "github_dark_colorblind",
    "github_dark_tritanopia",
  },
  -- Light themes (optimized for coding)
  light = {
    "tokyonight-day",
    "rose-pine-dawn",
    "kanagawa-lotus",
    "onelight",
    "ayu-light",
    "solarized-light",
    "papercolor",
    "papercolor-light",
    "omni",
    "jellybeans-light",
    "dayfox",
    "gruvbox-light",
    "github_light",
    "github_light_default",
    "github_light_high_contrast",
    "github_light_colorblind",
  },
}

M.theme_info = {
  -- Dark themes
  tokyonight = { variant = "dark", description = "Modern Tokyo night with vibrant colors" },
  kanagawa = { variant = "dark", description = "Japanese-inspired with wave aesthetic" },
  catppuccin = { variant = "dark", description = "Soothing pastel colors (mocha)" },
  ["rose-pine"] = { variant = "dark", description = "Soft, elegant rose pine theme" },
  nightfox = { variant = "dark", description = "Clean dark theme with good contrast" },
  onedark = { variant = "dark", description = "Atom-inspired one dark theme" },
  cyberdream = { variant = "dark", description = "Neon cyberpunk aesthetic" },
  gruvbox = { variant = "dark", description = "Retro groove with warm colors" },
  nord = { variant = "dark", description = "Arctic, north-bluish theme" },
  dracula = { variant = "dark", description = "High contrast dark theme" },
  ayu = { variant = "dark", description = "Ayu dark - minimalist dark theme" },
  solarized = { variant = "dark", description = "Solarized dark - scientific color palette" },
  jellybeans = { variant = "dark", description = "Jellybeans dark - colorful dark theme" },
  github_dark = { variant = "dark", description = "GitHub Dark - official GitHub theme" },
  github_dark_default = { variant = "dark", description = "GitHub Dark Default - official default dark" },
  github_dark_dimmed = { variant = "dark", description = "GitHub Dark Dimmed - softer dark variant" },
  github_dark_high_contrast = { variant = "dark", description = "GitHub Dark High Contrast - enhanced visibility" },
  github_dark_colorblind = { variant = "dark", description = "GitHub Dark Colorblind - protanopia/deuteranopia" },
  github_dark_tritanopia = { variant = "dark", description = "GitHub Dark Tritanopia - tritanopia accessible" },

  -- Light themes
  ["tokyonight-day"] = { variant = "light", description = "Tokyo day - modern light theme" },
  ["rose-pine-dawn"] = { variant = "light", description = "Rose pine dawn - soft light variant" },
  ["kanagawa-lotus"] = { variant = "light", description = "Kanagawa lotus - light variant" },
  onelight = { variant = "light", description = "Atom one light theme" },
  ["ayu-light"] = { variant = "light", description = "Ayu light - minimalist light theme" },
  ["solarized-light"] = { variant = "light", description = "Solarized light - scientific color palette" },
  papercolor = { variant = "light", description = "PaperColor - clean paper-like appearance" },
  ["papercolor-light"] = { variant = "light", description = "PaperColor light - clean paper-like appearance" },
  omni = { variant = "light", description = "Omni - modern light theme" },
  ["jellybeans-light"] = { variant = "light", description = "Jellybeans light - colorful light variant" },
  dayfox = { variant = "light", description = "Day fox - light fox variant" },
  ["gruvbox-light"] = { variant = "light", description = "Retro groove light - warm light colors" },
  github_light = { variant = "light", description = "GitHub Light - official GitHub theme" },
  github_light_default = { variant = "light", description = "GitHub Light Default - official default light" },
  github_light_high_contrast = { variant = "light", description = "GitHub Light High Contrast - enhanced visibility" },
  github_light_colorblind = { variant = "light", description = "GitHub Light Colorblind - protanopia/deuteranopia" },

  -- Custom theme
  txaty = { variant = "dark", description = "Custom: Low-saturation pure dark ergonomic theme" },
}

local config_path = vim.fn.stdpath "data" .. "/theme_config.json"

-- Map theme names to their plugin names for lazy loading
local theme_to_plugin = {
  catppuccin = "catppuccin",
  tokyonight = "tokyonight.nvim",
  ["tokyonight-day"] = "tokyonight.nvim",
  kanagawa = "kanagawa.nvim",
  ["kanagawa-lotus"] = "kanagawa.nvim",
  ["rose-pine"] = "rose-pine",
  ["rose-pine-dawn"] = "rose-pine",
  nightfox = "nightfox.nvim",
  dayfox = "nightfox.nvim",
  onedark = "onedark.nvim",
  onelight = "onedark.nvim",
  cyberdream = "cyberdream.nvim",
  gruvbox = "gruvbox",
  ["gruvbox-light"] = "gruvbox",
  nord = "nord",
  dracula = "dracula",
  omni = "omni",
  papercolor = "papercolor",
  ["papercolor-light"] = "papercolor",
  ayu = "ayu",
  ["ayu-light"] = "ayu",
  solarized = "solarized",
  ["solarized-light"] = "solarized",
  jellybeans = "jellybeans",
  ["jellybeans-light"] = "jellybeans",
  github_dark = "github-theme",
  github_dark_default = "github-theme",
  github_dark_dimmed = "github-theme",
  github_dark_high_contrast = "github-theme",
  github_dark_colorblind = "github-theme",
  github_dark_tritanopia = "github-theme",
  github_light = "github-theme",
  github_light_default = "github-theme",
  github_light_high_contrast = "github-theme",
  github_light_colorblind = "github-theme",
  txaty = nil, -- Custom theme, no plugin needed
}

-- Load a colorscheme plugin if needed (for lazy-loaded plugins)
local function ensure_plugin_loaded(theme_name)
  local plugin_name = theme_to_plugin[theme_name]
  if plugin_name then
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
      lazy.load { plugins = { plugin_name } }
      return true
    end
  end
  return true -- txaty or already loaded
end

-- Load persisted theme preference
function M.load_saved_theme()
  if vim.fn.filereadable(config_path) == 1 then
    local content = vim.fn.readfile(config_path)
    local ok, result = pcall(vim.json.decode, table.concat(content, ""))
    if ok and result.theme then
      return result.theme
    end
  end
  return nil
end

-- Save theme preference
function M.save_theme(theme_name)
  local data = { theme = theme_name }
  local json_str = vim.json.encode(data)
  vim.fn.writefile(vim.split(json_str, "\n"), config_path)
end

-- Apply theme (internal function that can skip saving)
local function apply_theme_internal(theme_name, should_save)
  if not M.theme_info[theme_name] then
    vim.notify("Theme '" .. theme_name .. "' not found", vim.log.levels.WARN)
    return false
  end

  -- Ensure the plugin is loaded before applying
  ensure_plugin_loaded(theme_name)

  -- Clear any previous colorscheme state to prevent conflicts
  vim.cmd "highlight clear"
  if vim.fn.exists "syntax_on" then
    vim.cmd "syntax reset"
  end

  -- Special handling for different theme engines
  if theme_name == "tokyonight-day" then
    require("tokyonight").setup { style = "day" }
    vim.cmd.colorscheme "tokyonight"
    vim.o.background = "light"
  elseif theme_name == "tokyonight" then
    require("tokyonight").setup { style = "storm" }
    vim.cmd.colorscheme "tokyonight"
    vim.o.background = "dark"
  elseif theme_name == "rose-pine-dawn" then
    require("rose-pine").setup { variant = "dawn" }
    vim.cmd.colorscheme "rose-pine"
    vim.o.background = "light"
  elseif theme_name == "rose-pine" then
    require("rose-pine").setup { variant = "main" }
    vim.cmd.colorscheme "rose-pine"
    vim.o.background = "dark"
  elseif theme_name == "kanagawa-lotus" then
    require("kanagawa").setup { theme = "lotus" }
    vim.cmd.colorscheme "kanagawa"
    vim.o.background = "light"
  elseif theme_name == "kanagawa" then
    require("kanagawa").setup { theme = "dragon" }
    vim.cmd.colorscheme "kanagawa"
    vim.o.background = "dark"
  elseif theme_name == "onedark" then
    require("onedark").setup { style = "dark" }
    vim.cmd.colorscheme "onedark"
    vim.o.background = "dark"
  elseif theme_name == "onelight" then
    require("onedark").setup { style = "light" }
    vim.cmd.colorscheme "onedark"
    vim.o.background = "light"
  elseif theme_name == "gruvbox" then
    vim.cmd.colorscheme "gruvbox"
    vim.o.background = "dark"
  elseif theme_name == "nord" then
    vim.cmd.colorscheme "nord"
    vim.o.background = "dark"
  elseif theme_name == "dracula" then
    vim.cmd.colorscheme "dracula"
    vim.o.background = "dark"
  elseif theme_name == "cyberdream" then
    vim.cmd.colorscheme "cyberdream"
    vim.o.background = "dark"
  elseif theme_name == "catppuccin" then
    require("catppuccin").setup { flavour = "mocha" }
    vim.cmd.colorscheme "catppuccin"
    vim.o.background = "dark"
  elseif theme_name == "nightfox" then
    vim.cmd.colorscheme "nightfox"
    vim.o.background = "dark"
  elseif theme_name == "dayfox" then
    vim.cmd.colorscheme "dayfox"
    vim.o.background = "light"
  elseif theme_name == "ayu" then
    vim.g.ayucolor = "dark"
    vim.cmd.colorscheme "ayu"
    vim.o.background = "dark"
  elseif theme_name == "ayu-light" then
    vim.g.ayucolor = "light"
    vim.cmd.colorscheme "ayu"
    vim.o.background = "light"
  elseif theme_name == "solarized" then
    vim.cmd.colorscheme "solarized"
    vim.o.background = "dark"
  elseif theme_name == "solarized-light" then
    vim.cmd.colorscheme "solarized"
    vim.o.background = "light"
  elseif theme_name == "jellybeans" then
    vim.cmd.colorscheme "jellybeans"
    vim.o.background = "dark"
  elseif theme_name == "jellybeans-light" then
    vim.cmd.colorscheme "jellybeans"
    vim.o.background = "light"
  elseif theme_name == "gruvbox-light" then
    vim.cmd.colorscheme "gruvbox"
    vim.o.background = "light"
  elseif theme_name == "papercolor" or theme_name == "papercolor-light" then
    vim.cmd.colorscheme "PaperColor"
    vim.o.background = "light"
  elseif theme_name == "omni" then
    vim.cmd.colorscheme "omni"
    vim.o.background = "light"
  elseif theme_name == "github_dark" then
    vim.cmd.colorscheme "github_dark"
    vim.o.background = "dark"
  elseif theme_name == "github_dark_default" then
    vim.cmd.colorscheme "github_dark_default"
    vim.o.background = "dark"
  elseif theme_name == "github_dark_dimmed" then
    vim.cmd.colorscheme "github_dark_dimmed"
    vim.o.background = "dark"
  elseif theme_name == "github_dark_high_contrast" then
    vim.cmd.colorscheme "github_dark_high_contrast"
    vim.o.background = "dark"
  elseif theme_name == "github_dark_colorblind" then
    vim.cmd.colorscheme "github_dark_colorblind"
    vim.o.background = "dark"
  elseif theme_name == "github_dark_tritanopia" then
    vim.cmd.colorscheme "github_dark_tritanopia"
    vim.o.background = "dark"
  elseif theme_name == "github_light" then
    vim.cmd.colorscheme "github_light"
    vim.o.background = "light"
  elseif theme_name == "github_light_default" then
    vim.cmd.colorscheme "github_light_default"
    vim.o.background = "light"
  elseif theme_name == "github_light_high_contrast" then
    vim.cmd.colorscheme "github_light_high_contrast"
    vim.o.background = "light"
  elseif theme_name == "github_light_colorblind" then
    vim.cmd.colorscheme "github_light_colorblind"
    vim.o.background = "light"
  elseif theme_name == "txaty" then
    require("core.theme_txaty").apply()
  else
    vim.cmd.colorscheme(theme_name)
  end

  -- Refresh UI components after theme change
  vim.schedule(function()
    -- Refresh bufferline if available
    local ok_bufferline, bufferline = pcall(require, "bufferline")
    if ok_bufferline and bufferline.setup then
      -- Get current config and reapply
      local config = require "bufferline.config"
      if config and config.apply then
        pcall(config.apply)
      end
    end

    -- Refresh lualine if available
    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine and lualine.setup then
      -- Lualine auto-detects theme changes, but we can force a refresh
      pcall(lualine.refresh)
    end
  end)

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

-- Restore saved theme without saving again (used on startup)
function M.restore_theme()
  local saved_theme = M.load_saved_theme()
  if saved_theme then
    return apply_theme_internal(saved_theme, false)
  end
  return false
end

-- Get all available themes
function M.get_all_themes()
  local all_themes = {}
  for _, theme in ipairs(M.themes.dark) do
    table.insert(all_themes, theme)
  end
  for _, theme in ipairs(M.themes.light) do
    table.insert(all_themes, theme)
  end
  table.insert(all_themes, "txaty") -- Add custom theme
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

return M
