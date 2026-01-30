-- NvimTree auto-open lifecycle module
-- Handles file explorer auto-open with session awareness
local M = {}

--- Clean stale NvimTree buffers from session restore
--- These buffers exist but nvim-tree plugin wasn't initialized
--- @return boolean True if any buffers were cleaned
local function cleanup_stale_buffers()
  local cleaned = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match "NvimTree_" then
        -- Close windows displaying this buffer before deleting it
        -- to prevent orphan full-width windows from session restore
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
            if #vim.api.nvim_list_wins() > 1 then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        end
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
        cleaned = true
      end
    end
  end
  return cleaned
end

--- Safely open nvim-tree
--- @param opts? table Options passed to nvim-tree.api.tree.open
local function open_tree(opts)
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    pcall(api.tree.open, opts)
  end
end

--- Auto-open nvim-tree based on startup context
--- @param session_restored boolean Whether a session was restored
function M.auto_open(session_restored)
  local file = vim.fn.expand "%"
  local is_dir = vim.fn.isdirectory(file) == 1
  local is_file = vim.fn.filereadable(file) == 1

  -- Always cleanup stale buffers first
  local cleaned = cleanup_stale_buffers()

  -- Helper to open tree, deferred if we cleaned buffers
  local function do_open(opts)
    if cleaned then
      -- Defer to ensure buffer names are fully released
      vim.schedule(function()
        open_tree(opts)
      end)
    else
      open_tree(opts)
    end
  end

  -- Directory provided: cd and open tree
  if is_dir then
    vim.cmd.cd(file)
    do_open()
    return
  end

  -- File provided: open tree but keep focus on file
  if is_file then
    do_open { focus = false, find_file = true }
    return
  end

  -- No file provided and no session: open tree as dashboard
  if file == "" and vim.bo.buftype == "" and not session_restored then
    do_open()
  end
end

return M
