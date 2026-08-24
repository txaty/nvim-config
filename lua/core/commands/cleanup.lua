-- Cleanup command
local M = {}

function M.register()
  vim.api.nvim_create_user_command("CleanupNvim", function()
    require("core.cleanup").manual_cleanup()
  end, { desc = "Clean up temporary and cache files" })
end

return M
