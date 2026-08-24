-- Session persistence commands: :SessionToggle / :SessionEnable / ... / :SessionStatus
local M = {}

function M.register()
  require("core.commands.flag_commands").register {
    prefix = "Session",
    module = "core.session_toggle",
    label = "session persistence",
    toggle_desc = "Toggle session persistence (auto-restore/save)",
  }
end

return M
