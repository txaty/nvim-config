-- AI feature toggle module
-- Manages AI plugin loading state with persistence across sessions
-- Similar to Zed's "Disable AI" feature

local M = {}

-- Path to store AI toggle state
local config_path = vim.fn.stdpath "data" .. "/ai_config.json"

-- Cache for enabled state (avoids repeated file I/O during startup)
-- This is read once at module load and cached for the session
local cached_enabled = nil

-- Load config once at module load to avoid repeated file I/O
-- This is called during lazy.nvim spec evaluation, so we optimize it
local function load_config_once()
  if cached_enabled ~= nil then
    return
  end

  -- Use vim.uv.fs_stat for faster existence check (no pcall needed)
  local stat = vim.uv.fs_stat(config_path)
  if not stat then
    cached_enabled = true -- Default: AI enabled (no config file)
    return
  end

  -- Read file synchronously (faster than vim.fn.readfile for small files)
  local fd = vim.uv.fs_open(config_path, "r", 438)
  if not fd then
    cached_enabled = true
    return
  end

  local content = vim.uv.fs_read(fd, stat.size, 0)
  vim.uv.fs_close(fd)

  if not content or content == "" then
    cached_enabled = true
    return
  end

  local ok, config = pcall(vim.json.decode, content)
  if not ok or type(config) ~= "table" then
    cached_enabled = true
    return
  end

  cached_enabled = config.enabled ~= false
end

-- Initialize cache immediately at module load
load_config_once()

--- Invalidate the cache (called after state changes)
local function invalidate_cache()
  cached_enabled = nil
end

--- Check if AI features are enabled
--- @return boolean true if AI is enabled, false otherwise
function M.is_enabled()
  if cached_enabled == nil then
    load_config_once()
  end
  return cached_enabled
end

--- Toggle AI features on/off
function M.toggle()
  local current = M.is_enabled()
  local new_state = not current

  local config = { enabled = new_state }
  local encoded = vim.json.encode(config)
  vim.fn.writefile({ encoded }, config_path)
  invalidate_cache()

  local status = new_state and "enabled" or "disabled"
  local icon = new_state and "✓" or "✗"
  vim.notify(string.format("%s AI features %s. Restart Neovim to apply changes.", icon, status), vim.log.levels.INFO)
end

--- Explicitly enable AI features
function M.enable()
  vim.fn.writefile({ vim.json.encode { enabled = true } }, config_path)
  invalidate_cache()
  vim.notify("✓ AI features enabled. Restart Neovim to apply changes.", vim.log.levels.INFO)
end

--- Explicitly disable AI features
function M.disable()
  vim.fn.writefile({ vim.json.encode { enabled = false } }, config_path)
  invalidate_cache()
  vim.notify("✗ AI features disabled. Restart Neovim to apply changes.", vim.log.levels.INFO)
end

--- Get current status as a string
--- @return string "enabled" or "disabled"
function M.status()
  return M.is_enabled() and "enabled" or "disabled"
end

return M
