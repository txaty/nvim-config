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

local function describe_source(map)
  local source = map.desc or map.rhs or map.callback or "?"
  if type(source) == "function" then
    return "<lua callback>"
  end
  return tostring(source)
end

local function push_conflict(conflicts, scope, mode, lhs, first, second)
  conflicts[#conflicts + 1] = {
    scope = scope,
    mode = mode,
    lhs = lhs,
    sources = { first, second },
  }
end

local function collect_runtime_conflicts(scope, get_maps)
  local conflicts = {}

  for _, mode in ipairs(modes) do
    local maps = get_maps(mode)
    local seen = {}

    for _, map in ipairs(maps) do
      local lhs = map.lhs
      if seen[lhs] then
        push_conflict(conflicts, scope, mode, lhs, seen[lhs], describe_source(map))
      else
        seen[lhs] = describe_source(map)
      end
    end
  end

  return conflicts
end

local function format_runtime_conflict(conflict)
  return string.format(
    "  [%s] mode=%s lhs=%s [%s] vs [%s]",
    conflict.scope,
    conflict.mode,
    conflict.lhs,
    conflict.sources[1],
    conflict.sources[2]
  )
end

--- Check for duplicate keymap bindings across all modes (global)
--- @param silent boolean? If true, return results instead of notifying
--- @return table? conflicts List of conflicts if silent mode
function M.check(silent)
  local conflicts = collect_runtime_conflicts("runtime-global", vim.api.nvim_get_keymap)

  if silent then
    return conflicts
  end

  if #conflicts > 0 then
    local lines = { "Keymap conflicts detected (global):" }
    for _, c in ipairs(conflicts) do
      table.insert(lines, format_runtime_conflict(c))
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
        local mode, lhs = id:match "^([^|]+)|(.+)$"
        conflicts[#conflicts + 1] = {
          scope = "lazy-spec",
          id = id,
          mode = mode,
          lhs = lhs,
          plugins = names,
        }
      end
    end
  end

  if silent then
    return conflicts
  end

  if #conflicts > 0 then
    local lines = { "Keymap conflicts detected (lazy keys):" }
    for _, c in ipairs(conflicts) do
      if c.mode and c.lhs then
        table.insert(
          lines,
          string.format("  [%s] mode=%s lhs=%s plugins=%s", c.scope, c.mode, c.lhs, table.concat(c.plugins, ", "))
        )
      else
        table.insert(lines, string.format("  [%s] key=%s plugins=%s", c.scope, c.id, table.concat(c.plugins, ", ")))
      end
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
  local conflicts = collect_runtime_conflicts("runtime-buffer", function(mode)
    return vim.api.nvim_buf_get_keymap(bufnr, mode)
  end)

  if silent then
    return conflicts
  end

  if #conflicts > 0 then
    local lines = { string.format("Buffer-local keymap conflicts (buf=%d):", bufnr) }
    for _, c in ipairs(conflicts) do
      table.insert(lines, format_runtime_conflict(c))
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
      table.insert(lines, format_runtime_conflict(c))
    end
  end

  if #buffer > 0 then
    table.insert(lines, "")
    table.insert(lines, "Buffer-local conflicts:")
    for _, c in ipairs(buffer) do
      table.insert(lines, format_runtime_conflict(c))
    end
  end

  if #lazy > 0 then
    table.insert(lines, "")
    table.insert(lines, "Lazy key conflicts:")
    for _, c in ipairs(lazy) do
      if c.mode and c.lhs then
        table.insert(
          lines,
          string.format("  [%s] mode=%s lhs=%s [%s]", c.scope, c.mode, c.lhs, table.concat(c.plugins, ", "))
        )
      else
        table.insert(lines, string.format("  [%s] key=%s [%s]", c.scope, c.id, table.concat(c.plugins, ", ")))
      end
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
