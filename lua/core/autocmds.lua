local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Initialize UI toggle state on startup (deferred to avoid blocking)
-- Note: ui_toggle is loaded on-demand; init() is fast (just reads vim.g)
vim.schedule(function()
  require("core.ui_toggle").init()
end)

-- Auto-cleanup on startup (throttled to run at most once per day)
vim.schedule(function()
  local ok, cleanup = pcall(require, "core.cleanup")
  if ok then
    pcall(cleanup.auto_cleanup)
  end
end)

-- Apply UI state to new windows
autocmd({ "WinNew", "BufWinEnter" }, {
  group = augroup "ui_state",
  callback = function()
    require("core.ui_toggle").apply()
  end,
})

-- Prose-friendly settings for text files (overrides session state)
autocmd("FileType", {
  group = augroup "prose_settings",
  pattern = { "markdown", "text", "tex", "typst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- View saving logic (folds only, excludes special buffers)
-- Debounced to avoid excessive I/O during rapid buffer switches
local view_save_timer = nil
local DEBOUNCE_MS = 100

autocmd({ "BufWinLeave" }, {
  group = augroup "view_saving",
  pattern = "*",
  callback = function()
    local bufname = vim.fn.expand "%"
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    if bufname == "" or buftype ~= "" or filetype == "NvimTree" or filetype == "help" then
      return
    end
    -- Debounce: cancel pending save and schedule a new one
    if view_save_timer then
      view_save_timer:stop()
    end
    view_save_timer = vim.defer_fn(function()
      pcall(vim.cmd, "mkview")
    end, DEBOUNCE_MS)
  end,
})

autocmd({ "BufWinEnter" }, {
  group = augroup "view_loading",
  pattern = "*",
  callback = function()
    local bufname = vim.fn.expand "%"
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    if bufname == "" or buftype ~= "" or filetype == "NvimTree" or filetype == "help" then
      return
    end
    vim.cmd "silent! loadview"
  end,
})

-- Python specific folding config
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.foldmethod = "manual"
  end,
})

-- Session auto-restore: runs on VimEnter before everything else
autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("SessionAutoRestore", { clear = true }),
  nested = true,
  callback = function()
    local argc = vim.fn.argc()

    -- Determine if session should be restored
    local should_restore = false
    if argc == 0 then
      should_restore = true
    elseif argc == 1 then
      local arg = vim.fn.argv(0)
      -- Restore if argument is empty, ".", or a directory
      if arg == "" or arg == "." or vim.fn.isdirectory(arg) == 1 then
        should_restore = true
      end
    end

    if should_restore then
      local ok, persistence = pcall(require, "persistence")
      if not ok then
        return
      end

      local session_file = persistence.current()
      if vim.fn.filereadable(session_file) == 1 then
        pcall(persistence.load)
      end
    end
  end,
})

-- Theme restoration: runs AFTER session restore
autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ThemeRestoration", { clear = true }),
  nested = true,
  callback = function()
    -- Schedule for after session restore
    vim.schedule(function()
      local theme = require "core.theme"
      local saved_theme = theme.load_saved_theme()

      if saved_theme then
        -- Apply saved theme without notification to avoid spam
        local ok = pcall(theme.restore_theme)
        if not ok then
          -- Silently fallback to catppuccin if restore fails
          pcall(theme.apply_theme, "catppuccin")
        end
      else
        -- First time: apply default theme
        pcall(theme.apply_theme, "catppuccin")
      end
    end)
  end,
})

-- Session auto-save: runs on exit
autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("SessionAutoSave", { clear = true }),
  callback = function()
    local ok, persistence = pcall(require, "persistence")
    if ok then
      pcall(persistence.save)
    end
  end,
})

-- Auto-save theme whenever it changes
autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ThemeAutoSave", { clear = true }),
  callback = function()
    local theme = require "core.theme"
    local current = vim.g.colors_name

    -- Only save if it's a theme we recognize
    if current and theme.theme_info[current] then
      theme.save_theme(current)
    end
  end,
})

