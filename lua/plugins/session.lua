return {
  {
    "folke/persistence.nvim",
    lazy = true, -- Loaded on demand by autocmds
    opts = {
      -- Session options: includes globals for UI toggle state persistence
      -- Theme persistence is handled separately by theme.lua
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "skiprtp", "globals" },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
    end,
    -- Note: Session auto-save and auto-restore are handled in core/autocmds.lua
    -- This ensures autocmds are registered before VimEnter fires
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}
