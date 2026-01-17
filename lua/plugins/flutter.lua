return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Recommended for UI
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup(require "configs.flutter")
    end,
    keys = {
      { "<leader>cF", "<cmd>FlutterRun<cr>", desc = "Flutter: run" },
      { "<leader>cq", "<cmd>FlutterQuit<cr>", desc = "Flutter: quit" },
      { "<leader>cr", "<cmd>FlutterRestart<cr>", desc = "Flutter: hot restart" },
      { "<leader>cR", "<cmd>FlutterReload<cr>", desc = "Flutter: hot reload" },
      { "<leader>cd", "<cmd>FlutterDevices<cr>", desc = "Flutter: devices" },
      { "<leader>ce", "<cmd>FlutterEmulators<cr>", desc = "Flutter: emulators" },
      { "<leader>co", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: outline" },
      { "<leader>cl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter: log" },
    },
  },
}
