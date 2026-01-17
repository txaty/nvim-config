return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "copilot-chat" },
    opts = {
      heading = {
        enabled = true,
        sign = true,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        signs = { "󰫎 " },
        width = "full",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        deterministic = true,
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
        language_pad = 0,
        disable_background = { "diff" },
        width = "full",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
      },
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        left_pad = 0,
        right_pad = 0,
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰄵 " },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },
      pipe_table = {
        enabled = true,
        preset = "round",
        style = "full",
        cell = "padded",
        padding = 1,
        min_width = 0,
        border = {
          "┌", "┬", "┐",
          "├", "┼", "┤",
          "└", "┴", "┘",
          "│", "─",
        },
      },
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌵 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}
