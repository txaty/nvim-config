local autocmd = vim.api.nvim_create_autocmd

-- Debug logging function that writes to a file
local debug_log = function(msg, silent)
  local log_file = vim.fn.stdpath "cache" .. "/session_debug.log"
  local timestamp = os.date "%Y-%m-%d %H:%M:%S"
  local log_msg = string.format("[%s] %s\n", timestamp, msg)

  -- Append to log file
  local file = io.open(log_file, "a")
  if file then
    file:write(log_msg)
    file:close()
  end

  -- Also print to messages (unless silent)
  if not silent then
    print(msg)
  end
end

-- Debug: Verify this file is loading (silent to avoid startup prompts)
debug_log("[DEBUG] autocmds.lua is loading...", true)

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
debug_log("[DEBUG] Registering SessionAutoRestore autocmd...", true)
autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("SessionAutoRestore", { clear = true }),
  nested = true,
  callback = function()
    local argc = vim.fn.argc()
    debug_log("[DEBUG] SessionAutoRestore fired, argc = " .. argc)

    -- Check what the arguments are
    local should_restore = false
    if argc == 0 then
      debug_log "[DEBUG] No arguments, should restore session"
      should_restore = true
    elseif argc == 1 then
      -- If there's one argument, check if it's a directory or empty
      local arg = vim.fn.argv(0)
      debug_log("[DEBUG] Single argument detected: '" .. tostring(arg) .. "'")

      -- If the argument is empty, a directory, or matches current directory, restore session
      if arg == "" or arg == "." or vim.fn.isdirectory(arg) == 1 then
        debug_log "[DEBUG] Argument is directory or empty, should restore session"
        should_restore = true
      else
        debug_log("[DEBUG] Argument is a file: " .. arg .. ", skipping restore")
      end
    else
      debug_log("[DEBUG] Multiple arguments (" .. argc .. "), skipping restore")
    end

    -- Only restore session if appropriate
    if should_restore then
      debug_log "[DEBUG] Attempting to load persistence plugin..."
      local ok, persistence = pcall(require, "persistence")

      if not ok then
        debug_log("[DEBUG] Failed to load persistence: " .. tostring(persistence))
        return
      end

      debug_log "[DEBUG] Persistence plugin loaded successfully"

      -- Check if session file exists
      local session_file = persistence.current()
      debug_log("[DEBUG] Session file path: " .. session_file)

      if vim.fn.filereadable(session_file) == 1 then
        debug_log "[DEBUG] Session file exists, loading..."
        local load_ok, err = pcall(persistence.load)
        if not load_ok then
          debug_log("[DEBUG] Failed to load session: " .. tostring(err))
        else
          debug_log "[DEBUG] Session loaded successfully!"
        end
      else
        debug_log "[DEBUG] No session file found at that path"
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
debug_log("[DEBUG] Registering SessionAutoSave autocmd...", true)
autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("SessionAutoSave", { clear = true }),
  callback = function()
    debug_log "[DEBUG] VimLeavePre: Attempting to save session..."
    local ok, persistence = pcall(require, "persistence")
    if ok then
      local session_file = persistence.current()
      debug_log("[DEBUG] Saving session to: " .. session_file)
      local save_ok, err = pcall(persistence.save)
      if not save_ok then
        debug_log("[DEBUG] Failed to save: " .. tostring(err))
      else
        debug_log "[DEBUG] Session saved!"
      end
    else
      debug_log "[DEBUG] Failed to load persistence plugin"
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

    -- if no file is provided, open the tree
    -- if a directory is provided, open the tree and change directory
    if directory then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
      return
    end

    -- if a real file is provided, open the tree but verify the file is focused
    if real_file then
      require("nvim-tree.api").tree.open { focus = false, find_file = true }
      return
    end

    -- Fallback: open tree if no args provided (dashboard replacement)
    -- Skip if session is being auto-restored
    if data.file == "" and vim.bo.buftype == "" then
      -- Check if persistence.nvim will restore a session
      -- It uses current dir + branch name for git repos
      local session_dir = vim.fn.stdpath "state" .. "/sessions/"
      local cwd_pattern = vim.fn.getcwd():gsub("/", "%%")

      -- Check for session file (with or without branch name)
      local has_session = false
      local session_files = vim.fn.glob(session_dir .. cwd_pattern .. "*.vim", false, true)
      if #session_files > 0 then
        has_session = true
      end

      -- Only open nvim-tree if no session exists
      if not has_session then
        require("nvim-tree.api").tree.open()
      end
    end
  end,
})
