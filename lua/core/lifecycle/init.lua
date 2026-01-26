-- Lifecycle orchestrator
-- Single point of control for post-startup initialization
-- Ensures deterministic ordering of startup tasks
local M = {}

--- Post-session restore tasks
local function post_session_restore()
  -- Re-enable and trigger Treesitter parsing for all buffers
  -- This fixes missing highlights in buffers restored by persistence.nvim,
  -- as they are loaded before the BufRead/BufNewFile autocmds are registered.
  vim.schedule(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if ft and ft ~= "" then
          -- Stop any existing parser first
          pcall(vim.treesitter.stop, buf)
          -- Start treesitter highlighting for this buffer
          pcall(vim.treesitter.start, buf, ft)
        end
      end
    end
  end)
end

--- Run the startup sequence in deterministic order
--- Called from VimEnter autocmd
function M.run_sequence()
  -- Step 1: Colorscheme (sync, before any UI renders)
  require("core.lifecycle.colorscheme").restore()

  -- Step 2: Session (may change buffers/windows)
  local session_restored = require("core.lifecycle.session").restore()
  if session_restored then
    post_session_restore()
  end

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
