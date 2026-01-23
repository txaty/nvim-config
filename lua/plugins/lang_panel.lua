-- Language support panel with Telescope integration
return {
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
  },

  {
    dir = vim.fn.stdpath "config",
    name = "lang-panel",
    event = "VeryLazy",
    config = function()
      local lang_toggle = require "core.lang_toggle"

      -- Create custom Telescope picker for language panel
      local function open_lang_panel()
        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"
        local conf = require("telescope.config").values

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
                -- Refresh the picker
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
      end

      -- Create command (keymap defined in lua/core/keymaps.lua)
      vim.api.nvim_create_user_command("LangPanel", open_lang_panel, { desc = "Open language support panel" })
    end,
  },
}
