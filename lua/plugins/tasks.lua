-- overseer.nvim: Task runner (VS Code tasks.json equivalent)
-- Supports make/npm/cargo/go templates out of box

return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild" },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Tasks: Run" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Tasks: Toggle panel" },
      { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Tasks: Restart last" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Tasks: Action" },
    },
    opts = {
      strategy = "terminal",
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 10,
        max_height = 25,
      },
    },
  },
}
