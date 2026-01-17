local options = {
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
}

return options
