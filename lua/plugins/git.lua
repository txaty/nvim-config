return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Git: Next hunk")
        map("n", "[h", gs.prev_hunk, "Git: Previous hunk")

        -- Actions
        map("n", "<leader>gs", gs.stage_hunk, "Git: Stage hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Git: Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Git: Reset hunk")
        map("v", "<leader>gr", function()
          gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, "Git: Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Git: Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Git: Reset buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Git: Undo stage hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Git: Preview hunk")
        map("n", "<leader>gb", function()
          gs.blame_line { full = true }
        end, "Git: Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Git: Toggle blame")
        map("n", "<leader>gd", gs.diffthis, "Git: Diff this")
        map("n", "<leader>gD", function()
          gs.diffthis "~"
        end, "Git: Diff against HEAD")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git: Select hunk")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
  },
}
