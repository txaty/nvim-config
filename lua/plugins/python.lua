return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    config = function()
      require("venv-selector").setup {}
    end,
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
  },
}
