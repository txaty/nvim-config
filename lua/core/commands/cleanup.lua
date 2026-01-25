-- Cleanup command
local M = {}

function M.register()
  vim.api.nvim_create_user_command("CleanupNvim", function()
    local ok, cleanup = pcall(require, "core.cleanup")
    if ok then
      cleanup.manual_cleanup()
    else
      vim.notify("Failed to load cleanup module", vim.log.levels.ERROR)
    end
  end, { desc = "Clean up temporary and cache files" })
end

return M
