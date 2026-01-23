return {
  -- Distant.nvim - Remote development like VS Code Remote
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    cmd = {
      "Distant",
      "DistantInstall",
      "DistantLaunch",
      "DistantConnect",
      "DistantOpen",
      "DistantShell",
      "DistantSystemInfo",
      "DistantClientVersion",
    },
    keys = {
      {
        "<leader>rc",
        function()
          vim.ui.input({ prompt = "Remote connection (e.g., ssh://user@host): " }, function(input)
            if input and input ~= "" then
              vim.cmd("DistantLaunch " .. input)
            end
          end)
        end,
        desc = "Remote: connect to server",
      },
      {
        "<leader>rd",
        function()
          local ok, distant = pcall(require, "distant")
          if ok then
            distant.close()
          else
            vim.notify("Not connected to any remote server", vim.log.levels.WARN)
          end
        end,
        desc = "Remote: disconnect",
      },
      {
        "<leader>ro",
        function()
          vim.ui.input({ prompt = "Remote path to open: " }, function(input)
            if input and input ~= "" then
              vim.cmd("DistantOpen " .. input)
            end
          end)
        end,
        desc = "Remote: open directory/file",
      },
      { "<leader>rs", "<cmd>DistantSystemInfo<cr>", desc = "Remote: system info" },
      { "<leader>rS", "<cmd>DistantShell<cr>", desc = "Remote: open shell" },
    },
    config = function()
      -- Basic setup for distant.nvim v0.3
      require("distant"):setup()

      -- Setup keymaps for file navigation (using standard Telescope after opening remote)
      vim.keymap.set("n", "<leader>rf", function()
        local ok, _ = pcall(require, "distant")
        if not ok then
          vim.notify("Not connected to a remote server. Use <leader>rc to connect.", vim.log.levels.WARN)
          return
        end
        -- Use standard telescope find_files when in a remote buffer
        require("telescope.builtin").find_files()
      end, { desc = "Remote: find files" })

      vim.keymap.set("n", "<leader>rg", function()
        local ok, _ = pcall(require, "distant")
        if not ok then
          vim.notify("Not connected to a remote server. Use <leader>rc to connect.", vim.log.levels.WARN)
          return
        end
        -- Use standard telescope live_grep when in a remote buffer
        require("telescope.builtin").live_grep()
      end, { desc = "Remote: live grep" })

      -- Auto-attach LSP when opening remote files
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("DistantLspAttach", { clear = true }),
        pattern = "distant://*",
        callback = function()
          -- LSP should attach automatically to remote buffers
          -- distant.nvim handles the file system operations transparently
          vim.schedule(function()
            vim.cmd "LspStart"
          end)
        end,
      })

      -- Show notification when connected/disconnected
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("DistantNotifications", { clear = true }),
        pattern = "DistantConnected",
        callback = function()
          vim.notify("Connected to remote server", vim.log.levels.INFO)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("DistantDisconnected", { clear = true }),
        pattern = "DistantDisconnected",
        callback = function()
          vim.notify("Disconnected from remote server", vim.log.levels.INFO)
        end,
      })
    end,
  },

  -- Extend lualine to show remote connection status
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- Add remote connection indicator to lualine
      local function distant_status()
        local ok, distant = pcall(require, "distant")
        if not ok then
          return ""
        end

        local client = distant.client()
        if client then
          -- Get connection info if available
          local info = client:system_info()
          if info then
            return " 󰢹 " .. (info.host or "remote")
          end
          return " 󰢹 remote"
        end
        return ""
      end

      -- Ensure sections table exists
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}

      -- Insert into lualine_c section (filename area)
      table.insert(opts.sections.lualine_c, { distant_status })

      return opts
    end,
  },

  -- Extend which-key to show remote commands group
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        mode = { "n", "v" },
        { "<leader>r", group = "remote", icon = "󰢹" },
      })
    end,
  },
}
