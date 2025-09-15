-- Prefer automatic installation without hardcoding server lists.
-- This avoids ordering issues with lspconfig loading.
require("mason-lspconfig").setup {
  automatic_installation = true,
}
