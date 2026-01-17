return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      focus = true,
      modes = {
        diagnostics = {
          mode = "diagnostics",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
        symbols = {
          mode = "symbols",
          focus = false,
          win = { position = "right", size = 0.3 },
        },
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xq",
        "<cmd>Trouble quickfix toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
