-- UI state management for new windows/splits after startup
-- OPT-2: Deferred to VeryLazy to avoid overhead during startup window operations
local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local M = {}

function M.setup()
  autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      local _ui_toggle -- Cache module reference to avoid pcall(require) on every buffer switch
      autocmd({ "WinNew", "BufWinEnter" }, {
        group = augroup "ui_state",
        callback = function()
          if _ui_toggle then
            _ui_toggle.apply()
            return
          end
          local ok, mod = pcall(require, "core.ui_toggle")
          if ok then
            _ui_toggle = mod
            mod.apply()
          end
        end,
      })
    end,
  })
end

return M
