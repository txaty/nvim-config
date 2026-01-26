return {
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: run nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test: run file",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run { suite = true }
        end,
        desc = "Test: run suite",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open { enter = true }
        end,
        desc = "Test: open output",
      },
      {
        "<leader>tt",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: toggle summary",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      {
        "nvim-neotest/neotest-python",
        cond = function()
          return require("core.lang_toggle").is_enabled "python"
        end,
      },
      {
        "nvim-neotest/neotest-go",
        cond = function()
          return require("core.lang_toggle").is_enabled "go"
        end,
      },
      {
        "rouge8/neotest-rust",
        cond = function()
          return require("core.lang_toggle").is_enabled "rust"
        end,
      },
    },
    config = function()
      local adapters = {}

      local python_ok, neotest_python = pcall(require, "neotest-python")
      if python_ok then
        table.insert(adapters, neotest_python { dap = { justMyCode = false } })
      end

      local go_ok, neotest_go = pcall(require, "neotest-go")
      if go_ok then
        table.insert(adapters, neotest_go {})
      end

      local rust_ok, neotest_rust = pcall(require, "neotest-rust")
      if rust_ok then
        table.insert(adapters, neotest_rust {})
      end

      require("neotest").setup {
        adapters = adapters,
        quickfix = { open = false },
        summary = { animated = false },
      }
    end,
  },
}
