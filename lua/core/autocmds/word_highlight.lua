-- Fallback word occurrence highlighting for non-LSP buffers
-- Snacks.words handles LSP-attached buffers via textDocument/documentHighlight.
-- This covers plain text, gitcommit, help, and any buffer without an active
-- LSP client that supports documentHighlight.
local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local M = {}

function M.setup()
  -- Track match IDs per window to avoid cross-window leaks
  local win_match_ids = {}

  autocmd("CursorHold", {
    group = augroup "word_highlight_fallback",
    callback = function()
      local win = vim.api.nvim_get_current_win()

      -- Skip if LSP with documentHighlight is available (Snacks.words handles it)
      local clients = vim.lsp.get_clients {
        bufnr = 0,
        method = "textDocument/documentHighlight",
      }
      if #clients > 0 then
        return
      end
      -- Skip special buffers (terminal, quickfix, prompt, etc.)
      if vim.bo.buftype ~= "" then
        return
      end
      -- Clear previous match for this window
      if win_match_ids[win] then
        pcall(vim.fn.matchdelete, win_match_ids[win], win)
        win_match_ids[win] = nil
      end
      -- Highlight the word under cursor
      local word = vim.fn.expand "<cword>"
      if word ~= "" and word:match "^%w+$" then
        local pattern = [[\<]] .. word .. [[\>]]
        win_match_ids[win] = vim.fn.matchadd("LspReferenceText", pattern, 10)
      end
    end,
  })

  autocmd("CursorMoved", {
    group = augroup "word_highlight_fallback_clear",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if win_match_ids[win] then
        pcall(vim.fn.matchdelete, win_match_ids[win], win)
        win_match_ids[win] = nil
      end
    end,
  })

  -- Clean up entries for closed windows to prevent table growth
  autocmd("WinClosed", {
    group = augroup "word_highlight_fallback_cleanup",
    callback = function(ev)
      local closed_win = tonumber(ev.match)
      if closed_win then
        win_match_ids[closed_win] = nil
      end
    end,
  })
end

return M
