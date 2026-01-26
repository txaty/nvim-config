-- UI Components: File Explorer, Statusline, Bufferline, and visual enhancements

-- Shared utility for nvim-tree width persistence (with in-memory caching)
local nvim_tree_width = {
  path = vim.fn.stdpath "data" .. "/nvim_tree_width.json",
  cached_width = nil, -- In-memory cache to reduce disk I/O
  dirty = false, -- Track if cache differs from disk

  load = function(self)
    -- Return cached value if available
    if self.cached_width then
      return self.cached_width
    end

    local f = io.open(self.path, "r")
    if not f then
      return nil
    end
    local content = f:read "*a"
    f:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and type(data.width) == "number" and data.width >= 20 then
      self.cached_width = data.width
      return data.width
    end
    return nil
  end,

  save = function(self, width)
    if type(width) ~= "number" or width < 20 then
      return
    end
    -- Update cache, mark dirty (persist later)
    if self.cached_width ~= width then
      self.cached_width = width
      self.dirty = true
    end
  end,

  -- Persist to disk (called on tree close or VimLeave)
  persist = function(self)
    if not self.dirty or not self.cached_width then
      return
    end
    local f = io.open(self.path, "w")
    if f then
      f:write(vim.json.encode { width = self.cached_width })
      f:close()
      self.dirty = false
    end
  end,
}

return {
  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    opts = function()
      local width = nvim_tree_width:load() or 30
      -- Load git status preference from ui_toggle
      local ui_toggle = require "core.ui_toggle"
      local show_git = ui_toggle.get "tree_git"
      if show_git == nil then
        show_git = true -- Default to showing git status
      end

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
        git = {
          enable = show_git,
          show_on_dirs = show_git,
          show_on_open_dirs = show_git,
        },
        renderer = {
          root_folder_label = false,
          highlight_git = show_git,
          indent_markers = { enable = true },
          icons = {
            show = {
              git = show_git,
            },
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
                untracked = "",
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
      local api = require "nvim-tree.api"
      local resize_guard = false

      -- Helper to find nvim-tree window
      local function get_nvim_tree_win()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "NvimTree" then
            return win
          end
        end
        return nil
      end

      -- 1. Restore width and set winfixwidth on tree open
      api.events.subscribe(api.events.Event.TreeOpen, function()
        vim.defer_fn(function()
          local win = get_nvim_tree_win()
          if win then
            -- Restore saved width
            local saved = nvim_tree_width:load()
            if saved and saved >= 20 then
              resize_guard = true
              pcall(api.tree.resize, { absolute = saved })
              vim.schedule(function()
                resize_guard = false
              end)
            end
            -- Prevent layout changes from resizing this window
            vim.wo[win].winfixwidth = true
          end
        end, 10)
      end)

      -- 2. Save width on nvim-tree's own resize event (API calls)
      api.events.subscribe(api.events.Event.Resize, function(size)
        if size and size >= 20 then
          nvim_tree_width:save(size) -- Updates cache, doesn't write to disk
          -- Re-apply winfixwidth after resize
          local win = get_nvim_tree_win()
          if win then
            vim.wo[win].winfixwidth = true
          end
        end
      end)

      -- 2b. Persist width to disk on tree close (reduces I/O during resizes)
      api.events.subscribe(api.events.Event.TreeClose, function()
        nvim_tree_width:persist()
      end)

      -- 2c. Persist on vim exit as well
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("NvimTreeWidthSave", { clear = true }),
        callback = function()
          nvim_tree_width:persist()
        end,
      })

      -- 3. Save width on manual resize (mouse drag, <C-w>< etc.)
      vim.api.nvim_create_autocmd("WinResized", {
        group = vim.api.nvim_create_augroup("NvimTreeWidthPersist", { clear = true }),
        callback = function()
          if resize_guard then
            return
          end
          local win = get_nvim_tree_win()
          if not win then
            return
          end
          -- Check if nvim-tree was in the resized windows list
          local resized = vim.v.event and vim.v.event.windows or {}
          for _, resized_win in ipairs(resized) do
            if resized_win == win then
              local width = vim.api.nvim_win_get_width(win)
              if width >= 20 then
                nvim_tree_width:save(width)
                resize_guard = true
                pcall(api.tree.resize, { absolute = width })
                vim.schedule(function()
                  resize_guard = false
                end)
                -- Re-apply winfixwidth after manual resize
                vim.wo[win].winfixwidth = true
              end
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
            -- LSP client names - cached per statusline refresh to avoid duplicate API calls
            function()
              local clients = vim.lsp.get_clients { bufnr = 0 }
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                names[#names + 1] = client.name
              end
              return " " .. table.concat(names, ", ")
            end,
            -- Condition uses the same logic inline to avoid separate API call
            -- The component returns empty string when no clients, which hides it
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
        -- Use centralized buffer closing to avoid re-entrancy issues
        close_command = function(bufnr)
          require("core.buffers").close(bufnr, { force = true })
        end,
        right_mouse_command = function(bufnr)
          require("core.buffers").close(bufnr, { force = true })
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
          require("core.buffers").close(0, { force = true })
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>bD",
        function()
          require("core.buffers").close(0, { force = true, wipe = true })
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
        delay = 200, -- Increased from 120ms for better performance
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
