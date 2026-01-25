-- AI feature toggle commands
local M = {}

function M.register()
  vim.api.nvim_create_user_command("AIToggle", function()
    local ok, ai = pcall(require, "core.ai_toggle")
    if ok then
      ai.toggle()
    else
      vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
    end
  end, { desc = "Toggle AI features (Copilot)" })

  vim.api.nvim_create_user_command("AIEnable", function()
    local ok, ai = pcall(require, "core.ai_toggle")
    if ok then
      ai.enable()
    else
      vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
    end
  end, { desc = "Enable AI features" })

  vim.api.nvim_create_user_command("AIDisable", function()
    local ok, ai = pcall(require, "core.ai_toggle")
    if ok then
      ai.disable()
    else
      vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
    end
  end, { desc = "Disable AI features" })

  vim.api.nvim_create_user_command("AIStatus", function()
    local ok, ai = pcall(require, "core.ai_toggle")
    if ok then
      local icon = ai.is_enabled() and "+" or "-"
      vim.notify(string.format("%s AI features are %s", icon, ai.status()), vim.log.levels.INFO)
    else
      vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
    end
  end, { desc = "Show AI features status" })
end

return M
