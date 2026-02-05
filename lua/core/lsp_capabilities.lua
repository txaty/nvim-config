-- LSP Capabilities - Single source of truth
--
-- This module provides a centralized place to build LSP capabilities
-- that can be shared across all LSP server configurations.
--
-- Usage:
--   local caps = require("core.lsp_capabilities")
--   vim.lsp.config("server", { capabilities = caps.get() })
--
-- The capabilities are built lazily on first access and cached.
-- blink.cmp enhancements are applied if the plugin is available.

local M = {}

-- Cached capabilities (built on first access)
local cached_capabilities = nil

--- Get LSP capabilities with completion enhancements
--- @return table capabilities The LSP capabilities table
function M.get()
  if cached_capabilities then
    return cached_capabilities
  end

  -- Start with base LSP capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Enhance with blink.cmp capabilities if available
  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  cached_capabilities = capabilities
  return cached_capabilities
end

--- Force rebuild of capabilities (useful if blink.cmp loaded after initial access)
--- @return table capabilities The rebuilt LSP capabilities table
function M.refresh()
  cached_capabilities = nil
  return M.get()
end

return M
