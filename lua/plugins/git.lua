return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
  },
}
