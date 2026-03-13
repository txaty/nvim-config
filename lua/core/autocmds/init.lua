-- Core autocmds orchestrator
-- Each concern is isolated in its own module with an explicit setup() function.
-- No require-time side effects — all registration happens via setup().
local M = {}

function M.setup()
  require("core.autocmds.filetype").setup()
  require("core.autocmds.cursor").setup()
  require("core.autocmds.word_highlight").setup()
  require("core.autocmds.persistence").setup()
  require("core.autocmds.ui_state").setup()
end

return M
