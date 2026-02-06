-- Unified JSON config persistence with caching
-- Consolidates duplicate load/save patterns from ai_toggle, lang_toggle, ui_toggle, theme
local M = {}
local cache = {} -- Keyed by filepath

--- Load JSON config with caching
---@param filepath string Full path to JSON file
---@param default table Default value if file doesn't exist
---@return table config
function M.load_json(filepath, default)
  if cache[filepath] ~= nil then
    return cache[filepath]
  end

  local stat = vim.uv.fs_stat(filepath)
  if not stat then
    cache[filepath] = default or {}
    return cache[filepath]
  end

  local fd = vim.uv.fs_open(filepath, "r", 438)
  if not fd then
    cache[filepath] = default or {}
    return cache[filepath]
  end

  local content = vim.uv.fs_read(fd, stat.size, 0)
  vim.uv.fs_close(fd)

  if not content or content == "" then
    cache[filepath] = default or {}
    return cache[filepath]
  end

  local ok, result = pcall(vim.json.decode, content)
  cache[filepath] = (ok and type(result) == "table") and result or (default or {})
  return cache[filepath]
end

--- Save table to JSON config
---@param filepath string Full path to JSON file
---@param config table Config to save
function M.save_json(filepath, config)
  local json_str = vim.json.encode(config)
  local fd = vim.uv.fs_open(filepath, "w", 438)
  if fd then
    vim.uv.fs_write(fd, json_str, 0)
    vim.uv.fs_close(fd)
  end
  cache[filepath] = nil -- Invalidate cache
end

--- Invalidate cache for filepath
---@param filepath string Full path to JSON file
function M.invalidate(filepath)
  cache[filepath] = nil
end

return M
