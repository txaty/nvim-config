return {
  {
    "jake-stewart/multicursor.nvim",
    keys = {
      {
        "<C-Up>",
        function()
          require("multicursor-nvim").lineAddCursor(-1)
        end,
        desc = "Multi-Cursor: add above",
      },
      {
        "<C-Down>",
        function()
          require("multicursor-nvim").lineAddCursor(1)
        end,
        desc = "Multi-Cursor: add below",
      },
      {
        "gb",
        function()
          require("multicursor-nvim").matchAddCursor(1)
        end,
        desc = "Multi-Cursor: add next match",
      },
      {
        "gB",
        function()
          require("multicursor-nvim").matchAddCursor(-1)
        end,
        desc = "Multi-Cursor: add prev match",
      },
      {
        "<leader>va",
        function()
          require("multicursor-nvim").matchAllAddCursors()
        end,
        desc = "Multi-Cursor: add all matches",
      },
      {
        "<Esc>",
        function()
          local mc = require "multicursor-nvim"
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          else
            vim.cmd "noh"
          end
        end,
        desc = "Multi-Cursor: clear or noh",
      },
    },
    config = function()
      require("multicursor-nvim").setup()
    end,
  },
}
