require("nvim-tree").setup {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = { enable = true, update_root = true },
  view = { width = 30, side = "left" },
}
