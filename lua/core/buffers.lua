local M = {}

-- Re-entrancy guard
local closing_in_progress = false

-- Comprehensive special buffer detection (set for O(1) lookup)
local SPECIAL_FILETYPES = {
  NvimTree = true,
  ["neo-tree"] = true,
  oil = true,
  help = true,
  qf = true,
  trouble = true,
  Trouble = true,
  lazy = true,
  mason = true,
  notify = true,
  toggleterm = true,
  ["dap-repl"] = true,
  dapui_scopes = true,
  dapui_breakpoints = true,
  dapui_stacks = true,
  dapui_watches = true,
  dapui_console = true,
  TelescopePrompt = true,
  alpha = true,
  dashboard = true,
}

---Check if buffer is a normal file buffer
---@param bufnr integer
---@return boolean
local function is_file_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  if not vim.bo[bufnr].buflisted then
    return false
  end
  -- Empty buftype = normal file
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end
  local ft = vim.bo[bufnr].filetype
  if SPECIAL_FILETYPES[ft] then
    return false
  end
  return true
end

---Get listed file buffers sorted by most recently used
---@param exclude_set table<integer, boolean>? Set of buffer numbers to exclude
---@return table[] Array of {bufnr, lastused}
local function get_file_buffers(exclude_set)
  exclude_set = exclude_set or {}
  local buffers = {}
  for _, info in ipairs(vim.fn.getbufinfo { buflisted = 1 }) do
    if not exclude_set[info.bufnr] and is_file_buffer(info.bufnr) then
      table.insert(buffers, { bufnr = info.bufnr, lastused = info.lastused or 0 })
    end
  end
  table.sort(buffers, function(a, b)
    return a.lastused > b.lastused
  end)
  return buffers
end

---Get non-floating windows showing a buffer
---@param bufnr integer
---@return integer[] Array of window IDs
local function get_windows_for_buffer(bufnr)
  local windows = {}
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    if vim.api.nvim_win_is_valid(winid) then
      local config = vim.api.nvim_win_get_config(winid)
      if config.relative == "" then
        table.insert(windows, winid)
      end
    end
  end
  return windows
end

---Create empty fallback buffer that auto-wipes when hidden
---@return integer Buffer number
local function create_empty_buffer()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  return buf
end

---Core synchronous close implementation
---@param bufnrs integer[] Array of buffer numbers to close
---@param opts table? Options: force (boolean), wipe (boolean)
local function close_sync(bufnrs, opts)
  opts = vim.tbl_extend("force", { force = true, wipe = false }, opts or {})

  if closing_in_progress then
    return
  end
  closing_in_progress = true

  local ok, err = pcall(function()
    -- Step 1: Build valid targets set
    local closing_set = {}
    local targets = {}
    for _, bufnr in ipairs(bufnrs) do
      if bufnr == 0 then
        bufnr = vim.api.nvim_get_current_buf()
      end
      if vim.api.nvim_buf_is_valid(bufnr) and is_file_buffer(bufnr) and not closing_set[bufnr] then
        closing_set[bufnr] = true
        table.insert(targets, bufnr)
      end
    end

    if #targets == 0 then
      return
    end

    -- Step 2: Find global alternate (computed ONCE using remaining buffers)
    local remaining = get_file_buffers(closing_set)
    local alternate = remaining[1] and remaining[1].bufnr or nil
    local empty_buf = nil

    -- Step 3: Switch all affected windows BEFORE any deletion
    for _, target in ipairs(targets) do
      for _, winid in ipairs(get_windows_for_buffer(target)) do
        if vim.api.nvim_win_is_valid(winid) then
          if alternate and vim.api.nvim_buf_is_valid(alternate) then
            vim.api.nvim_win_set_buf(winid, alternate)
          else
            if not empty_buf or not vim.api.nvim_buf_is_valid(empty_buf) then
              empty_buf = create_empty_buffer()
            end
            vim.api.nvim_win_set_buf(winid, empty_buf)
          end
        end
      end
    end

    -- Step 4: Delete all target buffers
    for _, target in ipairs(targets) do
      if vim.api.nvim_buf_is_valid(target) then
        if opts.wipe then
          pcall(vim.cmd, string.format("silent! bwipeout! %d", target))
        else
          pcall(vim.api.nvim_buf_delete, target, { force = opts.force })
        end
      end
    end
  end)

  closing_in_progress = false

  if not ok then
    vim.notify("Buffer close error: " .. tostring(err), vim.log.levels.WARN)
  end
end

---Close a single buffer
---@param bufnr integer? Buffer number (0 or nil for current)
---@param opts table? Options: force (boolean), wipe (boolean)
function M.close(bufnr, opts)
  close_sync({ bufnr or 0 }, opts)
end

---Close multiple buffers
---@param bufnrs integer[] Array of buffer numbers
---@param opts table? Options: force (boolean), wipe (boolean)
function M.close_many(bufnrs, opts)
  close_sync(bufnrs, opts)
end

---Check if buffer is a listed normal file buffer
---@param bufnr integer
---@return boolean
function M.is_listed_normal(bufnr)
  return is_file_buffer(bufnr)
end

return M
