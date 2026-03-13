-- Cursor restore and view (fold) save/load
local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local M = {}

function M.setup()
  -- Restore cursor position from shada
  autocmd("BufReadPost", {
    group = augroup "restore_cursor",
    pattern = "*",
    callback = function()
      local line = vim.fn.line "'\""
      if
        line > 1
        and line <= vim.fn.line "$"
        and vim.bo.filetype ~= "commit"
        and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
      then
        vim.cmd 'normal! g`"'
      end
    end,
  })

  -- View saving logic (folds only, excludes special buffers)
  -- Debounced with a single reusable timer to avoid handle leaks
  local view_save_timer = vim.uv.new_timer()
  local DEBOUNCE_MS = 100

  autocmd("BufWinLeave", {
    group = augroup "view_saving",
    pattern = "*",
    callback = function()
      local bufname = vim.fn.expand "%"
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype
      if bufname == "" or buftype ~= "" or filetype == "NvimTree" or filetype == "help" then
        return
      end

      -- OPT-4: Only save views for buffers with folds (reduces unnecessary disk I/O)
      local foldmethod = vim.wo.foldmethod
      local has_folds = false
      if foldmethod ~= "manual" then
        has_folds = true
      else
        -- For manual foldmethod, check if any folds exist
        local line_count = vim.fn.line "$"
        for i = 1, math.min(line_count, 100) do -- Sample first 100 lines for performance
          if vim.fn.foldlevel(i) > 0 then
            has_folds = true
            break
          end
        end
      end

      if not has_folds then
        return
      end

      -- Debounce: restart the single timer (stop + start avoids handle leak)
      view_save_timer:stop()
      view_save_timer:start(
        DEBOUNCE_MS,
        0,
        vim.schedule_wrap(function()
          pcall(vim.cmd, "mkview")
        end)
      )
    end,
  })

  autocmd("BufWinEnter", {
    group = augroup "view_loading",
    pattern = "*",
    callback = function()
      local bufname = vim.fn.expand "%"
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype
      if bufname == "" or buftype ~= "" or filetype == "NvimTree" or filetype == "help" then
        return
      end
      vim.cmd "silent! loadview"
    end,
  })
end

return M
