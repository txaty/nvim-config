-- Core autocmds
-- Minimal set of autocmds required for base functionality
-- VimEnter lifecycle and commands are handled by dedicated modules

local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- ============================================================================
-- Lifecycle Setup (single VimEnter handler for all startup tasks)
-- ============================================================================
require("core.lifecycle").setup()

-- ============================================================================
-- UI State Management
-- ============================================================================

-- Apply UI state to new windows
autocmd({ "WinNew", "BufWinEnter" }, {
  group = augroup "ui_state",
  callback = function()
    local ok, ui_toggle = pcall(require, "core.ui_toggle")
    if ok then
      ui_toggle.apply()
    end
  end,
})

-- ============================================================================
-- File Type Settings
-- ============================================================================

-- Prose-friendly settings for text files
-- NOTE: Prose filetypes always force wrap=true, regardless of global UI setting
autocmd("FileType", {
  group = augroup "prose_settings",
  pattern = { "markdown", "text", "tex", "typst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

-- Python specific folding config
autocmd("FileType", {
  group = augroup "python_settings",
  pattern = "python",
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.foldmethod = "manual"
  end,
})

-- ============================================================================
-- Cursor and View Management
-- ============================================================================

-- Restore cursor position
autocmd("BufReadPost", {
  group = augroup "restore_cursor",
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

autocmd("BufWinLeave", {
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

autocmd("BufWinEnter", {
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

-- ============================================================================
-- Session and Theme Persistence
-- ============================================================================

-- Session auto-save on exit
autocmd("VimLeavePre", {
  group = augroup "SessionAutoSave",
  callback = function()
    local ok, session = pcall(require, "core.lifecycle.session")
    if ok then
      session.save()
    end
  end,
})

-- Auto-save theme whenever it changes (skip during live preview)
autocmd("ColorScheme", {
  group = augroup "ThemeAutoSave",
  callback = function()
    local ok, theme = pcall(require, "core.theme")
    if not ok then
      return
    end
    -- Don't persist during theme picker preview
    if theme._previewing then
      return
    end
    local current = vim.g.colors_name
    -- Only save if it's a theme we recognize
    if current and theme.theme_info[current] then
      theme.save_theme(current)
    end
  end,
})
