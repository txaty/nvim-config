-- Prefer automatic installation without hardcoding server lists.
-- This avoids ordering issues with lspconfig loading.
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  automatic_installation = {
    exclude = { "stylua" },
  },
  handlers = {
    -- Skip stylua - it's a formatter, not an LSP server
    stylua = function() end,
  },
}
