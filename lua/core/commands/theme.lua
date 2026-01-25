-- Theme-related user commands
local M = {}

function M.register()
  -- Theme picker command
  vim.api.nvim_create_user_command("ThemeSwitch", function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
      vim.notify("Telescope is required for ThemeSwitch", vim.log.levels.ERROR)
      return
    end

    local theme_ok, theme = pcall(require, "core.theme")
    if not theme_ok then
      vim.notify("Failed to load theme module: " .. tostring(theme), vim.log.levels.ERROR)
      return
    end

    local themes = theme.get_all_themes()

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
  end, { desc = "Open theme picker" })

  -- Switch to dark theme
  vim.api.nvim_create_user_command("ThemeDark", function()
    local ok, theme = pcall(require, "core.theme")
    if ok then
      theme.switch_to_dark()
    else
      vim.notify("Failed to load theme module", vim.log.levels.ERROR)
    end
  end, { desc = "Switch to dark theme" })

  -- Switch to light theme
  vim.api.nvim_create_user_command("ThemeLight", function()
    local ok, theme = pcall(require, "core.theme")
    if ok then
      theme.switch_to_light()
    else
      vim.notify("Failed to load theme module", vim.log.levels.ERROR)
    end
  end, { desc = "Switch to light theme" })

  -- Switch to txaty custom theme
  vim.api.nvim_create_user_command("ThemeTxaty", function()
    local ok, theme = pcall(require, "core.theme")
    if ok then
      theme.apply_theme "txaty"
    else
      vim.notify("Failed to load theme module", vim.log.levels.ERROR)
    end
  end, { desc = "Switch to txaty theme" })
end

return M
