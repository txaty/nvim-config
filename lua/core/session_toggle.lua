-- Session persistence toggle.
--
-- Mirrors the persisted state into vim.g.enable_session_persistence, which the
-- lifecycle "session restore" step and the VimLeavePre auto-save autocmd read.
-- init() must run before either of those — core/init.lua calls it at
-- require-time, ahead of lifecycle.setup().
--
-- Defaults to ON, unlike the other security-gated flags: restoring your own
-- buffers reads no untrusted input.
local flag = require("core.persist_flag").new {
  filename = "session_config.json",
  default = true,
  label = "Session persistence",
  hint = "Takes effect on next startup for auto-restore.",
  on_set = function(enabled)
    vim.g.enable_session_persistence = enabled
  end,
}

--- Apply the persisted flag to vim.g. Idempotent.
function flag.init()
  vim.g.enable_session_persistence = flag.is_enabled()
end

return flag
