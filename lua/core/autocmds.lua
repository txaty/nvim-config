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
-- Keymap Audit
-- ============================================================================
-- Runs once on VeryLazy and only notifies when conflicts are found.
-- Set vim.g.debug_keymaps=1 for additional "no conflicts" info messages.
require("core.keymap_audit").setup()

-- ============================================================================
-- UI State Management
-- ============================================================================

-- OPT-2: Defer UI state autocmd registration to VeryLazy
-- This prevents apply() from running during startup window operations (~1-2ms saved)
-- Initial UI state is applied by lifecycle's apply_all() at VimEnter
-- This autocmd handles new windows/splits created after startup
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local _ui_toggle -- Cache module reference to avoid pcall(require) on every buffer switch
    autocmd({ "WinNew", "BufWinEnter" }, {
      group = augroup "ui_state",
      callback = function()
        if _ui_toggle then
          _ui_toggle.apply()
          return
        end
        local ok, mod = pcall(require, "core.ui_toggle")
        if ok then
          _ui_toggle = mod
          mod.apply()
        end
      end,
    })
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
-- Debounced with a single reusable timer to avoid handle leaks
local view_save_timer = vim.uv.new_timer()
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

    -- OPT-4: Only save views for buffers with folds (reduces unnecessary disk I/O)
    -- Check if buffer has non-manual foldmethod or existing folds
    local foldmethod = vim.wo.foldmethod
    local has_folds = false
    if foldmethod ~= "manual" then
      has_folds = true
    else
      -- For manual foldmethod, check if any folds exist
      -- foldlevel() returns >0 if line is in a fold
      local line_count = vim.fn.line "$"
      for i = 1, math.min(line_count, 100) do -- Sample first 100 lines for performance
        if vim.fn.foldlevel(i) > 0 then
          has_folds = true
          break
        end
      end
    end

    if not has_folds then
      return -- Skip mkview for files without folds
    end

    -- Debounce: restart the single timer (stop + start avoids handle leak)
    view_save_timer:stop()
    view_save_timer:start(
      DEBOUNCE_MS,
      0,
      vim.schedule_wrap(function()
        pcall(vim.cmd, "mkview")
      end)
    )
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
    if theme.is_previewing() then
      return
    end
    local current = vim.g.colors_name
    -- Only save if it's a theme we recognize
    if current and theme.theme_info[current] then
      theme.save_theme(current)
    end
  end,
})
