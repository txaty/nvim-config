return {
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>lo", "<cmd>Outline<CR>", desc = "Toggle code outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 25,
      },
      symbols = {
        icon_source = "lspkind",
      },
    },
  },
}
