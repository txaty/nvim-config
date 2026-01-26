-- Post-startup focus reconciliation
-- Ensures cursor is in a valid file buffer after session restore,
-- so bufferline correctly highlights the active tab.
local M = {}

--- Find the first window displaying a listed file buffer
--- @return integer|nil win Window ID, or nil if none found
local function find_file_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if
      vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
      and vim.api.nvim_buf_get_name(buf) ~= ""
      and vim.bo[buf].filetype ~= "NvimTree"
    then
      return win
    end
  end
  return nil
end

--- Ensure the cursor is in a valid file buffer and refresh the tabline.
--- If the current buffer is unlisted or special (e.g. stale NvimTree buffer),
--- switch focus to the first window with a real file buffer.
function M.ensure_focus()
  local cur_buf = vim.api.nvim_get_current_buf()
  local is_valid = vim.bo[cur_buf].buflisted
    and vim.bo[cur_buf].buftype == ""
    and vim.api.nvim_buf_get_name(cur_buf) ~= ""
    and vim.bo[cur_buf].filetype ~= "NvimTree"

  if not is_valid then
    local win = find_file_window()
    if win then
      vim.api.nvim_set_current_win(win)
    end
  end

  vim.cmd.redrawtabline()
end

return M
