-- Session management lifecycle module
-- Handles session save/restore with persistence.nvim
local M = {}

--- Determine if session should be restored based on startup arguments
--- @return boolean
function M.should_restore()
  local argc = vim.fn.argc()

  -- No arguments: restore session
  if argc == 0 then
    return true
  end

  -- Single argument: check if it's empty, ".", or a directory
  if argc == 1 then
    local arg = vim.fn.argv(0)
    if arg == "" or arg == "." or vim.fn.isdirectory(arg) == 1 then
      return true
    end
  end

  -- Multiple arguments or specific file: don't restore
  return false
end

--- Check if a session file exists for current directory
--- @return boolean
function M.has_session()
  local ok, persistence = pcall(require, "persistence")
  if not ok then
    return false
  end

  local session_file = persistence.current()
  return vim.fn.filereadable(session_file) == 1
end

--- Restore session if conditions are met
--- @return boolean True if session was restored
function M.restore()
  if not M.should_restore() then
    return false
  end

  local ok, persistence = pcall(require, "persistence")
  if not ok then
    return false
  end

  local session_file = persistence.current()
  if vim.fn.filereadable(session_file) ~= 1 then
    return false
  end

  local success = pcall(persistence.load)
  return success
end

--- Save current session
function M.save()
  local ok, persistence = pcall(require, "persistence")
  if ok then
    pcall(persistence.save)
  end
end

return M
