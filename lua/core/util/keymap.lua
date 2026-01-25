-- Keymap utility with conflict detection
local M = {}

-- Registry tracks all keymaps for conflict detection
M.registry = {}

--- Generate unique key for registry lookup
--- @param mode string|string[] Mode(s)
--- @param lhs string Left-hand side
--- @return string Unique key
local function make_key(mode, lhs)
  if type(mode) == "table" then
    mode = table.concat(mode, ",")
  end
  return mode .. ":" .. lhs
end

--- Set a keymap with automatic conflict detection
--- @param mode string|string[] Mode(s)
--- @param lhs string Left-hand side
--- @param rhs string|function Right-hand side
--- @param opts? table Options (supports additional 'source' and 'override' fields)
function M.set(mode, lhs, rhs, opts)
  opts = opts or {}
  local key = make_key(mode, lhs)

  -- Extract custom options
  local source = opts.source or debug.getinfo(2, "S").source
  local override = opts.override
  local buffer = opts.buffer

  -- Check for conflicts (buffer-local keymaps don't conflict with global)
  if M.registry[key] and not override and not buffer then
    local existing = M.registry[key]
    -- Only warn if not a buffer-local override
    if not existing.buffer then
      vim.schedule(function()
        vim.notify(
          string.format("Keymap: '%s' (%s) redefined (was: %s)", lhs, mode, existing.source or "unknown"),
          vim.log.levels.DEBUG
        )
      end)
    end
  end

  -- Track in registry (only global keymaps)
  if not buffer then
    M.registry[key] = {
      source = source,
      desc = opts.desc,
      buffer = buffer,
      created_at = vim.uv.now(),
    }
  end

  -- Remove custom options before passing to vim
  opts.source = nil
  opts.override = nil

  vim.keymap.set(mode, lhs, rhs, opts)
end

--- List all registered keymaps
--- @return table Registry contents
function M.list()
  return M.registry
end

--- Find potential conflicts (same lhs in same mode)
--- @return table[] List of conflicts
function M.find_conflicts()
  -- Group by lhs to find overwrites
  local by_lhs = {}
  for key, info in pairs(M.registry) do
    local lhs = key:match ":(.+)$"
    if lhs then
      by_lhs[lhs] = by_lhs[lhs] or {}
      table.insert(by_lhs[lhs], { key = key, info = info })
    end
  end

  local conflicts = {}
  for lhs, entries in pairs(by_lhs) do
    if #entries > 1 then
      table.insert(conflicts, { lhs = lhs, entries = entries })
    end
  end
  return conflicts
end

return M
