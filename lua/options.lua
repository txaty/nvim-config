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

-- For Python files, avoid automatic folding so content doesn't collapse on save
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.foldenable = false
    -- If any plugin resets foldenable, also ensure manual method as a guard
    vim.opt_local.foldmethod = "manual"
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

    -- Create a new empty buffer first, then close the directory buffer
    -- This ensures we always have a valid window
    local dir_buf = vim.api.nvim_get_current_buf()
    vim.cmd "enew"
    if vim.api.nvim_buf_is_valid(dir_buf) then
      pcall(vim.api.nvim_buf_delete, dir_buf, { force = true })
    end

    -- Schedule nvim-tree opening after everything is initialized
    vim.schedule(function()
      require("nvim-tree.api").tree.open()
    end)
  end,
})
