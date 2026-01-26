-- Lifecycle orchestrator
-- Single point of control for post-startup initialization
-- Ensures deterministic ordering of startup tasks
local M = {}

local debug_lifecycle = vim.g.debug_lifecycle or false
local t0 = 0

local function log(msg)
  if debug_lifecycle then
    local elapsed_ms = (vim.uv.hrtime() - t0) / 1e6
    vim.schedule(function()
      vim.notify(string.format("[lifecycle +%.1fms] %s", elapsed_ms, msg), vim.log.levels.DEBUG)
    end)
  end
end

--- Re-trigger buffer events for session-restored buffers.
--- persistence.nvim restores buffers via `:source` which does NOT fire
--- BufReadPre/BufReadPost/FileType events.  Lazy-loaded plugins (LSP,
--- treesitter, gitsigns, lint, …) depend on these events to load and
--- attach.  This function emits the events synthetically so every
--- buffer gets full editor support.
local function retrigger_buffer_events()
  vim.schedule(function()
    local bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
        table.insert(bufs, buf)
      end
    end
    if #bufs == 0 then
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
  end)
end

--- Run the startup sequence in deterministic order
--- Called from VimEnter autocmd
function M.run_sequence()
  t0 = vim.uv.hrtime()
  log "start"

  -- Step 1: Colorscheme (sync, before any UI renders)
  require("core.lifecycle.colorscheme").restore()
  log "colorscheme restored"

  -- Step 2: Session (may change buffers/windows)
  local session_restored = require("core.lifecycle.session").restore()
  log("session restore: " .. tostring(session_restored))
  if session_restored then
    retrigger_buffer_events()
  end

  -- Step 3: UI state (apply to all windows including restored ones)
  require("core.lifecycle.ui_state").init()
  log "ui_state init"
  if session_restored then
    -- Defer slightly to ensure session windows are ready
    vim.schedule(function()
      require("core.lifecycle.ui_state").apply_all()
      log "ui_state apply_all (deferred)"
    end)
  end

  -- Step 4: NvimTree (session-aware, uses single deferred call)
  require("core.lifecycle.nvim_tree").auto_open(session_restored)
  log "nvim_tree auto_open"

  -- Step 5: Commands (after plugins ready)
  local ok, commands = pcall(require, "core.commands")
  if ok and commands.register_all then
    commands.register_all()
  end
  log "commands registered"

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
  vim.schedule(function()
    local cleanup_ok, cleanup = pcall(require, "core.cleanup")
    if cleanup_ok then
      pcall(cleanup.auto_cleanup)
    end
    log "cleanup (deferred)"
  end)

  log "run_sequence complete (sync portion)"
end

--- Setup the lifecycle VimEnter autocmd
function M.setup()
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
