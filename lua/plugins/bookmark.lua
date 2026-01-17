return {
  {
    "tomasky/bookmarks.nvim",
    event = "VeryLazy",
    config = function()
      local bookmarks = require "bookmarks"
      bookmarks.setup {
        save_file = vim.fn.expand "$HOME/.bookmarks",
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

          map("<leader>ma", bookmarks.bookmark_toggle, "Bookmark: toggle")
          map("<leader>mn", bookmarks.bookmark_next, "Bookmark: next")
          map("<leader>mp", bookmarks.bookmark_prev, "Bookmark: previous")
          map("<leader>md", bookmarks.bookmark_clean, "Bookmark: clean buffer")
          map("<leader>mC", bookmarks.bookmark_clear_all, "Bookmark: clear all")
          map("<leader>ml", bookmarks.bookmark_list, "Bookmark: list")
          map("<leader>mi", bookmarks.bookmark_ann, "Bookmark: annotate")
        end,
      }
    end,
  },
}
