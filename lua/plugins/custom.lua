return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.extensions_list = opts.extensions_list or {}
      table.insert(opts.extensions_list, "bookmarks")
    end,
  },
}
