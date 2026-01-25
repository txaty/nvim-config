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
    local ok = pcall(require, "telescope")
    if not ok then
      vim.notify("Telescope is required for LangPanel", vim.log.levels.ERROR)
      return
    end

    local lang_ok, lang_toggle = pcall(require, "core.lang_toggle")
    if not lang_ok then
      vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
      return
    end

    local pickers_ok, pickers = pcall(require, "telescope.pickers")
    local finders_ok, finders = pcall(require, "telescope.finders")
    local actions_ok, actions = pcall(require, "telescope.actions")
    local action_state_ok, action_state = pcall(require, "telescope.actions.state")
    local conf_ok, conf = pcall(function()
      return require("telescope.config").values
    end)

    if not (pickers_ok and finders_ok and actions_ok and action_state_ok and conf_ok) then
      vim.notify("Failed to load Telescope components", vim.log.levels.ERROR)
      return
    end

    local function get_entries()
      local entries = {}
      local langs = lang_toggle.get_all_languages()
      for _, lang in ipairs(langs) do
        local info = lang_toggle.languages[lang]
        local enabled = lang_toggle.is_enabled(lang)
        table.insert(entries, {
          lang = lang,
          name = info.name,
          description = info.description,
          enabled = enabled,
        })
      end
      return entries
    end

    local function make_finder()
      return finders.new_table {
        results = get_entries(),
        entry_maker = function(entry)
          local icon = entry.enabled and "+" or "-"
          local status = entry.enabled and "Enabled " or "Disabled"
          local display = string.format("%s %-10s [%s] %s", icon, entry.name, status, entry.description)
          return {
            value = entry,
            display = display,
            ordinal = entry.name .. " " .. entry.lang,
          }
        end,
      }
    end

    local picker_opts = {
      prompt_title = "  Language Support Panel",
      results_title = "Toggle languages (requires restart)",
      previewer = false,
      layout_config = {
        width = 0.7,
        height = 0.5,
      },
    }

    local picker = pickers.new(picker_opts, {
      finder = make_finder(),
      sorter = conf.generic_sorter(picker_opts),
      attach_mappings = function(prompt_bufnr, map)
        -- Toggle on Enter
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection then
            lang_toggle.toggle(selection.value.lang)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(make_finder(), { reset_prompt = false })
          end
        end)

        -- Enable with 'e'
        map("i", "e", function()
          local selection = action_state.get_selected_entry()
          if selection then
            lang_toggle.enable(selection.value.lang)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(make_finder(), { reset_prompt = false })
          end
        end)
        map("n", "e", function()
          local selection = action_state.get_selected_entry()
          if selection then
            lang_toggle.enable(selection.value.lang)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(make_finder(), { reset_prompt = false })
          end
        end)

        -- Disable with 'd'
        map("i", "d", function()
          local selection = action_state.get_selected_entry()
          if selection then
            lang_toggle.disable(selection.value.lang)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(make_finder(), { reset_prompt = false })
          end
        end)
        map("n", "d", function()
          local selection = action_state.get_selected_entry()
          if selection then
            lang_toggle.disable(selection.value.lang)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(make_finder(), { reset_prompt = false })
          end
        end)

        return true
      end,
    })
    picker:find()
  end, { desc = "Open language support panel" })
end

return M
