-- Telescope: Fallback for plugin integrations that require it
-- Primary search is now handled by Snacks picker (see snacks.lua)

return {
  {
    "nvim-telescope/telescope.nvim",
    -- Demoted to cmd-only: Snacks picker is now primary
    -- Telescope is kept available for plugin integrations (e.g., todo-comments)
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"

      local function delete_buffer(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if not selection or not selection.bufnr then
          return
        end
        require("core.buffers").close(selection.bufnr, { force = true })
        picker:refresh(picker.finder, { reset_prompt = false })
      end

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
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
            "%.lock",
            "__pycache__/",
            "%.pyc",
            ".venv/",
            "venv/",
            "dist/",
            "build/",
            "target/",
            "%.min%.js",
            "%.min%.css",
            "%.o",
            "%.a",
            "%.so",
          },
          path_display = { "truncate" },
          winblend = 0,
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          -- Skip preview for large files
          buffer_previewer_maker = function(filepath, bufnr, opts)
            local stat = vim.uv.fs_stat(filepath)
            if stat and stat.size > 500000 then
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "File too large for preview" })
              return
            end
            require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
          end,
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
              i = { ["<C-d>"] = delete_buffer },
              n = { ["d"] = delete_buffer },
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
