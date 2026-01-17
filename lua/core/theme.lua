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
    "omni",
    "jellybeans-light",
    "dayfox",
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

  -- Light themes
  ["tokyonight-day"] = { variant = "light", description = "Tokyo day - modern light theme" },
  ["rose-pine-dawn"] = { variant = "light", description = "Rose pine dawn - soft light variant" },
  ["kanagawa-lotus"] = { variant = "light", description = "Kanagawa lotus - light variant" },
  onelight = { variant = "light", description = "Atom one light theme" },
  ["ayu-light"] = { variant = "light", description = "Ayu light - minimalist light theme" },
  ["solarized-light"] = { variant = "light", description = "Solarized light - scientific color palette" },
  papercolor = { variant = "light", description = "PaperColor - clean paper-like appearance" },
  omni = { variant = "light", description = "Omni - modern light theme" },
  ["jellybeans-light"] = { variant = "light", description = "Jellybeans light - colorful light variant" },
  dayfox = { variant = "light", description = "Day fox - light fox variant" },

  -- Custom theme
  txaty = { variant = "dark", description = "Custom: Low-saturation pure dark ergonomic theme" },
}

local config_path = vim.fn.stdpath "data" .. "/theme_config.json"

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

-- Apply theme
function M.apply_theme(theme_name)
  if not M.theme_info[theme_name] then
    vim.notify("Theme '" .. theme_name .. "' not found", vim.log.levels.WARN)
    return false
  end

  -- Special handling for different theme engines
  if theme_name == "tokyonight-day" then
    require("tokyonight").setup { style = "day" }
    vim.cmd.colorscheme "tokyonight"
  elseif theme_name == "tokyonight" then
    require("tokyonight").setup { style = "storm" }
    vim.cmd.colorscheme "tokyonight"
  elseif theme_name == "rose-pine-dawn" then
    require("rose-pine").setup { variant = "dawn" }
    vim.cmd.colorscheme "rose-pine"
  elseif theme_name == "rose-pine" then
    require("rose-pine").setup { variant = "main" }
    vim.cmd.colorscheme "rose-pine"
  elseif theme_name == "kanagawa-lotus" then
    require("kanagawa").setup { theme = "lotus" }
    vim.cmd.colorscheme "kanagawa"
  elseif theme_name == "kanagawa" then
    require("kanagawa").setup { theme = "dragon" }
    vim.cmd.colorscheme "kanagawa"
  elseif theme_name == "onedark" then
    require("onedark").setup { style = "dark" }
    vim.cmd.colorscheme "onedark"
  elseif theme_name == "onelight" then
    require("onedark").setup { style = "light" }
    vim.cmd.colorscheme "onedark"
  elseif theme_name == "gruvbox" then
    vim.o.background = "dark"
    vim.cmd.colorscheme "gruvbox"
  elseif theme_name == "nord" then
    vim.cmd.colorscheme "nord"
  elseif theme_name == "dracula" then
    vim.cmd.colorscheme "dracula"
  elseif theme_name == "cyberdream" then
    vim.cmd.colorscheme "cyberdream"
  elseif theme_name == "catppuccin" then
    require("catppuccin").setup { flavour = "mocha" }
    vim.cmd.colorscheme "catppuccin"
  elseif theme_name == "nightfox" then
    vim.cmd.colorscheme "nightfox"
  elseif theme_name == "dayfox" then
    vim.cmd.colorscheme "dayfox"
  elseif theme_name == "ayu-light" then
    vim.cmd "set background=light"
    vim.cmd.colorscheme "ayu"
  elseif theme_name == "solarized-light" then
    vim.cmd "set background=light"
    vim.cmd.colorscheme "solarized"
  elseif theme_name == "papercolor" then
    vim.cmd "set background=light"
    vim.cmd.colorscheme "PaperColor"
  elseif theme_name == "omni" then
    vim.cmd "set background=light"
    vim.cmd.colorscheme "omni"
  elseif theme_name == "jellybeans-light" then
    vim.cmd "set background=light"
    vim.cmd.colorscheme "jellybeans"
  elseif theme_name == "txaty" then
    require("core.theme_txaty").apply()
  else
    vim.cmd.colorscheme(theme_name)
  end

  M.save_theme(theme_name)
  vim.notify("Theme: " .. theme_name, vim.log.levels.INFO)
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
