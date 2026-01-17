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
        local telescope = require "telescope.builtin"
        local themes = theme.get_all_themes()

        local picker_opts = {
          prompt_title = "  Switch Theme",
          results_title = "Available Themes",
          preview_title = "Theme Preview",
          previewer = false,
        }

        telescope.find_files(vim.tbl_extend("force", picker_opts, {
          search_dirs = {},
          results_handler = function() end,
        }))

        -- Simpler approach: use built-in theme picker with custom handling
        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"
        local conf = require "telescope.config".values

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
          attach_mappings = function(prompt_bufnr, map)
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

      vim.api.nvim_create_user_command("ThemeDark", function()
        local theme_module = require "core.theme"
        local dark_themes = theme_module.themes.dark
        if #dark_themes > 0 then
          theme_module.apply_theme(dark_themes[1])
        end
      end, {})

      vim.api.nvim_create_user_command("ThemeLight", function()
        local theme_module = require "core.theme"
        local light_themes = theme_module.themes.light
        if #light_themes > 0 then
          theme_module.apply_theme(light_themes[1])
        end
      end, {})

      vim.api.nvim_create_user_command("ThemeTxaty", function()
        theme.apply_theme "txaty"
      end, {})

      -- Setup keymaps
      local map = vim.keymap.set

      -- Theme switching keymaps (using <leader>c* for colorscheme)
      map(
        "n",
        "<leader>cc",
        open_theme_picker,
        { desc = "Color: choose colorscheme", noremap = true, silent = true }
      )

      map("n", "<leader>cd", function()
        local dark = theme.get_themes_by_variant "dark"
        if dark and #dark > 0 then
          theme.apply_theme(dark[1])
        end
      end, { desc = "Color: switch to dark theme", noremap = true, silent = true })

      map("n", "<leader>cl", function()
        local light = theme.get_themes_by_variant "light"
        if light and #light > 0 then
          theme.apply_theme(light[1])
        end
      end, { desc = "Color: switch to light theme", noremap = true, silent = true })

      map("n", "<leader>cp", function()
        theme.apply_theme "txaty"
      end, { desc = "Color: switch to txaty theme", noremap = true, silent = true })

      -- Next/Previous theme
      map("n", "<leader>cn", function()
        local all_themes = theme.get_all_themes()
        local saved = theme.load_saved_theme() or "catppuccin"
        local idx = 1
        for i, t in ipairs(all_themes) do
          if t == saved then
            idx = i
            break
          end
        end
        local next_idx = idx % #all_themes + 1
        theme.apply_theme(all_themes[next_idx])
      end, { desc = "Color: next theme", noremap = true, silent = true })

      map("n", "<leader>cN", function()
        local all_themes = theme.get_all_themes()
        local saved = theme.load_saved_theme() or "catppuccin"
        local idx = 1
        for i, t in ipairs(all_themes) do
          if t == saved then
            idx = i
            break
          end
        end
        local prev_idx = idx - 1
        if prev_idx < 1 then
          prev_idx = #all_themes
        end
        theme.apply_theme(all_themes[prev_idx])
      end, { desc = "Color: previous theme", noremap = true, silent = true })
    end,
  },
}
