return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>S",
        function()
          require("grug-far").open()
        end,
        desc = "Search & Replace (grug-far)",
      },
      {
        "<leader>sw",
        function()
          require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } }
        end,
        desc = "Search current word",
      },
      {
        "<leader>S",
        function()
          require("grug-far").with_visual_selection()
        end,
        mode = "v",
        desc = "Search selection",
      },
    },
    opts = {
      headerMaxWidth = 80,
    },
  },
}
