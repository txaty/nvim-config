-- Keymap conflict detector
-- Opt-in startup validator gated by vim.g.debug_keymaps
-- Scans nvim_get_keymap() for duplicate lhs per mode and warns
local M = {}

--- Check for duplicate keymap bindings across all modes
--- Only runs when vim.g.debug_keymaps is truthy
function M.check()
  if not vim.g.debug_keymaps then
    return
  end

  local modes = { "n", "i", "v", "x", "s", "o", "t", "c" }
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

  if #conflicts > 0 then
    local lines = { "Keymap conflicts detected:" }
    for _, c in ipairs(conflicts) do
      table.insert(lines, string.format("  mode=%s lhs=%s [%s] vs [%s]", c.mode, c.lhs, c.sources[1], c.sources[2]))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
  end
end

return M
