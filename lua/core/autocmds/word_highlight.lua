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
  local doc_highlight_supported = {}

  local function has_document_highlight(bufnr)
    if doc_highlight_supported[bufnr] ~= nil then
      return doc_highlight_supported[bufnr]
    end

    local supported = #vim.lsp.get_clients {
      bufnr = bufnr,
      method = "textDocument/documentHighlight",
    } > 0
    doc_highlight_supported[bufnr] = supported
    return supported
  end

  autocmd("LspAttach", {
    group = augroup "word_highlight_fallback_lsp_attach",
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data and ev.data.client_id or -1)
      if client and client:supports_method "textDocument/documentHighlight" then
        doc_highlight_supported[ev.buf] = true
      end
    end,
  })

  autocmd("LspDetach", {
    group = augroup "word_highlight_fallback_lsp_detach",
    callback = function(ev)
      doc_highlight_supported[ev.buf] = nil
    end,
  })

  autocmd("CursorHold", {
    group = augroup "word_highlight_fallback",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local win = vim.api.nvim_get_current_win()

      -- Skip if LSP with documentHighlight is available (Snacks.words handles it)
      if has_document_highlight(bufnr) then
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

  autocmd("BufDelete", {
    group = augroup "word_highlight_fallback_buf_cleanup",
    callback = function(ev)
      doc_highlight_supported[ev.buf] = nil
    end,
  })
end

return M
