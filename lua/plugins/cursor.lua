-- smear-cursor.nvim: Animated cursor movement

return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>uC",
        function()
          local smear = require "smear_cursor"
          smear.toggle()
        end,
        desc = "UI: Toggle cursor animation",
      },
    },
    opts = {
      stiffness = 0.9,
      trailing_stiffness = 0.7,
      trailing_exponent = 0.3,
      distance_stop_animating = 0.3,
      hide_target_hack = false,
    },
  },
}
