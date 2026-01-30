return {
  {
    "zbirenbaum/copilot.lua",
    cond = function()
      return require("core.ai_toggle").is_enabled()
    end,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function(_, opts)
      require("copilot").setup(opts)

      -- Dismiss Copilot ghost text when blink.cmp menu is visible
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if ok then
            suggestion.dismiss()
          end
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>", -- Alt + L to accept (avoids conflict with cursor nav)
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = function()
      return require("core.ai_toggle").is_enabled()
    end,
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatDebugInfo",
      "CopilotChatModels",
      "CopilotChatAgents",
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "AI: Toggle chat" },
      { "<leader>aq", "<cmd>CopilotChatQuick<cr>", desc = "AI: Quick chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "AI: Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "AI: Generate tests" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "AI: Fix code" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "AI: Review code" },
    },
    opts = {
      debug = false, -- Enable debug logging
      proxy = nil, -- [protocol://]host[:port] Use this proxy
      allow_insecure = false, -- Allow insecure server connections
      -- default window options
      window = {
        layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.5, -- fractional width of parent, or absolute width in columns
        height = 0.5, -- fractional height of parent, or absolute height in rows
        -- Options below only apply to floating windows
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = "Copilot Chat", -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
    },
  },
}
