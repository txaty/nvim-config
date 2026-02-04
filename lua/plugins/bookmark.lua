return {
  {
    "tomasky/bookmarks.nvim",
    -- Defer loading to first keymap use (bookmarks are user-triggered, not needed at buffer open)
    -- Saves ~1.1ms on first buffer open (avoids 6 nested module requires)
    keys = {
      { "<leader>ma", desc = "Bookmark: Toggle" },
      { "<leader>mn", desc = "Bookmark: Next" },
      { "<leader>mp", desc = "Bookmark: Previous" },
      { "<leader>md", desc = "Bookmark: Clean buffer" },
      { "<leader>mC", desc = "Bookmark: Clear all" },
      { "<leader>ml", desc = "Bookmark: List" },
      { "<leader>mi", desc = "Bookmark: Annotate" },
    },
    config = function()
      local bookmarks = require "bookmarks"
      bookmarks.setup {
        save_file = vim.fn.stdpath "data" .. "/bookmarks",
        keywords = {
          ["@t"] = "[TODO]",
          ["@w"] = "[WARN]",
          ["@f"] = "[FIX]",
          ["@n"] = "[NOTE]",
        },
        on_attach = function(bufnr)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("<leader>ma", bookmarks.bookmark_toggle, "Bookmark: Toggle")
          map("<leader>mn", bookmarks.bookmark_next, "Bookmark: Next")
          map("<leader>mp", bookmarks.bookmark_prev, "Bookmark: Previous")
          map("<leader>md", bookmarks.bookmark_clean, "Bookmark: Clean buffer")
          map("<leader>mC", bookmarks.bookmark_clear_all, "Bookmark: Clear all")
          map("<leader>ml", bookmarks.bookmark_list, "Bookmark: List")
          map("<leader>mi", bookmarks.bookmark_ann, "Bookmark: Annotate")
        end,
      }
    end,
  },
  -- Telescope extension for bookmarks
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      opts.extensions_list = opts.extensions_list or {}
      table.insert(opts.extensions_list, "bookmarks")
    end,
  },
}
