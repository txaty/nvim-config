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
        -- override markdown rendering so that **cmp** and other plugins use Treesitter
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      presets = {
        bottom_search = true, 
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false, 
        lsp_doc_border = true,
      },
      popupmenu = {
        enabled = false,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      {
        "<leader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Noice: last message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice: history",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Noice: dismiss all",
      },
    },
  },
  -- Better Select/Input UIs
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = true },
      select = { enabled = true },
    },
  },
}
