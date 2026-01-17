return {
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = require "configs.spectre",
    keys = {
      {
        "<leader>S",
        function()
          require("spectre").toggle()
        end,
        desc = "Spectre: toggle search & replace",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual { select_word = true }
        end,
        desc = "Spectre: search current word",
      },
    },
  },
}
