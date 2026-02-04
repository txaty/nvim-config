-- nvim-navic: Breadcrumb navigation (shows function/class hierarchy)
-- Integrates with lualine to display current code location

return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
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
