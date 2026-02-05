-- Lifecycle orchestrator
-- Single point of control for post-startup initialization
-- Ensures deterministic ordering of startup tasks
--
-- DEBUG LOGGING:
--   vim.g.debug_lifecycle = true   -- log lifecycle steps
--   vim.g.debug_plugin_load = true -- log every plugin load (via lazy.nvim)
--
-- Example: nvim --cmd "let g:debug_lifecycle=1" --cmd "let g:debug_plugin_load=1"
local M = {}

local debug_lifecycle = vim.g.debug_lifecycle or false
local debug_plugin_load = vim.g.debug_plugin_load or false
local t0 = 0
local load_log = {} -- Accumulated plugin load events for summary

local function log(msg)
  if debug_lifecycle then
    local elapsed_ms = (vim.uv.hrtime() - t0) / 1e6
    vim.schedule(function()
      vim.notify(string.format("[lifecycle +%.1fms] %s", elapsed_ms, msg), vim.log.levels.DEBUG)
    end)
  end
end

--- Setup lazy.nvim plugin load event logging
--- Must be called after lazy.nvim is available but before plugins load
local function setup_plugin_load_logging()
  if not debug_plugin_load then
    return
  end

  local ok, _ = pcall(require, "lazy")
  if not ok then
    return
  end

  -- Hook into lazy.nvim's event system
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
      local elapsed_ms = (vim.uv.hrtime() - t0) / 1e6
      local plugin = ev.data or "unknown"
      table.insert(load_log, { time = elapsed_ms, plugin = plugin })
      vim.schedule(function()
        vim.notify(string.format("[plugin +%.1fms] %s", elapsed_ms, plugin), vim.log.levels.DEBUG)
      end)
    end,
  })
end

--- Print summary of plugin load order (for verification)
function M.print_load_summary()
  if #load_log == 0 then
    vim.notify("No plugin load events recorded. Enable with vim.g.debug_plugin_load = true", vim.log.levels.WARN)
    return
  end

  local lines = { "Plugin Load Order:" }
  for i, entry in ipairs(load_log) do
    table.insert(lines, string.format("  %2d. +%6.1fms  %s", i, entry.time, entry.plugin))
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

--- Verify critical load order assumptions
--- Only runs when debug mode is enabled (vim.g.debug_lifecycle or vim.g.debug_plugin_load)
local function verify_load_order()
  if not (vim.g.debug_lifecycle or vim.g.debug_plugin_load) then
    return
  end

  local checks = {
    {
      name = "navic loads before lspconfig",
      check = function()
        -- Check the load log for ordering (only works if debug_plugin_load enabled)
        if #load_log > 0 then
          local navic_idx, lspconfig_idx
          for i, entry in ipairs(load_log) do
            if entry.plugin == "nvim-navic" then
              navic_idx = i
            end
            if entry.plugin == "nvim-lspconfig" then
              lspconfig_idx = i
            end
          end
          -- If both loaded, verify navic came first
          if navic_idx and lspconfig_idx then
            if navic_idx >= lspconfig_idx then
              return false, string.format("navic loaded at position %d, lspconfig at %d", navic_idx, lspconfig_idx)
            end
          end
        end
        -- Fallback check: if LSP clients exist, navic should be loaded
        local lsp_clients = vim.lsp.get_clients()
        if #lsp_clients > 0 then
          local navic_loaded = package.loaded["nvim-navic"] ~= nil
          if not navic_loaded then
            return false, "LSP clients attached but navic not loaded"
          end
        end
        return true
      end,
    },
    {
      name = "colorscheme set before UI plugins",
      check = function()
        if not vim.g.colors_name or vim.g.colors_name == "" then
          return false, "No colorscheme set (vim.g.colors_name is nil/empty)"
        end
        return true
      end,
    },
    {
      name = "snacks.nvim loads early (priority=1000, lazy=false)",
      check = function()
        -- Snacks should be first or near-first in load log
        if #load_log > 0 then
          local snacks_idx
          for i, entry in ipairs(load_log) do
            if entry.plugin == "snacks.nvim" then
              snacks_idx = i
              break
            end
          end
          -- Snacks should be in first 3 positions (allow for some variance)
          if snacks_idx and snacks_idx > 3 then
            return false, string.format("snacks.nvim loaded at position %d (expected 1-3)", snacks_idx)
          end
        end
        return true
      end,
    },
    {
      name = "mason-lspconfig available for language extensions",
      check = function()
        -- Verify mason-lspconfig can be required (language files depend on it)
        local ok = pcall(require, "mason-lspconfig")
        if not ok then
          return false, "mason-lspconfig module not available"
        end
        return true
      end,
    },
  }

  local all_passed = true
  for _, check in ipairs(checks) do
    local ok, err = check.check()
    if not ok then
      all_passed = false
      vim.notify(
        string.format("[lifecycle] ASSERTION FAILED: %s - %s", check.name, err or "unknown"),
        vim.log.levels.ERROR
      )
    else
      log(string.format("✓ assertion passed: %s", check.name))
    end
  end

  if all_passed then
    log "✓ all load order assertions passed"
  end
end

