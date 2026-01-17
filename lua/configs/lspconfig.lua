local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = {}

-- Export capabilities for other modules to use
lspconfig.on_init = nvlsp.on_init
lspconfig.capabilities = nvlsp.capabilities

-- Custom on_attach function that wraps NVChad's default
lspconfig.on_attach = function(client, bufnr)
  -- Call NVChad's default on_attach
  if nvlsp.on_attach then
    nvlsp.on_attach(client, bufnr)
  end

  -- Attach vim-illuminate
  if client.server_capabilities.documentHighlightProvider then
    require("illuminate").on_attach(client)
  end
end

return lspconfig
