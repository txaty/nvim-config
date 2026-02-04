-- Filter state for live_grep (persists during session)
local grep_filters = {
  include = nil, -- glob pattern: "*.py", "src/**/*.ts"
  exclude = nil, -- glob pattern: "node_modules", "*.test.js"
  type = nil, -- ripgrep type: "py", "js", "go", "rust", etc.
}

-- File type presets for quick selection
local file_types = {
  { label = "All files", type = nil },
  { label = "Python (.py)", type = "py" },
  { label = "JavaScript (.js)", type = "js" },
  { label = "TypeScript (.ts)", type = "ts" },
  { label = "Rust (.rs)", type = "rust" },
  { label = "Go (.go)", type = "go" },
  { label = "Lua (.lua)", type = "lua" },
  { label = "C/C++ (.c/.cpp/.h)", type = "cpp" },
  { label = "Markdown (.md)", type = "md" },
  { label = "JSON (.json)", type = "json" },
  { label = "YAML (.yaml/.yml)", type = "yaml" },
  { label = "HTML (.html)", type = "html" },
  { label = "CSS (.css)", type = "css" },
}

-- Build ripgrep args from filter state
local function build_grep_args()
  local args = { "--hidden" }
  if grep_filters.include then
    vim.list_extend(args, { "--glob", grep_filters.include })
  end
  if grep_filters.exclude then
    vim.list_extend(args, { "--glob", "!" .. grep_filters.exclude })
  end
  if grep_filters.type then
    vim.list_extend(args, { "--type", grep_filters.type })
  end
  return args
end

-- Reset all filters
local function reset_filters()
  grep_filters.include = nil
  grep_filters.exclude = nil
  grep_filters.type = nil
end

-- Get dynamic title showing active filters
local function get_grep_title()
  local parts = {}
  if grep_filters.include then
    table.insert(parts, "+" .. grep_filters.include)
  end
  if grep_filters.exclude then
    table.insert(parts, "-" .. grep_filters.exclude)
  end
  if grep_filters.type then
    table.insert(parts, "type:" .. grep_filters.type)
  end
  if #parts == 0 then
    return "Live Grep"
  end
  return "Live Grep [" .. table.concat(parts, " ") .. "]"
end

-- Launch live_grep with current filters
local function filtered_live_grep()
  require("telescope.builtin").live_grep {
    prompt_title = get_grep_title(),
    additional_args = build_grep_args,
  }
end

-- Prompt for include/exclude patterns then search
local function live_grep_with_prompts()
  vim.ui.input({ prompt = "Include (glob, e.g. *.lua, src/**/*): " }, function(inc)
    grep_filters.include = (inc and inc ~= "") and inc or nil
    vim.ui.input({ prompt = "Exclude (glob, e.g. node_modules, *.test.js): " }, function(exc)
      grep_filters.exclude = (exc and exc ~= "") and exc or nil
      filtered_live_grep()
    end)
  end)
end

-- Select file type from presets then search
local function live_grep_by_type()
  vim.ui.select(file_types, {
    prompt = "File type:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      grep_filters.type = choice.type
      filtered_live_grep()
    end
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", filtered_live_grep, desc = "Live grep" },
      { "<leader>fG", live_grep_with_prompts, desc = "Live grep (with filters)" },
      { "<leader>fT", live_grep_by_type, desc = "Live grep (by type)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
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

      -- In-picker action: set include filter
      local function set_include_filter(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.ui.input({ prompt = "Include (glob): " }, function(input)
          grep_filters.include = (input and input ~= "") and input or nil
          filtered_live_grep()
        end)
      end

      -- In-picker action: set exclude filter
      local function set_exclude_filter(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.ui.input({ prompt = "Exclude (glob): " }, function(input)
          grep_filters.exclude = (input and input ~= "") and input or nil
          filtered_live_grep()
        end)
      end

      -- In-picker action: select file type
      local function select_file_type(prompt_bufnr)
        actions.close(prompt_bufnr)
        live_grep_by_type()
      end

      -- In-picker action: reset all filters
      local function reset_all_filters(prompt_bufnr)
        reset_filters()
        actions.close(prompt_bufnr)
        filtered_live_grep()
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
            additional_args = build_grep_args,
            mappings = {
              i = {
                ["<C-f>"] = set_include_filter,
                ["<C-e>"] = set_exclude_filter,
                ["<C-t>"] = select_file_type,
                ["<C-r>"] = reset_all_filters,
              },
              n = {
                ["<C-f>"] = set_include_filter,
                ["<C-e>"] = set_exclude_filter,
                ["<C-t>"] = select_file_type,
                ["<C-r>"] = reset_all_filters,
              },
            },
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
