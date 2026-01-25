-- Safe require with error handling
local M = {}

--- Safely require a module with error handling
--- @param module string Module name
--- @param opts? table Options: silent (boolean), fallback (any)
--- @return any|nil Module or fallback value
--- @return boolean Success status
function M.require(module, opts)
  opts = opts or {}
  local ok, result = pcall(require, module)

  if not ok then
    if not opts.silent then
      vim.schedule(function()
        vim.notify(string.format("Failed to load module '%s': %s", module, tostring(result)), vim.log.levels.WARN)
      end)
    end
    return opts.fallback, false
  end

  return result, true
end

--- Safely call a function from a module
--- @param module string Module name
--- @param func_name string Function name
--- @param ... any Arguments to pass
--- @return any|nil Result or nil on failure
function M.call(module, func_name, ...)
  local mod, ok = M.require(module, { silent = true })
  if not ok or not mod then
    return nil
  end

  local func = mod[func_name]
  if not func or type(func) ~= "function" then
    return nil
  end

  local call_ok, result = pcall(func, ...)
  if not call_ok then
    return nil
  end

  return result
end

--- Check if a module is available (without loading it)
--- @param module string Module name
--- @return boolean
function M.available(module)
  local ok = pcall(require, module)
  return ok
end

return M
