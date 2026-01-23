return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
      local actions = require "telescope.actions"
      return {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules", ".git/", "%.lock" },
          path_display = { "truncate" },
          winblend = 0,
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            follow = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
              n = { ["d"] = actions.delete_buffer },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
