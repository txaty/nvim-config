return {
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure {
        delay = 120,
        modes_denylist = { "i" },
      }
    end,
  },
}
