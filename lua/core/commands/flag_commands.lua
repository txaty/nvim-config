-- Shared registration for the :XToggle/:XEnable/:XDisable/:XStatus command
-- quartet that fronts a core.persist_flag module.
--
-- core/commands/ai.lua and core/commands/session.lua were byte-for-byte the
-- same file apart from the command prefix and the noun in the status message.
local M = {}

---@class FlagCommandsOpts
---@field prefix string      Command prefix, e.g. "AI" -> :AIToggle, :AIEnable, ...
---@field module string      Module name passed to require(), e.g. "core.ai_toggle"
---@field label string       Noun for the status message, e.g. "AI features"
---@field toggle_desc string :help-style description for the Toggle command

---@param opts FlagCommandsOpts
function M.register(opts)
  local function flag()
    return require(opts.module)
  end

  local command = function(suffix, fn, desc)
    vim.api.nvim_create_user_command(opts.prefix .. suffix, fn, { desc = desc })
  end

  command("Toggle", function()
    flag().toggle()
  end, opts.toggle_desc)

  command("Enable", function()
    flag().enable()
  end, "Enable " .. opts.label)

  command("Disable", function()
    flag().disable()
  end, "Disable " .. opts.label)

  command("Status", function()
    local f = flag()
    vim.notify(
      string.format("%s %s are %s", f.is_enabled() and "+" or "-", opts.label, f.status()),
      vim.log.levels.INFO
    )
  end, "Show " .. opts.label .. " status")
end

return M
