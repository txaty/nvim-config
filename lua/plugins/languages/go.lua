-- Go language support
local lang = require "core.lang_utils"

return {
  lang.extend_treesitter { "go", "gomod", "gowork", "gosum" },
  lang.extend_mason { "gopls", "golangci-lint", "delve", "goimports", "gomodifytags", "impl" },
  lang.extend_conform { go = { "goimports", "gofmt" } },
  lang.extend_lspconfig {
    gopls = {
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          completeUnimported = true,
          usePlaceholders = true,
          staticcheck = true,
        },
      },
    },
  },
}
