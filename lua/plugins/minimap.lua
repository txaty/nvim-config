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
      { "<leader>mm", "<cmd>Neominimap toggle<cr>", desc = "Minimap: toggle" },
      { "<leader>mo", "<cmd>Neominimap on<cr>", desc = "Minimap: on" },
      { "<leader>mc", "<cmd>Neominimap off<cr>", desc = "Minimap: off" },
      { "<leader>mr", "<cmd>Neominimap refresh<cr>", desc = "Minimap: refresh" },
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
