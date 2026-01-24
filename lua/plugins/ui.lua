-- UI Components: File Explorer, Statusline, Bufferline, and visual enhancements

-- Shared utility for nvim-tree width persistence
local nvim_tree_width = {
  path = vim.fn.stdpath "data" .. "/nvim_tree_width.json",

  load = function(self)
    local f = io.open(self.path, "r")
    if not f then
      return nil
    end
    local content = f:read "*a"
    f:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and type(data.width) == "number" and data.width >= 20 then
      return data.width
    end
    return nil
  end,

  save = function(self, width)
    if type(width) ~= "number" or width < 20 then
      return
    end
    local f = io.open(self.path, "w")
    if f then
      f:write(vim.json.encode { width = width })
      f:close()
    end
  end,
}

return {
  -- Buffer deletion utility (handles edge cases properly)
  {
    "famiu/bufdelete.nvim",
    lazy = true,
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    opts = function()
      local width = nvim_tree_width:load() or 30
      return {
        filters = { dotfiles = false },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          width = width,
          preserve_window_proportions = true,
        },
        renderer = {
          root_folder_label = false,
          highlight_git = true,
          indent_markers = { enable = true },
          icons = {
            glyphs = {
              default = "󰈚",
              folder = {
                default = "",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      -- Track width changes via nvim-tree's own events
      local api = require "nvim-tree.api"
      api.events.subscribe(api.events.Event.TreeOpen, function()
        -- Defer to ensure window is fully created
        vim.defer_fn(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NvimTree" then
              local current_width = vim.api.nvim_win_get_width(win)
              -- Only save if different from default and reasonable
              if current_width >= 20 then
                nvim_tree_width:save(current_width)
              end
              break
            end
          end
        end, 100)
      end)

      -- Save width on window resize
      vim.api.nvim_create_autocmd("WinResized", {
        group = vim.api.nvim_create_augroup("NvimTreeWidthPersist", { clear = true }),
        callback = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NvimTree" then
              nvim_tree_width:save(vim.api.nvim_win_get_width(win))
              break
            end
          end
        end,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients { bufnr = 0 }
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return " " .. table.concat(names, ", ")
            end,
            cond = function()
              return #vim.lsp.get_clients { bufnr = 0 } > 0
            end,
          },
        },
        lualine_y = { "filetype" },
        lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  -- Bufferline (Tabs)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim",
    },
    version = "*",
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_buttons = true,
        show_close_icon = true,
        max_name_length = 20,
        truncate_names = true,
        -- Use bufdelete for proper buffer closing (handles all edge cases)
        close_command = function(bufnr)
          require("bufdelete").bufdelete(bufnr, true)
        end,
        right_mouse_command = function(bufnr)
          require("bufdelete").bufdelete(bufnr, true)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "",
            highlight = "Directory",
            separator = true,
          },
        },
        diagnostics_indicator = function(count, level)
          local icon = level:match "error" and " " or " "
          return icon .. count
        end,
      },
    },
    keys = {
      {
        "<leader>bd",
        function()
          require("bufdelete").bufdelete(0, true)
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>bD",
        function()
          require("bufdelete").bufwipeout(0, true)
        end,
        desc = "Wipeout buffer",
      },
    },
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Word illumination
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure {
        delay = 120,
        modes_denylist = { "i" },
        large_file_cutoff = 2000,
        large_file_overrides = { providers = { "lsp" } },
      }
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "NvimTree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },
}
