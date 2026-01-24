-- Python language support
local lang_toggle = require "core.lang_toggle"
if not lang_toggle.is_enabled "python" then
  return {}
end

local lang = require "core.lang_utils"

return {
  lang.extend_treesitter { "python", "toml" },
  lang.extend_mason { "pyright", "ruff", "mypy", "black", "isort", "debugpy" },
  lang.extend_conform { python = { "black", "isort" } },
  lang.extend_lspconfig {
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "strict",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            typeHints = true,
            autoImportCompletions = true,
          },
        },
      },
    },
    ruff = {},
  },

  -- DAP Python integration
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("dap.python").setup()
    end,
  },

  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    ft = "python", -- Lazy load on python filetype
    cmd = "VenvSelect",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python: select virtualenv" },
    },
    opts = {
      name = "venv",
      stay_on_window = true,
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)
    end,
  },
}
