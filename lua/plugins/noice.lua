return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- cmp.entry.get_documentation removed (nvim-cmp specific; blink.cmp handles natively)
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = false,
            throttle = 50,
          },
        },
        hover = { enabled = true },
        progress = { enabled = true },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      popupmenu = { enabled = false },
      views = {
        mini = {
          win_options = { winblend = 0 },
          position = { row = -2 },
        },
      },
      routes = {
        -- Hide "written" messages
        { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        -- Hide search count messages
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
        -- Hide "No information available" from LSP hover
        { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
        -- Hide macro recording messages (shown in statusline)
        { filter = { event = "msg_showmode" }, opts = { skip = true } },
        -- Route long messages to split
        { filter = { event = "msg_show", min_height = 10 }, view = "split" },
      },
    },
    keys = {
      {
        "<leader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Last message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Message history",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss all",
      },
      {
        "<leader>na",
        function()
          require("noice").cmd "all"
        end,
        desc = "All messages",
      },
    },
  },

  -- Notification backend with minimal styling
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "compact",
      stages = "fade",
      top_down = false,
    },
  },

  -- Better select/input UIs
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "> ",
        win_options = { winblend = 0 },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = { win_options = { winblend = 0 } },
      },
    },
  },
}
