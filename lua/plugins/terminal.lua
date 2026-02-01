return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<C-\\>", "<cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle terminal" },
      { "<leader>Tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
      { "<leader>Th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
      { "<leader>Tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return 80
        end
      end,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "rounded",
      },
      highlights = {
        FloatBorder = { link = "FloatBorder" },
      },
    },
  },
}
