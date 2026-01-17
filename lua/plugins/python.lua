return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    cmd = "VenvSelect",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python: select virtualenv" },
    },
    opts = {
      name = "venv",
      stay_on_window = true,
    },
    config = function(_, opts)
      local selector = require "venv-selector"
      selector.setup(opts)

      local mason_debugpy = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      local python = vim.loop.fs_stat(mason_debugpy) and mason_debugpy or "python3"

      pcall(function()
        require("dap-python").setup(python)
      end)
    end,
  },
}
