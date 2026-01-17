return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "copilot-chat" },
    opts = require "configs.markdown",
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}
