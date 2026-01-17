return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = require "configs.copilot",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
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
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
      { "<leader>cq", "<cmd>CopilotChatQuick<cr>", desc = "Copilot Chat Quick" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Explain Code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Copilot Generate Tests" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Copilot Fix Code" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Copilot Review Code" },
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
