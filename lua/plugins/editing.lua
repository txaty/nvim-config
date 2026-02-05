return {
  {
    "kylechui/nvim-surround",
    version = "^3",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Smart increment/decrement: works on dates, booleans, semver, hex colors, not just numbers
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        desc = "Decrement",
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        desc = "Increment (sequential)",
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        desc = "Decrement (sequential)",
      },
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "visual")
        end,
        mode = "v",
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "visual")
        end,
        mode = "v",
        desc = "Decrement",
      },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y/%m/%d"],
          augend.semver.alias.semver,
          augend.constant.new { elements = { "true", "false" } },
          augend.constant.new { elements = { "True", "False" } },
          augend.constant.new { elements = { "yes", "no" } },
          augend.constant.new { elements = { "on", "off" } },
          augend.constant.new { elements = { "&&", "||" }, word = false },
        },
      }
    end,
  },

  -- Yank ring: access previous yanks with <C-p>/<C-n> after paste
  {
    "gbprod/yanky.nvim",
    keys = {
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank" },
      { "<C-n>", "<Plug>(YankyNextEntry)", desc = "Next yank" },
    },
    opts = {
      ring = { history_length = 50 },
      highlight = { timer = 200 },
    },
  },
}
