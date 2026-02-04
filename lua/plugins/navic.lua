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
    -- Load on same events as lspconfig; navic's LspAttach handler must be
    -- registered BEFORE lspconfig attaches clients. This is achieved by adding
    -- navic as a dependency OF lspconfig (see plugins/lsp.lua), ensuring navic's
    -- setup() runs first.
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
