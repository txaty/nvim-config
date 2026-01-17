return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = require "configs.todo",
    keys = {
      {
        "<leader>xt",
        "<cmd>Trouble todo toggle<cr>",
        desc = "Todo (Trouble)",
      },
      {
        "<leader>ft",
        "<cmd>TodoTelescope<cr>",
        desc = "Todo (Telescope)",
      },
    },
  },
}