--- Re-trigger buffer events for session-restored buffers.
--- persistence.nvim restores buffers via `:source` which does NOT fire
--- BufReadPre/BufReadPost/FileType events.  Lazy-loaded plugins (LSP,
--- treesitter, gitsigns, lint, …) depend on these events to load and
--- attach.  This function emits the events synthetically so every
--- buffer gets full editor support.
---
---@param on_complete? function Optional callback invoked after all events are triggered
local function retrigger_buffer_events(on_complete)
  vim.schedule(function()
    local bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
        table.insert(bufs, buf)
      end
    end
    if #bufs == 0 then
      if on_complete then
        on_complete()
      end
      return
    end

    -- Phase 1: Emit BufReadPre/BufReadPost so lazy.nvim loads plugins
    -- that trigger on these events (LSP, treesitter, gitsigns, lint, …).
    for _, buf in ipairs(bufs) do
      pcall(vim.api.nvim_exec_autocmds, "BufReadPre", { buffer = buf })
    end
    for _, buf in ipairs(bufs) do
      pcall(vim.api.nvim_exec_autocmds, "BufReadPost", { buffer = buf, modeline = false })
    end

    -- Phase 2: Emit FileType so servers registered with vim.lsp.enable()
    -- (which listens on FileType) attach to the restored buffers.
    for _, buf in ipairs(bufs) do
      local ft = vim.bo[buf].filetype
      if ft and ft ~= "" then
        pcall(vim.api.nvim_exec_autocmds, "FileType", { buffer = buf, pattern = ft })
      end
    end

    -- Signal completion to allow dependent operations to proceed
    if on_complete then
      -- Defer callback one more tick to ensure plugin handlers have run
      vim.schedule(on_complete)
    end
  end)
end

--- Run the startup sequence in deterministic order
--- Called from VimEnter autocmd
function M.run_sequence()
  -- Preserve t0 if already set by setup() for plugin load logging
  if t0 == 0 then
    t0 = vim.uv.hrtime()
  end
  log "start"

  -- Step 1: Colorscheme (sync, before any UI renders)
  require("core.lifecycle.colorscheme").restore()
  log "colorscheme restored"

  -- Step 2: Session (may change buffers/windows)
  local session_restored = require("core.lifecycle.session").restore()
  log("session restore: " .. tostring(session_restored))

  -- Step 3: UI state initialization (sets vim.g globals only, no window ops)
  -- Call core.ui_toggle directly (no wrapper indirection)
  local ok_ui, ui_toggle = pcall(require, "core.ui_toggle")
  if ok_ui then
    ui_toggle.init()
    log "ui_state init"
  end

  -- Step 4: Buffer events and dependent UI operations
  -- IMPORTANT: retrigger_buffer_events() is async. UI operations that depend on
  -- fully initialized buffers (ui_toggle.apply_all, nvim_tree.auto_open) must
  -- wait until buffer events settle to avoid race conditions.
  if session_restored then
    retrigger_buffer_events(function()
      -- This callback runs AFTER all buffer events have been triggered
      log "buffer events complete"

      -- Apply UI state to all windows (now safe, buffers are initialized)
      if ok_ui then
        ui_toggle.apply_all()
        log "ui_state apply_all (after buffer events)"
      end

      -- NvimTree auto-open (session-aware)
      require("core.lifecycle.nvim_tree").auto_open(session_restored)
      log "nvim_tree auto_open (after buffer events)"
    end)
  else
    -- No session restored: run UI operations immediately
    require("core.lifecycle.nvim_tree").auto_open(false)
    log "nvim_tree auto_open (no session)"
  end

  -- Step 5: Commands (deferred — rarely needed in first ms after VimEnter)
  vim.schedule(function()
    local ok_cmd, commands = pcall(require, "core.commands")
    if ok_cmd and commands.register_all then
      commands.register_all()
    end
    log "commands registered (deferred)"
  end)

  -- Step 5b: Keymap conflict audit (opt-in via vim.g.debug_keymaps)
  -- Guard the require to avoid loading the module when audit is disabled
  if vim.g.debug_keymaps then
    require("core.keymap_audit").check()
  end

  -- Step 6: Focus reconciliation after all UI plugins load
  -- Bufferline highlights the active tab by comparing nvim_get_current_buf()
  -- against its tab list. If the cursor lands on a stale NvimTree buffer that
  -- gets deleted, the current buffer becomes unlisted and no tab matches.
  -- Wait for VeryLazy (after bufferline.setup()) then move focus to a real
  -- file buffer so the tabline renders correctly.
  if session_restored then
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        vim.schedule(function()
          require("core.lifecycle.reconcile").ensure_focus()
          log "reconcile ensure_focus (deferred)"
        end)
      end,
    })
  end

  -- Step 7: Cleanup (throttled, background - low priority)
  -- Defer by 2s to avoid loading 340-line module near startup
  vim.defer_fn(function()
    local cleanup_ok, cleanup = pcall(require, "core.cleanup")
    if cleanup_ok then
      pcall(cleanup.auto_cleanup)
    end
    log "cleanup (deferred)"
  end, 2000)

  log "run_sequence complete (sync portion)"

  -- Step 8: Verify critical load order assumptions (debug mode only)
  -- Deferred slightly to allow lazy-loaded plugins to finish loading
  vim.defer_fn(function()
    verify_load_order()
  end, 100)
end

--- Setup the lifecycle VimEnter autocmd
function M.setup()
  -- Initialize timing reference point early for plugin load logging
  t0 = vim.uv.hrtime()

  -- Setup plugin load logging before any plugins load
  setup_plugin_load_logging()

  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("NvimLifecycle", { clear = true }),
    once = true,
    nested = true,
    callback = function()
      M.run_sequence()
    end,
  })
end

return M
