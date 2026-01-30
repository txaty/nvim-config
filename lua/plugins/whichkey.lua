return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 200,
      icons = {
        breadcrumb = "»",
        separator = "→",
        group = "+",
        mappings = true,
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      layout = {
        spacing = 3,
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)

      -- Register key groups with icons for visual consistency
      wk.add {
        { "<leader>a", group = "AI", icon = "󰚩" },
        { "<leader>b", group = "Buffers", icon = "󰈔" },
        { "<leader>c", group = "Colors", icon = "󰏘" },
        { "<leader>C", group = "Crates", icon = "󰏗" },
        { "<leader>d", group = "Debug", icon = "󰃤" },
        { "<leader>f", group = "Find", icon = "󰍉" },
        { "<leader>F", group = "Flutter", icon = "󰙅" },
        { "<leader>g", group = "Git", icon = "󰊢" },
        { "<leader>l", group = "LSP", icon = "󰒋" },
        { "<leader>L", group = "Language", icon = "󰗊" },
        { "<leader>m", group = "Marks", icon = "󰃀" },
        { "<leader>M", group = "Minimap", icon = "󰍍" },
        { "<leader>n", group = "Notify", icon = "󰂞" },
        { "<leader>p", group = "Python", icon = "󰌠" },
        { "<leader>q", group = "Session", icon = "󰁯" },
        { "<leader>r", group = "Remote", icon = "󰢹" },
        { "<leader>R", group = "Rust", icon = "󱘗" },
        { "<leader>s", group = "Search", icon = "󰑑" },
        { "<leader>S", group = "Search", icon = "󰛔" },
        { "<leader>t", group = "Test", icon = "󰙨" },
        { "<leader>u", group = "UI/Display", icon = "󰙵" },
        { "<leader>w", group = "Windows", icon = "󰖲" },
        { "<leader>x", group = "Diagnostics", icon = "󰒡" },
      }
    end,
  },
}
