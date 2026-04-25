-- Session persistence toggle commands
local M = {}

local function with_session(fn)
  local ok, session = pcall(require, "core.session_toggle")
  if ok then
    fn(session)
  else
    vim.notify("Failed to load session_toggle module", vim.log.levels.ERROR)
  end
end

function M.register()
  vim.api.nvim_create_user_command("SessionToggle", function()
    with_session(function(s)
      s.toggle()
    end)
  end, { desc = "Toggle session persistence (auto-restore/save)" })

  vim.api.nvim_create_user_command("SessionEnable", function()
    with_session(function(s)
      s.enable()
    end)
  end, { desc = "Enable session persistence" })

  vim.api.nvim_create_user_command("SessionDisable", function()
    with_session(function(s)
      s.disable()
    end)
  end, { desc = "Disable session persistence" })

  vim.api.nvim_create_user_command("SessionStatus", function()
    with_session(function(s)
      local icon = s.is_enabled() and "+" or "-"
      vim.notify(string.format("%s Session persistence is %s", icon, s.status()), vim.log.levels.INFO)
    end)
  end, { desc = "Show session persistence status" })
end

return M
