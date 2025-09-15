return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      -- Adapters
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
    },
    config = function()
      local neotest = require "neotest"
      neotest.setup {
        adapters = {
          require "neotest-python" { dap = { justMyCode = false } },
          require "neotest-go" {},
          require "neotest-rust" {},
        },
        quickfix = { open = false },
        summary = { animated = false },
      }

      -- Minimal helpful keymaps
      local map = vim.keymap.set
      map("n", "<leader>tn", function()
        neotest.run.run()
      end, { desc = "Test: run nearest" })
      map("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand "%")
      end, { desc = "Test: run file" })
      map("n", "<leader>ts", function()
        neotest.run.run { suite = true }
      end, { desc = "Test: run suite" })
      map("n", "<leader>to", function()
        neotest.output.open { enter = true }
      end, { desc = "Test: open output" })
      map("n", "<leader>tt", function()
        neotest.summary.toggle()
      end, { desc = "Test: toggle summary" })
    end,
  },
}

