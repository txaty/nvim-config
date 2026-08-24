-- UI status and debug commands
local M = {}

function M.register()
  vim.api.nvim_create_user_command("UIStatus", function()
    local ui_toggle = require "core.ui_toggle"
    local lines = { "UI Toggle Status:" }
    -- Read through ui_toggle.get() rather than vim.g directly so the module
    -- self-initialises if :UIStatus is the first thing to touch it.
    for _, opt in ipairs(ui_toggle.option_names()) do
      local value = ui_toggle.get(opt)
      local display = type(value) == "boolean" and (value and "on" or "off") or tostring(value)
      table.insert(lines, string.format("  %s: %s", opt, display))
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end, { desc = "Show UI toggle status" })

  -- Debug: requires vim.g.debug_plugin_load = true at startup to have data.
  vim.api.nvim_create_user_command("LoadOrder", function()
    require("core.lifecycle").print_load_summary()
  end, { desc = "Show plugin load order (debug)" })
end

return M
