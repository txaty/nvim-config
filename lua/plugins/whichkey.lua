return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 200,
      icons = {
        breadcrumb = ">",
        separator = "->",
        group = "+",
      },
      win = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)

      -- Register key groups
      wk.add {
        { "<leader>a", group = "AI & Copilot" },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Color/Theme" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Files & Find" },
        { "<leader>F", group = "Flutter" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP & Language" },
        { "<leader>m", group = "Bookmarks & Markdown" },
        { "<leader>M", group = "Minimap" },
        { "<leader>n", group = "Notifications" },
        { "<leader>p", group = "Python" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>s", group = "Search" },
        { "<leader>S", group = "Spectre" },
        { "<leader>t", group = "Testing" },
        { "<leader>w", group = "Windows" },
        { "<leader>x", group = "Diagnostics" },
      }
    end,
  },
}
