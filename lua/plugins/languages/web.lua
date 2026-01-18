-- Web development support (JavaScript, TypeScript, HTML, CSS)
local lang = require "core.lang_utils"

return {
  lang.extend_treesitter { "javascript", "typescript", "tsx", "html", "css", "json" },
  lang.extend_mason { "typescript-language-server", "css-lsp", "html-lsp", "json-lsp", "prettier", "eslint_d" },
  lang.extend_conform {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
  },
  lang.extend_lspconfig {
    ts_ls = {},
    html = {},
    cssls = {},
    jsonls = {},
  },
}
