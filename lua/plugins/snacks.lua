-- Snacks.nvim: Unified UI/UX plugin collection from folke
-- Replaces: nvim-notify, indent-blankline, vim-illuminate, zen-mode, twilight

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- NEW FEATURES
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
            { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              action = function()
                require("persistence").load()
              end,
            },
            { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
            { icon = " ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = "󰿅 ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 150 },
          easing = "linear",
        },
      },
      gitbrowse = { enabled = true },

      -- REPLACEMENTS (with performance tuning)
      -- notifier disabled: noice.nvim handles notifications more comprehensively
      -- Avoids potential double-processing of messages
      notifier = { enabled = false },
      indent = {
        enabled = true,
        animate = { enabled = false }, -- Disable animations for performance
        char = "│",
        filter = function(buf)
          -- Match indent-blankline exclusions
          local exclude_ft = {
            "help",
            "dashboard",
            "neo-tree",
            "NvimTree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "snacks_dashboard",
          }
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains(exclude_ft, vim.bo[buf].filetype)
        end,
      },
      words = {
        enabled = true,
        debounce = 200, -- Match vim-illuminate delay
        -- Uses native LSP document highlights (efficient for large files)
      },
      dim = { enabled = true },
      zen = {
        enabled = true,
        toggles = {
          dim = true, -- Enable dim when entering zen
          git_signs = false,
          diagnostics = false,
        },
        win = { width = 120 }, -- Match zen-mode.nvim setting
      },
      toggle = { enabled = true },

      -- KEEP DISABLED (using other plugins)
      picker = { enabled = false }, -- Keep telescope
      explorer = { enabled = false }, -- Keep nvim-tree
      terminal = { enabled = false }, -- Keep toggleterm
      lazygit = { enabled = false }, -- Keep lazygit.nvim
      input = { enabled = false }, -- Keep dressing.nvim
      statuscolumn = { enabled = false },
      quickfile = { enabled = false },
      bigfile = { enabled = false },
    },
    keys = {
      -- Dashboard (H = Home)
      {
        "<leader>H",
        function()
          Snacks.dashboard()
        end,
        desc = "Dashboard (Home)",
      },
      -- Git browse (o = open in browser)
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git: Open in browser",
        mode = { "n", "v" },
      },
      -- Zen mode
      {
        "<leader>uz",
        function()
          Snacks.zen()
        end,
        desc = "UI: Toggle zen mode",
      },
      -- Dim (like twilight)
      {
        "<leader>ud",
        function()
          Snacks.dim()
        end,
        desc = "UI: Toggle dim",
      },
      -- Words navigation (reference jumping)
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev reference",
        mode = { "n", "t" },
      },
      -- Notifications handled by noice.nvim (<leader>nh, <leader>nd)
    },
    init = function()
      -- Global kill switch for all snacks animations if issues arise
      -- vim.g.snacks_animate = false

      -- Set up vim.notify replacement after snacks loads
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Override vim.notify with snacks.notifier
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd
        end,
      })
    end,
  },
}
