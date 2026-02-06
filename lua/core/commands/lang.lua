-- Language support toggle commands
local M = {}

-- Completion function for language names
local function complete_languages()
  local ok, lang_toggle = pcall(require, "core.lang_toggle")
  return ok and lang_toggle.get_all_languages() or {}
end

function M.register()
  vim.api.nvim_create_user_command("LangEnable", function(opts)
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    if ok then
      lang_toggle.enable(opts.args)
    else
      vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = complete_languages,
    desc = "Enable language support",
  })

  vim.api.nvim_create_user_command("LangDisable", function(opts)
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    if ok then
      lang_toggle.disable(opts.args)
    else
      vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = complete_languages,
    desc = "Disable language support",
  })

  vim.api.nvim_create_user_command("LangToggle", function(opts)
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    if ok then
      lang_toggle.toggle(opts.args)
    else
      vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = complete_languages,
    desc = "Toggle language support",
  })

  vim.api.nvim_create_user_command("LangStatus", function(opts)
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    if ok then
      if opts.args ~= "" then
        lang_toggle.show_status(opts.args)
      else
        lang_toggle.show_all_status()
      end
    else
      vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = complete_languages,
    desc = "Show language support status",
  })

  vim.api.nvim_create_user_command("LangPanel", function()
    local ok, panel = pcall(require, "core.ui.lang_panel")
    if ok then
      panel.open()
    else
      vim.notify("Failed to load lang_panel module", vim.log.levels.ERROR)
    end
  end, { desc = "Open language support panel" })
end

return M
