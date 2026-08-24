return {
  {
    "bassamsdata/namu.nvim",
    -- keys only, deliberately no `event`: this is an on-demand symbol picker.
    -- It previously also declared BufReadPost/BufNewFile, which loaded it into
    -- every buffer at open time and made the `keys` entries redundant.
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
