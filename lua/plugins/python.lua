return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", -- debugging for Python
      { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    config = function()
      require("venv-selector").setup {}
      -- DAP Python uses the current Python on PATH; integrates well with venv-selector
      pcall(function()
        require("dap-python").setup "python"
      end)
    end,
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
  },
}
