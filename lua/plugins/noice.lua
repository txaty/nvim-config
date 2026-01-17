return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = require "configs.noice",
    keys = {
      {
        "<leader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Noice: last message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice: history",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Noice: dismiss all",
      },
    },
  },
  -- Better Select/Input UIs
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = true },
      select = { enabled = true },
    },
  },
}
