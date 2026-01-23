local autocmd = vim.api.nvim_create_autocmd

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

-- User's View Saving Logic
autocmd({ "BufWinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.cmd "mkview"
    end
  end,
})

autocmd({ "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.cmd "silent! loadview"
    end
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
        require("nvim-tree.api").tree.open(opts)
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

-- AI Toggle Commands (lazy-loaded for faster startup)
vim.api.nvim_create_user_command("AIToggle", function()
  require("core.ai_toggle").toggle()
end, { desc = "Toggle AI features (Copilot)" })

vim.api.nvim_create_user_command("AIEnable", function()
  require("core.ai_toggle").enable()
end, { desc = "Enable AI features" })

vim.api.nvim_create_user_command("AIDisable", function()
  require("core.ai_toggle").disable()
end, { desc = "Disable AI features" })

vim.api.nvim_create_user_command("AIStatus", function()
  local ai = require "core.ai_toggle"
  local icon = ai.is_enabled() and "✓" or "✗"
  vim.notify(string.format("%s AI features are %s", icon, ai.status()), vim.log.levels.INFO)
end, { desc = "Show AI features status" })

-- Language Toggle Commands (lazy-loaded for faster startup)
vim.api.nvim_create_user_command("LangEnable", function(opts)
  require("core.lang_toggle").enable(opts.args)
end, {
  nargs = 1,
  complete = function()
    return require("core.lang_toggle").get_all_languages()
  end,
  desc = "Enable language support",
})

vim.api.nvim_create_user_command("LangDisable", function(opts)
  require("core.lang_toggle").disable(opts.args)
end, {
  nargs = 1,
  complete = function()
    return require("core.lang_toggle").get_all_languages()
  end,
  desc = "Disable language support",
})

vim.api.nvim_create_user_command("LangToggle", function(opts)
  require("core.lang_toggle").toggle(opts.args)
end, {
  nargs = 1,
  complete = function()
    return require("core.lang_toggle").get_all_languages()
  end,
  desc = "Toggle language support",
})

vim.api.nvim_create_user_command("LangStatus", function(opts)
  local lang_toggle = require "core.lang_toggle"
  if opts.args ~= "" then
    lang_toggle.show_status(opts.args)
  else
    lang_toggle.show_all_status()
  end
end, {
  nargs = "?",
  complete = function()
    return require("core.lang_toggle").get_all_languages()
  end,
  desc = "Show language support status",
})
