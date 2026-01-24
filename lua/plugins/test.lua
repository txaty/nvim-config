-- Cache lang_toggle at file top
local ok_toggle, lang_toggle = pcall(require, "core.lang_toggle")

-- Build dependencies list based on lang_toggle settings
local deps = {
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-neotest/nvim-nio",
}

-- Conditionally add adapters based on lang_toggle settings
if ok_toggle then
  if lang_toggle.is_enabled "python" then
    table.insert(deps, "nvim-neotest/neotest-python")
  end
  if lang_toggle.is_enabled "go" then
    table.insert(deps, "nvim-neotest/neotest-go")
  end
  if lang_toggle.is_enabled "rust" then
    table.insert(deps, "rouge8/neotest-rust")
  end
else
  -- Fallback: load all adapters if lang_toggle unavailable
  table.insert(deps, "nvim-neotest/neotest-python")
  table.insert(deps, "nvim-neotest/neotest-go")
  table.insert(deps, "rouge8/neotest-rust")
end

return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = deps,
    config = function()
      local neotest = require "neotest"
      local adapters = {}

      -- Conditionally configure adapters based on lang_toggle settings
      if ok_toggle then
        if lang_toggle.is_enabled "python" then
          local python_ok, neotest_python = pcall(require, "neotest-python")
          if python_ok then
            table.insert(adapters, neotest_python { dap = { justMyCode = false } })
          end
        end
        if lang_toggle.is_enabled "go" then
          local go_ok, neotest_go = pcall(require, "neotest-go")
          if go_ok then
            table.insert(adapters, neotest_go {})
          end
        end
        if lang_toggle.is_enabled "rust" then
          local rust_ok, neotest_rust = pcall(require, "neotest-rust")
          if rust_ok then
            table.insert(adapters, neotest_rust {})
          end
        end
      else
        -- Fallback: load all adapters if lang_toggle unavailable
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
      end

      neotest.setup {
        adapters = adapters,
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
