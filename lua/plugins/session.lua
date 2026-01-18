return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
    config = function(_, opts)
      local persistence = require "persistence"
      persistence.setup(opts)

      -- Auto-save session when exiting Neovim
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("PersistenceAutoSave", { clear = true }),
        callback = function()
          persistence.save()
        end,
      })

      -- Auto-restore session when opening Neovim without arguments
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("PersistenceAutoRestore", { clear = true }),
        nested = true,
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc() == 0 then
            persistence.load()
          end
        end,
      })
    end,
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
