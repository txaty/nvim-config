-- Language support panel (Telescope picker)
-- Extracted from core/commands/lang.lua for modularity
local M = {}

function M.open()
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

      -- Helper to map an action for both insert and normal modes
      local function map_action(key, action_fn)
        local handler = function()
          local selection = action_state.get_selected_entry()
          if selection then
            action_fn(selection.value.lang)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(make_finder(), { reset_prompt = false })
          end
        end
        map("i", key, handler)
        map("n", key, handler)
      end

      -- Enable with 'e', Disable with 'd'
      map_action("e", lang_toggle.enable)
      map_action("d", lang_toggle.disable)

      return true
    end,
  })
  picker:find()
end

return M
