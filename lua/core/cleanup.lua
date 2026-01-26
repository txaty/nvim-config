-- Automatic cleanup for temporary and cache files
-- Minimizes disk footprint without removing any plugins
local M = {}

-- Configuration
local config = {
  log_max_age_days = 7,
  swap_max_age_days = 1,
  luac_max_age_days = 30,
  lsp_log_max_age_days = 7,
  throttle_hours = 24,
}

-- Paths
local state_path = vim.fn.stdpath "state"
local cache_path = vim.fn.stdpath "cache"
local data_path = vim.fn.stdpath "data"

-- Helper: get file modification time
local function get_mtime(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.mtime.sec or nil
end

-- Helper: check if file is older than N days
local function is_older_than_days(path, days)
  local mtime = get_mtime(path)
  if not mtime then
    return false
  end
  local now = os.time()
  local age_seconds = now - mtime
  local age_days = age_seconds / (24 * 60 * 60)
  return age_days > days
end

-- Helper: safe delete with path validation
local function safe_delete(path, expected_prefix)
  -- Validate path starts with expected prefix (ensure trailing / to avoid prefix collisions)
  local norm_prefix = expected_prefix:sub(-1) == "/" and expected_prefix or (expected_prefix .. "/")
  if not path:find("^" .. vim.pesc(norm_prefix)) and path ~= expected_prefix then
    return false, "Path outside expected directory"
  end

  local ok, err = pcall(function()
    vim.fn.delete(path)
  end)
  return ok, err
end

-- Helper: list files in directory with pattern
local function list_files(dir, pattern)
  local files = {}
  local handle = vim.uv.fs_scandir(dir)
  if not handle then
    return files
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == "file" and (not pattern or name:match(pattern)) then
      table.insert(files, dir .. "/" .. name)
    end
  end
  return files
end

-- Helper: recursively list files in directory
local function list_files_recursive(dir, pattern, max_depth, current_depth)
  current_depth = current_depth or 0
  max_depth = max_depth or 3
  local files = {}

  if current_depth > max_depth then
    return files
  end

  local handle = vim.uv.fs_scandir(dir)
  if not handle then
    return files
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local full_path = dir .. "/" .. name
    if type == "file" and (not pattern or name:match(pattern)) then
      table.insert(files, full_path)
    elseif type == "directory" then
      local sub_files = list_files_recursive(full_path, pattern, max_depth, current_depth + 1)
      for _, f in ipairs(sub_files) do
        table.insert(files, f)
      end
    end
  end
  return files
end

-- Clean log files older than 7 days
function M.clean_logs()
  local log_files = {
    state_path .. "/lsp.log",
    state_path .. "/mason.log",
    state_path .. "/luasnip.log",
    state_path .. "/neotest.log",
    state_path .. "/nio.log",
    state_path .. "/lazy.log",
    state_path .. "/conform.log",
  }

  local cleaned = 0
  for _, log_file in ipairs(log_files) do
    if vim.fn.filereadable(log_file) == 1 then
      if is_older_than_days(log_file, config.log_max_age_days) then
        local ok = safe_delete(log_file, state_path)
        if ok then
          cleaned = cleaned + 1
        end
      end
    end
  end
  return cleaned
end

-- Clean orphaned swap files
function M.clean_swap()
  local swap_dir = state_path .. "/swap"
  if vim.fn.isdirectory(swap_dir) ~= 1 then
    return 0
  end

  local swap_files = list_files(swap_dir, "%.sw[a-z]$")
  local cleaned = 0

  for _, swap_file in ipairs(swap_files) do
    -- Check if swap file is old enough
    if is_older_than_days(swap_file, config.swap_max_age_days) then
      -- Try to determine if the original file is being edited
      -- Swap files encode the original path in their name
      local basename = vim.fn.fnamemodify(swap_file, ":t")
      -- Extract original filename from swap name (roughly)
      local original_name = basename:gsub("^%%", "/"):gsub("%%", "/"):gsub("%.sw[a-z]$", "")

      -- Check if any buffer is editing this file
      local is_active = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if
            buf_name == original_name or vim.fn.fnamemodify(buf_name, ":p") == vim.fn.fnamemodify(original_name, ":p")
          then
            is_active = true
            break
          end
        end
      end

      if not is_active then
        local ok = safe_delete(swap_file, swap_dir)
        if ok then
          cleaned = cleaned + 1
        end
      end
    end
  end
  return cleaned
end

-- Clean view files for non-existent source files
function M.clean_views()
  local view_dir = state_path .. "/view"
  if vim.fn.isdirectory(view_dir) ~= 1 then
    return 0
  end

  local view_files = list_files(view_dir, nil)
  local cleaned = 0

  for _, view_file in ipairs(view_files) do
    -- View filenames encode the original path with = instead of /
    local basename = vim.fn.fnamemodify(view_file, ":t")
    -- Remove the trailing =X.vim suffix
    local encoded_path = basename:gsub("=[0-9]*%.vim$", "")
    -- Decode: ~ -> home, = -> /
    local original_path = encoded_path:gsub("^~", vim.env.HOME or ""):gsub("=", "/")

    -- Check if original file still exists
    if vim.fn.filereadable(original_path) ~= 1 then
      local ok = safe_delete(view_file, view_dir)
      if ok then
        cleaned = cleaned + 1
      end
    end
  end
  return cleaned
end

-- Clean luac cache files older than 30 days
function M.clean_luac_cache()
  local luac_dir = cache_path .. "/luac"
  if vim.fn.isdirectory(luac_dir) ~= 1 then
    return 0
  end

  local luac_files = list_files(luac_dir, "%.luac$")
  local cleaned = 0

  for _, luac_file in ipairs(luac_files) do
    if is_older_than_days(luac_file, config.luac_max_age_days) then
      local ok = safe_delete(luac_file, luac_dir)
      if ok then
        cleaned = cleaned + 1
      end
    end
  end
  return cleaned
end

-- Clean LSP server logs
function M.clean_lsp_logs()
  local mason_packages = data_path .. "/mason/packages"
  if vim.fn.isdirectory(mason_packages) ~= 1 then
    return 0
  end

  local cleaned = 0

  -- Find all log directories within mason packages
  local handle = vim.uv.fs_scandir(mason_packages)
  if not handle then
    return 0
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == "directory" then
      local log_dir = mason_packages .. "/" .. name .. "/log"
      if vim.fn.isdirectory(log_dir) == 1 then
        local log_files = list_files(log_dir, nil)
        for _, log_file in ipairs(log_files) do
          if is_older_than_days(log_file, config.lsp_log_max_age_days) then
            local ok = safe_delete(log_file, mason_packages)
            if ok then
              cleaned = cleaned + 1
            end
          end
        end
      end
    end
  end
  return cleaned
end

-- Get last cleanup timestamp
local function get_last_cleanup_time()
  local timestamp_file = state_path .. "/cleanup_last_run"
  if vim.fn.filereadable(timestamp_file) ~= 1 then
    return 0
  end

  local content = vim.fn.readfile(timestamp_file)
  if #content > 0 then
    return tonumber(content[1]) or 0
  end
  return 0
end

-- Save cleanup timestamp
local function save_cleanup_time()
  local timestamp_file = state_path .. "/cleanup_last_run"
  vim.fn.writefile({ tostring(os.time()) }, timestamp_file)
end

-- Check if cleanup should run (throttled)
function M.should_run()
  -- Check opt-out
  if vim.g.disable_auto_cleanup then
    return false
  end

  local last_run = get_last_cleanup_time()
  local now = os.time()
  local hours_since = (now - last_run) / (60 * 60)
  return hours_since >= config.throttle_hours
end

-- Run all cleanup functions
function M.clean_all(verbose)
  local results = {
    logs = M.clean_logs(),
    swap = M.clean_swap(),
    views = M.clean_views(),
    luac = M.clean_luac_cache(),
    lsp_logs = M.clean_lsp_logs(),
  }

  local total = results.logs + results.swap + results.views + results.luac + results.lsp_logs

  if verbose then
    local msg = string.format(
      "Cleanup complete:\n  - Log files: %d\n  - Swap files: %d\n  - View files: %d\n  - Luac cache: %d\n  - LSP logs: %d\n  - Total: %d files removed",
      results.logs,
      results.swap,
      results.views,
      results.luac,
      results.lsp_logs,
      total
    )
    vim.notify(msg, vim.log.levels.INFO)
  end

  return results, total
end

-- Auto cleanup (called on startup, throttled)
function M.auto_cleanup()
  if not M.should_run() then
    return
  end

  -- Run cleanup silently
  pcall(M.clean_all, false)
  save_cleanup_time()
end

-- Manual cleanup command (always runs, shows summary)
function M.manual_cleanup()
  M.clean_all(true)
  save_cleanup_time()
end

return M
