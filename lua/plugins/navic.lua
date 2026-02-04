-- nvim-navic: Breadcrumb navigation (shows function/class hierarchy)
-- Integrates with lualine to display current code location
--
-- LOAD ORDER: Must load BEFORE lspconfig attaches clients.
-- navic.opts.lsp.auto_attach registers an LspAttach autocmd.
-- If navic loads after LSP attaches (e.g., on VeryLazy via lualine),
-- the first buffer misses the attach and has no breadcrumbs.

return {
  {
    "SmiteshP/nvim-navic",
    -- Load on same events as lspconfig to ensure navic's LspAttach handler
    -- is registered before any LSP client attaches
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      highlight = true,
      lsp = { auto_attach = true },
      separator = " > ",
      depth_limit = 5,
      icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      },
    },
  },
}