-- Open nvim-tree on startup
autocmd("VimEnter", {
  callback = function(data)
    -- real file?
    local real_file = vim.fn.filereadable(data.file) == 1
    -- directory?
    local directory = vim.fn.isdirectory(data.file) == 1

    -- Helper to open nvim-tree safely (deferred to avoid coroutine conflicts with bufferline)
    local function open_tree(opts)
      vim.schedule(function()
        -- Clean up any stale NvimTree buffers from session restore
        -- These buffers exist but nvim-tree plugin wasn't initialized
        -- Must complete before opening nvim-tree to avoid E95 name conflict
        local cleaned = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            if name:match "NvimTree_" then
              -- Wipe the buffer completely (more thorough than delete)
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
              cleaned = true
            end
          end
        end

        -- If we cleaned buffers, defer opening to next event loop iteration
        -- to ensure buffer names are fully released
        local function do_open()
          local ok, api = pcall(require, "nvim-tree.api")
          if not ok then
            return
          end
          pcall(api.tree.open, opts)
        end

        if cleaned then
          vim.schedule(do_open)
        else
          do_open()
        end
      end)
    end

    -- if no file is provided, open the tree
    -- if a directory is provided, open the tree and change directory
    if directory then
      vim.cmd.cd(data.file)
      open_tree()
      return
    end

    -- if a real file is provided, open the tree but verify the file is focused
    if real_file then
      open_tree { focus = false, find_file = true }
      return
    end

    -- Fallback: open tree if no args provided (dashboard replacement)
    -- Skip if session is being auto-restored
    if data.file == "" and vim.bo.buftype == "" then
      -- Check if persistence.nvim will restore a session (direct file check for performance)
      local session_dir = vim.fn.stdpath "state" .. "/sessions/"
      local cwd_escaped = vim.fn.getcwd():gsub("/", "%%")
      local session_file = session_dir .. cwd_escaped .. ".vim"
      local has_session = vim.fn.filereadable(session_file) == 1

      -- Only open nvim-tree if no session exists
      if not has_session then
        open_tree()
      end
    end
  end,
})

-- Theme Commands (defined early for immediate availability)
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

vim.api.nvim_create_user_command("ThemeDark", function()
  local ok, theme = pcall(require, "core.theme")
  if ok then
    theme.switch_to_dark()
  else
    vim.notify("Failed to load theme module", vim.log.levels.ERROR)
  end
end, { desc = "Switch to dark theme" })

vim.api.nvim_create_user_command("ThemeLight", function()
  local ok, theme = pcall(require, "core.theme")
  if ok then
    theme.switch_to_light()
  else
    vim.notify("Failed to load theme module", vim.log.levels.ERROR)
  end
end, { desc = "Switch to light theme" })

vim.api.nvim_create_user_command("ThemeTxaty", function()
  local ok, theme = pcall(require, "core.theme")
  if ok then
    theme.apply_theme "txaty"
  else
    vim.notify("Failed to load theme module", vim.log.levels.ERROR)
  end
end, { desc = "Switch to txaty theme" })

-- AI Toggle Commands (lazy-loaded for faster startup)
vim.api.nvim_create_user_command("AIToggle", function()
  local ok, ai = pcall(require, "core.ai_toggle")
  if ok then
    ai.toggle()
  else
    vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
  end
end, { desc = "Toggle AI features (Copilot)" })

vim.api.nvim_create_user_command("AIEnable", function()
  local ok, ai = pcall(require, "core.ai_toggle")
  if ok then
    ai.enable()
  else
    vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
  end
end, { desc = "Enable AI features" })

vim.api.nvim_create_user_command("AIDisable", function()
  local ok, ai = pcall(require, "core.ai_toggle")
  if ok then
    ai.disable()
  else
    vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
  end
end, { desc = "Disable AI features" })

vim.api.nvim_create_user_command("AIStatus", function()
  local ok, ai = pcall(require, "core.ai_toggle")
  if ok then
    local icon = ai.is_enabled() and "✓" or "✗"
    vim.notify(string.format("%s AI features are %s", icon, ai.status()), vim.log.levels.INFO)
  else
    vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
  end
end, { desc = "Show AI features status" })

-- Language Toggle Commands (lazy-loaded for faster startup)
vim.api.nvim_create_user_command("LangEnable", function(opts)
  local ok, lang_toggle = pcall(require, "core.lang_toggle")
  if ok then
    lang_toggle.enable(opts.args)
  else
    vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
  end
end, {
  nargs = 1,
  complete = function()
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    return ok and lang_toggle.get_all_languages() or {}
  end,
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
  complete = function()
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    return ok and lang_toggle.get_all_languages() or {}
  end,
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
  complete = function()
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    return ok and lang_toggle.get_all_languages() or {}
  end,
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
  complete = function()
    local ok, lang_toggle = pcall(require, "core.lang_toggle")
    return ok and lang_toggle.get_all_languages() or {}
  end,
  desc = "Show language support status",
})

vim.api.nvim_create_user_command("LangPanel", function()
  -- Trigger lazy-loading of lang-panel plugin which sets up the Telescope picker
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

-- Cleanup Command (manual trigger with verbose output)
vim.api.nvim_create_user_command("CleanupNvim", function()
  local ok, cleanup = pcall(require, "core.cleanup")
  if ok then
    cleanup.manual_cleanup()
  else
    vim.notify("Failed to load cleanup module", vim.log.levels.ERROR)
  end
end, { desc = "Clean up temporary and cache files" })
