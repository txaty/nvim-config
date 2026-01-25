-- Lifecycle orchestrator
-- Single point of control for post-startup initialization
-- Ensures deterministic ordering of startup tasks
local M = {}

--- Run the startup sequence in deterministic order
--- Called from VimEnter autocmd
function M.run_sequence()
  -- Step 1: Colorscheme (sync, before any UI renders)
  require("core.lifecycle.colorscheme").restore()

  -- Step 2: Session (may change buffers/windows)
  local session_restored = require("core.lifecycle.session").restore()

  -- Step 3: UI state (apply to all windows including restored ones)
  require("core.lifecycle.ui_state").init()
  if session_restored then
    -- Defer slightly to ensure session windows are ready
    vim.schedule(function()
      require("core.lifecycle.ui_state").apply_all()
    end)
  end

  -- Step 4: NvimTree (session-aware, uses single deferred call)
  require("core.lifecycle.nvim_tree").auto_open(session_restored)

  -- Step 5: Commands (after plugins ready)
  local ok, commands = pcall(require, "core.commands")
  if ok and commands.register_all then
    commands.register_all()
  end

  -- Step 6: Cleanup (throttled, background - low priority)
  vim.schedule(function()
    local cleanup_ok, cleanup = pcall(require, "core.cleanup")
    if cleanup_ok then
      pcall(cleanup.auto_cleanup)
    end
  end)
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
