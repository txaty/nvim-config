return {
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      name = "venv",
      auto_refresh = true
    },
    -- event = "VeryLazy",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>"},
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  }
}
