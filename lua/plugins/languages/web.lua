-- Web development support (JavaScript, TypeScript, HTML, CSS)
local lang_toggle = require "core.lang_toggle"
if not lang_toggle.is_enabled "web" then
  return {}
end

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
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "xml" },
    opts = {},
  },
}
