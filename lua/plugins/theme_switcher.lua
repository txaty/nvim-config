-- Theme switcher plugin with Telescope integration
return {
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
  },

  {
    dir = vim.fn.stdpath "config",
    name = "theme-switcher",
    cmd = { "ThemeSwitch", "ThemeDark", "ThemeLight", "ThemeTxaty", "ThemeNext", "ThemePrev" },
    keys = {
      { "<leader>cc", "<cmd>ThemeSwitch<cr>", desc = "Color: choose colorscheme" },
      { "<leader>cd", "<cmd>ThemeDark<cr>", desc = "Color: switch to dark" },
      { "<leader>cl", "<cmd>ThemeLight<cr>", desc = "Color: switch to light" },
      { "<leader>cp", "<cmd>ThemeTxaty<cr>", desc = "Color: switch to txaty" },
      { "<leader>cn", "<cmd>ThemeNext<cr>", desc = "Color: next theme" },
      { "<leader>cN", "<cmd>ThemePrev<cr>", desc = "Color: previous theme" },
    },
    config = function()
      local theme = require "core.theme"

      -- Create custom Telescope picker for themes with live preview
      -- Follows Telescope's built-in colorscheme picker architecture:
      -- hooks into set_selection (after pipeline) and close_windows (for cancel)
      local function open_theme_picker()
        local ok, err = pcall(function()
          local pickers = require "telescope.pickers"
          local finders = require "telescope.finders"
          local actions = require "telescope.actions"
          local action_state = require "telescope.actions.state"
          local conf = require("telescope.config").values

          local themes = theme.get_all_themes()
          local before_bg = vim.o.background
          local current = theme.load_saved_theme() or "catppuccin"
          local need_restore = true

          local picker = pickers.new({
            prompt_title = "Switch Theme",
            results_title = "Themes",
            previewer = false,
            sorting_strategy = "ascending",
            layout_config = {
              width = 0.5,
              height = 0.6,
            },
            on_complete = {
              function()
                local selection = action_state.get_selected_entry()
                if selection then
                  theme.preview_theme(selection.value)
                end
              end,
            },
          }, {
            finder = finders.new_table {
              results = themes,
              entry_maker = function(name)
                local info = theme.registry[name] or {}
                local variant = info.variant or "custom"
                local desc = info.description or name
                local marker = name == current and "*" or " "
                local display = string.format("%s %-28s %-5s  %s", marker, name, variant, desc)
                return {
                  value = name,
                  display = display,
                  ordinal = name,
                }
              end,
            },
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                need_restore = false
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                  theme.apply_theme(selection.value)
                end
              end)
              return true
            end,
          })

          -- Override set_selection: preview after selection pipeline completes
          local original_set_selection = picker.set_selection
          picker.set_selection = function(self, row)
            original_set_selection(self, row)
            local entry = action_state.get_selected_entry()
            if entry then
              theme.preview_theme(entry.value)
            end
          end

          -- Override close_windows: restore original theme on cancel
          local original_close_windows = picker.close_windows
          picker.close_windows = function(status)
            original_close_windows(status)
            if need_restore then
              vim.o.background = before_bg
              theme.apply_theme(current)
            end
          end

          picker:find()
        end)

        if not ok then
          vim.notify("Failed to open theme picker: " .. tostring(err), vim.log.levels.ERROR)
        end
      end

      -- Helper for cycling themes (direction: 1 = next, -1 = previous)
      local function cycle_theme(direction)
        local all_themes = theme.get_all_themes()
        local saved = theme.load_saved_theme() or "catppuccin"
        local idx = 1
        for i, t in ipairs(all_themes) do
          if t == saved then
            idx = i
            break
          end
        end
        local new_idx
        if direction > 0 then
          new_idx = idx % #all_themes + 1
        else
          new_idx = idx - 1
          if new_idx < 1 then
            new_idx = #all_themes
          end
        end
        theme.apply_theme(all_themes[new_idx])
      end

      -- Create commands for theme switching
      vim.api.nvim_create_user_command("ThemeSwitch", open_theme_picker, {})

      vim.api.nvim_create_user_command("ThemeDark", function()
        require("core.theme").switch_to_dark()
      end, {})

      vim.api.nvim_create_user_command("ThemeLight", function()
        require("core.theme").switch_to_light()
      end, {})

      vim.api.nvim_create_user_command("ThemeTxaty", function()
        theme.apply_theme "txaty"
      end, {})

      vim.api.nvim_create_user_command("ThemeNext", function()
        cycle_theme(1)
      end, {})

      vim.api.nvim_create_user_command("ThemePrev", function()
        cycle_theme(-1)
      end, {})
    end,
  },
}
