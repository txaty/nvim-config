-- UI toggle module with JSON file persistence
-- Stores state in ~/.local/share/nvim/ui_config.json (source of truth)
-- Also maintains vim.g.ui_* globals for session compatibility and runtime access
local M = {}

-- Default states (used when no config file exists)
local defaults = {
  wrap = false,
  spell = false,
  number = true,
  relativenumber = true,
  conceallevel = 2,
  tree_git = true, -- Show git status in nvim-tree by default
}

-- JSON config file path and cache
local config_path = vim.fn.stdpath "data" .. "/ui_config.json"
local cached_config = nil

-- Throttle apply() calls to avoid excessive work during rapid window operations
local last_apply_time = 0
local APPLY_THROTTLE_MS = 50 -- Minimum ms between apply() calls

--- Load config from JSON file (cached for performance)
local function load_config_once()
  if cached_config ~= nil then
    return
  end

  local stat = vim.uv.fs_stat(config_path)
  if not stat then
    cached_config = {} -- Use defaults
    return
  end

  local fd = vim.uv.fs_open(config_path, "r", 438)
  if not fd then
    cached_config = {}
    return
  end

  local content = vim.uv.fs_read(fd, stat.size, 0)
  vim.uv.fs_close(fd)

  local ok, config = pcall(vim.json.decode, content)
  cached_config = (ok and type(config) == "table") and config or {}
end

--- Save config to JSON file
---@param config table Config to save
local function save_config(config)
  local encoded = vim.json.encode(config)
  vim.fn.writefile({ encoded }, config_path)
  cached_config = nil -- Invalidate cache
end

-- Note: load_config_once() is called lazily in init() or on first access
-- This avoids disk I/O at require-time for faster startup

--- Initialize UI state from JSON config, session globals, or defaults
--- Precedence: JSON file > vim.g global (session) > default
function M.init()
  load_config_once()

  for opt, default in pairs(defaults) do
    local global_key = "ui_" .. opt
    -- JSON takes precedence, then session global, then default
    if cached_config[opt] ~= nil then
      vim.g[global_key] = cached_config[opt]
    elseif vim.g[global_key] == nil then
      vim.g[global_key] = default
    end
  end
end

--- Apply current UI state to a window (throttled to avoid excessive calls)
---@param win? number Window handle (0 for current window)
function M.apply(win)
  -- Throttle rapid calls (e.g., during session restore with many windows)
  local now = vim.uv.now()
  if now - last_apply_time < APPLY_THROTTLE_MS then
    return
  end
  last_apply_time = now

  win = win or 0
  vim.wo[win].wrap = vim.g.ui_wrap
  vim.wo[win].spell = vim.g.ui_spell
  vim.wo[win].number = vim.g.ui_number
  vim.wo[win].relativenumber = vim.g.ui_relativenumber
  vim.wo[win].conceallevel = vim.g.ui_conceallevel
end

--- Toggle a UI option
---@param opt string Option name (wrap, spell, number, relativenumber, conceallevel, tree_git)
function M.toggle(opt)
  local global_key = "ui_" .. opt
  local current = vim.g[global_key]
  local new_value

  if opt == "conceallevel" then
    -- Toggle between 0 and 2
    new_value = current == 0 and 2 or 0
  else
    -- Boolean toggle
    new_value = not current
  end

  -- Update global
  vim.g[global_key] = new_value

  -- Persist to JSON
  load_config_once()
  cached_config[opt] = new_value
  save_config(cached_config)

  -- Special handling for tree_git: reload nvim-tree with new config
  if opt == "tree_git" then
    local ok, nvim_tree = pcall(require, "nvim-tree")
    if ok and nvim_tree then
      -- Get current nvim-tree state
      local api = require "nvim-tree.api"
      local tree_winid = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NvimTree" then
          tree_winid = win
          break
        end
      end

      -- Reload nvim-tree configuration with new git setting
      -- Note: We defer the setup to avoid conflicts during toggle
      vim.schedule(function()
        -- Get the opts function from the plugin spec
        local config_ok, config = pcall(require, "nvim-tree")
        if config_ok then
          -- Trigger a refresh if tree is open
          if tree_winid and vim.api.nvim_win_is_valid(tree_winid) then
            api.tree.reload()
          end
        end
      end)
    end

    local display = new_value and "on" or "off"
    vim.notify(string.format("UI: tree git status = %s (reload nvim-tree to apply)", display), vim.log.levels.INFO)
    return
  end

  -- Apply to current window (for standard vim options)
  if opt ~= "tree_git" then
    vim.wo[opt] = new_value
  end

  -- Notify user
  local display = type(new_value) == "boolean" and (new_value and "on" or "off") or tostring(new_value)
  vim.notify(string.format("UI: %s = %s", opt, display), vim.log.levels.INFO)
end

--- Get current state of an option
---@param opt string Option name
---@return any
function M.get(opt)
  return vim.g["ui_" .. opt]
end

--- Apply UI state to ALL windows (used after session restore)
--- Resets throttle after completion to allow immediate subsequent apply() calls
function M.apply_all()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      vim.wo[win].wrap = vim.g.ui_wrap or false
      vim.wo[win].spell = vim.g.ui_spell or false
      vim.wo[win].number = vim.g.ui_number or true
      vim.wo[win].relativenumber = vim.g.ui_relativenumber or true
      vim.wo[win].conceallevel = vim.g.ui_conceallevel or 2
    end
  end

  -- Reset throttle after batch apply to allow immediate window-specific applies
  last_apply_time = vim.uv.now()
end

return M
