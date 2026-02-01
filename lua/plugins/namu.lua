return {
  {
    "bassamsdata/namu.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>ss", "<cmd>Namu symbols<CR>", desc = "Jump to symbol" },
      { "<leader>sS", "<cmd>Namu workspace<CR>", desc = "Jump to workspace symbol" },
    },
    opts = {
      namu_symbols = {
        options = {
          movement = {
            next = { "<C-j>", "<Down>" },
            previous = { "<C-k>", "<Up>" },
          },
        },
      },
    },
  },
}
