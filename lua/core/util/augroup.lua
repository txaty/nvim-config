-- Augroup utility with registry for conflict detection
local M = {}

-- Registry tracks all created augroups for debugging
M.registry = {}

--- Create an augroup with automatic registration
--- @param name string Augroup name
--- @param opts? table Options (defaults to { clear = true })
--- @return integer Augroup ID
function M.create(name, opts)
  opts = opts or {}
  -- Default to clear = true to prevent handler accumulation
  if opts.clear == nil then
    opts.clear = true
  end

  -- Track in registry for debugging
  M.registry[name] = {
    created_at = vim.uv.now(),
    source = debug.getinfo(2, "S").source,
    cleared = opts.clear,
  }

  return vim.api.nvim_create_augroup(name, opts)
end

--- List all registered augroups
--- @return string[] List of augroup names
function M.list()
  return vim.tbl_keys(M.registry)
end

--- Get info about a registered augroup
--- @param name string Augroup name
--- @return table|nil Info table or nil if not found
function M.get_info(name)
  return M.registry[name]
end

--- Check for augroups created without clear = true (potential issue)
--- @return table[] List of augroups that don't clear
function M.check_non_clearing()
  local issues = {}
  for name, info in pairs(M.registry) do
    if not info.cleared then
      table.insert(issues, {
        name = name,
        source = info.source,
      })
    end
  end
  return issues
end

return M
