-- Language support toggle module
-- Manages language tooling enable/disable state with persistence
-- Languages can be toggled off to improve performance or for sensitive codebases

local M = {}

-- Path to store language toggle state
local config_path = vim.fn.stdpath "data" .. "/language_config.json"

-- Cache for config (avoids repeated file I/O - called 7x at startup)
local cached_config = nil

-- Language registry with metadata
M.languages = {
  python = { name = "Python", description = "pyright, ruff, black, isort, venv-selector" },
  rust = { name = "Rust", description = "rustaceanvim, crates.nvim, rust-analyzer" },
  go = { name = "Go", description = "gopls, goimports, gofmt, delve" },
  web = { name = "Web", description = "ts_ls, cssls, jsonls, prettier" },
  flutter = { name = "Flutter", description = "flutter-tools.nvim" },
  latex = { name = "LaTeX", description = "vimtex, latexindent" },
  typst = { name = "Typst", description = "typst-preview.nvim" },
}

--- Invalidate the cache (called after state changes)
local function invalidate_cache()
  cached_config = nil
end

--- Load config from disk (with caching)
--- @return table<string, boolean>
local function load_config()
  if cached_config ~= nil then
    return cached_config.languages or {}
  end

  local ok, content = pcall(vim.fn.readfile, config_path)
  if not ok then
    cached_config = {}
    return {}
  end

  local ok2, config = pcall(vim.json.decode, table.concat(content, "\n"))
  if not ok2 then
    cached_config = {}
    return {}
  end

  cached_config = config
  return config.languages or {}
end

--- Save config to disk
--- @param languages table<string, boolean>
local function save_config(languages)
  local config = { languages = languages }
  local encoded = vim.json.encode(config)
  vim.fn.writefile({ encoded }, config_path)
  invalidate_cache()
end

--- Check if a language is enabled
--- @param lang string Language key
--- @return boolean true if enabled (default: true)
function M.is_enabled(lang)
  if not M.languages[lang] then
    return true -- Unknown languages default to enabled
  end

  local config = load_config()
  -- Default to enabled if not explicitly set
  return config[lang] ~= false
end

--- Toggle a language on/off
--- @param lang string Language key
function M.toggle(lang)
  if not M.languages[lang] then
    vim.notify("Unknown language: " .. lang, vim.log.levels.ERROR)
    return
  end

  local current = M.is_enabled(lang)
  local new_state = not current

  local config = load_config()
  config[lang] = new_state
  save_config(config)

  local status = new_state and "enabled" or "disabled"
  local icon = new_state and "+" or "-"
  local name = M.languages[lang].name
  vim.notify(
    string.format("%s %s support %s. Restart Neovim to apply changes.", icon, name, status),
    vim.log.levels.INFO
  )
end

--- Enable a language
--- @param lang string Language key
function M.enable(lang)
  if not M.languages[lang] then
    vim.notify("Unknown language: " .. lang, vim.log.levels.ERROR)
    return
  end

  local config = load_config()
  config[lang] = true
  save_config(config)

  local name = M.languages[lang].name
  vim.notify(string.format("+ %s support enabled. Restart Neovim to apply changes.", name), vim.log.levels.INFO)
end

--- Disable a language
--- @param lang string Language key
function M.disable(lang)
  if not M.languages[lang] then
    vim.notify("Unknown language: " .. lang, vim.log.levels.ERROR)
    return
  end

  local config = load_config()
  config[lang] = false
  save_config(config)

  local name = M.languages[lang].name
  vim.notify(string.format("- %s support disabled. Restart Neovim to apply changes.", name), vim.log.levels.INFO)
end

--- Get status of all languages
--- @return table<string, boolean>
function M.get_status()
  local result = {}
  for lang, _ in pairs(M.languages) do
    result[lang] = M.is_enabled(lang)
  end
  return result
end

--- Get sorted list of all language keys
--- @return string[]
function M.get_all_languages()
  local langs = {}
  for lang, _ in pairs(M.languages) do
    table.insert(langs, lang)
  end
  table.sort(langs)
  return langs
end

--- Show status for a specific language or all languages
--- @param lang? string Optional language key
function M.show_status(lang)
  if lang and lang ~= "" then
    if not M.languages[lang] then
      vim.notify("Unknown language: " .. lang, vim.log.levels.ERROR)
      return
    end
    local enabled = M.is_enabled(lang)
    local icon = enabled and "+" or "-"
    local status = enabled and "enabled" or "disabled"
    local name = M.languages[lang].name
    vim.notify(string.format("%s %s: %s", icon, name, status), vim.log.levels.INFO)
  else
    M.show_all_status()
  end
end

--- Show status for all languages
function M.show_all_status()
  local lines = { "Language Support Status:" }
  local langs = M.get_all_languages()

  for _, lang in ipairs(langs) do
    local enabled = M.is_enabled(lang)
    local icon = enabled and "+" or "-"
    local status = enabled and "enabled" or "disabled"
    local info = M.languages[lang]
    table.insert(lines, string.format("  %s %-10s [%-8s] %s", icon, info.name, status, info.description))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

return M
