-- refactoring.nvim: Extract function/variable, inline variable
-- IntelliJ-style refactoring operations

return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>le",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = "x",
        desc = "LSP: Extract function",
      },
      {
        "<leader>lE",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = "x",
        desc = "LSP: Extract variable",
      },
      {
        "<leader>li",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "x" },
        desc = "LSP: Inline variable",
      },
      {
        "<leader>lR",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "LSP: Refactoring menu",
      },
    },
    opts = {},
  },
}
