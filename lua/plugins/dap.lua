return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("configs.dap").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "codelldb", "python", "js-debug-adapter", "delve" },
      automatic_installation = true,
    },
  },
}

