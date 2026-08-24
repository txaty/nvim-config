-- Language support toggle commands
local M = {}

local function lang_toggle()
  return require "core.lang_toggle"
end

local function complete_languages()
  return lang_toggle().get_all_languages()
end

function M.register()
  ---@param name string
  ---@param fn fun(lang_toggle: table, args: string)
  ---@param nargs string|integer
  ---@param desc string
  local function command(name, nargs, desc, fn)
    vim.api.nvim_create_user_command(name, function(o)
      fn(lang_toggle(), o.args)
    end, { nargs = nargs, complete = complete_languages, desc = desc })
  end

  command("LangEnable", 1, "Enable language support", function(lt, lang)
    lt.enable(lang)
  end)

  command("LangDisable", 1, "Disable language support", function(lt, lang)
    lt.disable(lang)
  end)

  command("LangToggle", 1, "Toggle language support", function(lt, lang)
    lt.toggle(lang)
  end)

  -- nargs="?": no argument shows every language.
  command("LangStatus", "?", "Show language support status", function(lt, lang)
    lt.show_status(lang)
  end)

  vim.api.nvim_create_user_command("LangPanel", function()
    require("core.ui.lang_panel").open()
  end, { desc = "Open language support panel" })
end

return M
