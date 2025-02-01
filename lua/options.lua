require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99 -- Ensure folds are open by default

o.viewoptions = "folds,options,cursor" -- Enable saving and restoring folds

-- Remember fold states
-- vim.fn.expand("%") ensures that the buffer has a filename
-- vim.bo.buftype == "" excludes special bufffers like Telescope, NvimTree, terminal, and quickfix
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.cmd "mkview"
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.cmd "silent! loadview"
    end
  end,
})

-- Open nvim-tree automatically when starting nvim in a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- Buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
      return
    end

    -- Change to the directory
    vim.cmd.cd(data.file)

    -- Open nvim-tree
    require("nvim-tree.api").tree.open()
  end,
})
