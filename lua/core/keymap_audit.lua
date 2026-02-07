-- Keymap conflict detector
-- Startup validator for runtime and lazy.nvim key collisions
-- Scans nvim_get_keymap() and lazy key handlers for duplicate bindings
--
-- Usage:
--   nvim --cmd "let g:debug_keymaps=1"  -- Extra verbose output
--   :lua require("core.keymap_audit").check()  -- Manual check
--   :lua require("core.keymap_audit").check_buffer()  -- Check buffer-local
--   :lua require("core.keymap_audit").check_lazy_keys()  -- Check lazy key specs

local M = {}

local modes = { "n", "i", "v", "x", "s", "o", "t", "c" }

--- Check for duplicate keymap bindings across all modes (global)
--- @param silent boolean? If true, return results instead of notifying
--- @return table? conflicts List of conflicts if silent mode
function M.check(silent)
  local conflicts = {}

  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    local seen = {}

    for _, map in ipairs(maps) do
      local lhs = map.lhs
      if seen[lhs] then
        table.insert(conflicts, {
          mode = mode,
          lhs = lhs,
          sources = { seen[lhs], map.desc or map.rhs or "?" },
        })
      else
        seen[lhs] = map.desc or map.rhs or "?"
      end
    end
  end

  if silent then
    return conflicts
  end

  if #conflicts > 0 then
    local lines = { "Keymap conflicts detected (global):" }
    for _, c in ipairs(conflicts) do
      table.insert(lines, string.format("  mode=%s lhs=%s", c.mode, c.lhs))
      table.insert(lines, string.format("    [1] %s", c.sources[1]))
      table.insert(lines, string.format("    [2] %s", c.sources[2]))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
  elseif vim.g.debug_keymaps then
    vim.notify("No global keymap conflicts detected", vim.log.levels.INFO)
  end

  return conflicts
end

--- Check for duplicate lazy.nvim key handlers (plugin-level collisions)
--- @param silent boolean? If true, return results instead of notifying
--- @return table? conflicts List of lazy key conflicts if silent mode
function M.check_lazy_keys(silent)
  local conflicts = {}

  local ok, handler = pcall(require, "lazy.core.handler")
  if not ok or not handler.handlers or not handler.handlers.keys then
    if silent then
      return conflicts
    end
    return conflicts
  end

  local active = handler.handlers.keys.active or {}
  for id, plugins in pairs(active) do
    if type(plugins) == "table" then
      local names = vim.tbl_keys(plugins)
      if #names > 1 then
        table.sort(names)
        table.insert(conflicts, {
          id = id,
          plugins = names,
        })
      end
    end
  end

  if silent then
    return conflicts
  end

  if #conflicts > 0 then
    local lines = { "Keymap conflicts detected (lazy keys):" }
    for _, c in ipairs(conflicts) do
      table.insert(lines, string.format("  key=%s", c.id))
      table.insert(lines, string.format("    plugins=%s", table.concat(c.plugins, ", ")))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
  elseif vim.g.debug_keymaps then
    vim.notify("No lazy key conflicts detected", vim.log.levels.INFO)
  end

  return conflicts
end

--- Check for duplicate buffer-local keymap bindings
--- @param bufnr number? Buffer number (default: current buffer)
--- @param silent boolean? If true, return results instead of notifying
--- @return table? conflicts List of conflicts if silent mode
function M.check_buffer(bufnr, silent)
  bufnr = bufnr or 0
  local conflicts = {}

  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_buf_get_keymap(bufnr, mode)
    local seen = {}

    for _, map in ipairs(maps) do
      local lhs = map.lhs
      if seen[lhs] then
        table.insert(conflicts, {
          mode = mode,
          lhs = lhs,
          sources = { seen[lhs], map.desc or map.rhs or "?" },
        })
      else
        seen[lhs] = map.desc or map.rhs or "?"
      end
    end
  end

  if silent then
    return conflicts
  end

  if #conflicts > 0 then
    local lines = { string.format("Buffer-local keymap conflicts (buf=%d):", bufnr) }
    for _, c in ipairs(conflicts) do
      table.insert(lines, string.format("  mode=%s lhs=%s", c.mode, c.lhs))
      table.insert(lines, string.format("    [1] %s", c.sources[1]))
      table.insert(lines, string.format("    [2] %s", c.sources[2]))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
  elseif vim.g.debug_keymaps then
    vim.notify(string.format("No buffer-local keymap conflicts (buf=%d)", bufnr), vim.log.levels.INFO)
  end

  return conflicts
end

--- Full audit: check global, buffer-local, and lazy.nvim keymaps
--- Called automatically on VeryLazy
function M.full_audit()
  local global = M.check(true)
  local buffer = M.check_buffer(nil, true)
  local lazy = M.check_lazy_keys(true)

  local total = #global + #buffer + #lazy
  if total == 0 then
    if vim.g.debug_keymaps then
      vim.notify("Keymap audit: No conflicts detected", vim.log.levels.INFO)
    end
    return
  end

  local lines = { string.format("Keymap audit: %d conflict(s) found", total) }

  if #global > 0 then
    table.insert(lines, "")
    table.insert(lines, "Global conflicts:")
    for _, c in ipairs(global) do
      table.insert(lines, string.format("  mode=%s lhs=%s [%s] vs [%s]", c.mode, c.lhs, c.sources[1], c.sources[2]))
    end
  end

  if #buffer > 0 then
    table.insert(lines, "")
    table.insert(lines, "Buffer-local conflicts:")
    for _, c in ipairs(buffer) do
      table.insert(lines, string.format("  mode=%s lhs=%s [%s] vs [%s]", c.mode, c.lhs, c.sources[1], c.sources[2]))
    end
  end

  if #lazy > 0 then
    table.insert(lines, "")
    table.insert(lines, "Lazy key conflicts:")
    for _, c in ipairs(lazy) do
      table.insert(lines, string.format("  key=%s [%s]", c.id, table.concat(c.plugins, ", ")))
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
end

--- Setup autocmd to run audit on VeryLazy
function M.setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      -- Defer slightly to ensure all plugins have registered keymaps
      vim.defer_fn(function()
        M.full_audit()
      end, 100)
    end,
  })
end

return M
