-- Prefer automatic installation without hardcoding server lists.
-- This avoids ordering issues with lspconfig loading.
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  automatic_installation = true,
  handlers = {
    -- Skip stylua - it's a formatter, not an LSP server
    -- This prevents mason-lspconfig from trying to set it up as an LSP
    stylua = function() end,
  },
}

-- Prevent stylua from being enabled as an LSP server
-- Override vim.lsp.enable to block stylua
local original_enable = vim.lsp.enable
vim.lsp.enable = function(server_name, ...)
  if server_name == "stylua" then
    -- Silently ignore attempts to enable stylua as an LSP server
    return
  end
  return original_enable(server_name, ...)
end
