return {
  ---@module "neominimap.config.meta"
  {
    "Isrothy/neominimap.nvim",
    version = "v3.*.*",
    enabled = true,
    lazy = true,
    cmd = "Neominimap",
    -- Optional
    keys = {
      -- Global Minimap Controls
      { "<leader>MM", "<cmd>Neominimap toggle<cr>", desc = "Minimap: Toggle" },
      { "<leader>Mo", "<cmd>Neominimap on<cr>", desc = "Minimap: Enable" },
      { "<leader>Mc", "<cmd>Neominimap off<cr>", desc = "Minimap: Disable" },
      { "<leader>Mr", "<cmd>Neominimap refresh<cr>", desc = "Minimap: Refresh" },
    },
    init = function()
      -- The following options are recommended when layout == "float"
      -- vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      --- Put your configuration here
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = false,
      }
    end,
  },
}
