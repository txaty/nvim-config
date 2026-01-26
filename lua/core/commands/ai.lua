-- AI feature toggle commands
local M = {}

local function with_ai(fn)
  local ok, ai = pcall(require, "core.ai_toggle")
  if ok then
    fn(ai)
  else
    vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
  end
end

function M.register()
  vim.api.nvim_create_user_command("AIToggle", function()
    with_ai(function(ai)
      ai.toggle()
    end)
  end, { desc = "Toggle AI features (Copilot)" })

  vim.api.nvim_create_user_command("AIEnable", function()
    with_ai(function(ai)
      ai.enable()
    end)
  end, { desc = "Enable AI features" })

  vim.api.nvim_create_user_command("AIDisable", function()
    with_ai(function(ai)
      ai.disable()
    end)
  end, { desc = "Disable AI features" })

  vim.api.nvim_create_user_command("AIStatus", function()
    with_ai(function(ai)
      local icon = ai.is_enabled() and "+" or "-"
      vim.notify(string.format("%s AI features are %s", icon, ai.status()), vim.log.levels.INFO)
    end)
  end, { desc = "Show AI features status" })
end

return M
