-- Create autocmd for markdown file opener at top level
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.keymap.set("n", "<leader>mo", function()
      local filepath = vim.fn.expand "%:p"
      local cmd
      if vim.fn.has "mac" == 1 then
        -- macOS: try Typora specifically, fallback to default app
        if vim.fn.executable "typora" == 1 then
          cmd = string.format("typora '%s' &", filepath)
        else
          cmd = string.format("open -a Typora '%s' 2>/dev/null || open '%s'", filepath, filepath)
        end
      elseif vim.fn.has "unix" == 1 then
        -- Linux
        if vim.fn.executable "typora" == 1 then
          cmd = string.format("typora '%s' &", filepath)
        else
          cmd = string.format("xdg-open '%s' &", filepath)
        end
      elseif vim.fn.has "win32" == 1 then
        -- Windows
        cmd = string.format('start "" "%s"', filepath)
      end

      if cmd then
        vim.fn.system(cmd)
        vim.notify("Opened " .. vim.fn.expand "%:t" .. " in external reader", vim.log.levels.INFO)
      else
        vim.notify("Could not determine command to open file", vim.log.levels.ERROR)
      end
    end, { buffer = args.buf, desc = "Markdown: Open in external reader" })
  end,
  group = vim.api.nvim_create_augroup("MarkdownExternalOpener", { clear = true }),
})

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
          "┌",
          "┬",
          "┐",
          "├",
          "┼",
          "┤",
          "└",
          "┴",
          "┘",
          "│",
          "─",
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
