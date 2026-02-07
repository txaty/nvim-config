-- UI status and debug commands
local M = {}

function M.register()
  vim.api.nvim_create_user_command("UIStatus", function()
    local ok = pcall(require, "core.ui_toggle")
    if not ok then
      vim.notify("Failed to load ui_toggle module", vim.log.levels.ERROR)
      return
    end

    local lines = { "UI Toggle Status:" }
    for _, opt in ipairs { "wrap", "spell", "number", "relativenumber", "conceallevel", "tree_git", "dim" } do
      local value = vim.g["ui_" .. opt]
      local display = type(value) == "boolean" and (value and "on" or "off") or tostring(value)
      table.insert(lines, string.format("  %s: %s", opt, display))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "Show UI toggle status" })

  -- Debug command: Show plugin load order (requires vim.g.debug_plugin_load = true at startup)
  vim.api.nvim_create_user_command("LoadOrder", function()
    local ok, lifecycle = pcall(require, "core.lifecycle")
    if ok and lifecycle.print_load_summary then
      lifecycle.print_load_summary()
    else
      vim.notify("Lifecycle module not available", vim.log.levels.ERROR)
    end
  end, { desc = "Show plugin load order (debug)" })
end

return M
