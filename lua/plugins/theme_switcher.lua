-- Theme switcher plugin with Telescope integration
return {
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
  },

  {
    dir = vim.fn.stdpath "config",
    name = "theme-switcher",
    event = "VeryLazy",
    config = function()
      local theme = require "core.theme"

      -- Create custom Telescope picker for themes
      local function open_theme_picker()
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

        local themes = theme.get_all_themes()

        local picker_opts = {
          prompt_title = "  Switch Theme",
          results_title = "Available Themes",
          preview_title = "Theme Preview",
          previewer = false,
        }

        local picker = pickers.new(picker_opts, {
          finder = finders.new_table {
            results = themes,
            entry_maker = function(entry)
              local info = theme.theme_info[entry] or {}
              local variant = info.variant or "unknown"
              local desc = info.description or entry
              return {
                value = entry,
                display = string.format("%-20s [%s] %s", entry, variant, desc),
                ordinal = entry,
              }
            end,
          },
          sorter = conf.generic_sorter(picker_opts),
          attach_mappings = function(prompt_bufnr, _map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                theme.apply_theme(selection.value)
              end
            end)
            return true
          end,
        })
        picker:find()
      end

      -- Create commands for theme switching
      vim.api.nvim_create_user_command("ThemeSwitch", open_theme_picker, {})

      -- Smart dark/light switching (remembers last-used theme per category)
      vim.api.nvim_create_user_command("ThemeDark", function()
        require("core.theme").switch_to_dark()
      end, {})

      vim.api.nvim_create_user_command("ThemeLight", function()
        require("core.theme").switch_to_light()
      end, {})

      vim.api.nvim_create_user_command("ThemeTxaty", function()
        theme.apply_theme "txaty"
      end, {})

      -- Setup keymaps
      local map = vim.keymap.set

      -- Theme switching keymaps (using <leader>c* for colorscheme)
      map("n", "<leader>cc", open_theme_picker, { desc = "Color: choose colorscheme", noremap = true, silent = true })

      -- Smart dark/light switching (uses last-used theme per category)
      map("n", "<leader>cd", function()
        require("core.theme").switch_to_dark()
      end, { desc = "Color: switch to dark theme", noremap = true, silent = true })

      map("n", "<leader>cl", function()
        require("core.theme").switch_to_light()
      end, { desc = "Color: switch to light theme", noremap = true, silent = true })

      map("n", "<leader>cp", function()
        theme.apply_theme "txaty"
      end, { desc = "Color: switch to txaty theme", noremap = true, silent = true })

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

      -- Next/Previous theme
      map("n", "<leader>cn", function()
        cycle_theme(1)
      end, { desc = "Color: next theme", noremap = true, silent = true })

      map("n", "<leader>cN", function()
        cycle_theme(-1)
      end, { desc = "Color: previous theme", noremap = true, silent = true })
    end,
  },
}
