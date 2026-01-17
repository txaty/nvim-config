local autocmd = vim.api.nvim_create_autocmd

-- Restore cursor position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- User's View Saving Logic
autocmd({ "BufWinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.cmd "mkview"
    end
  end,
})

autocmd({ "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.cmd "silent! loadview"
    end
  end,
})

-- Python specific folding config
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.foldmethod = "manual"
  end,
})

-- Open nvim-tree on startup
autocmd("VimEnter", {
  callback = function(data)
    -- real file?
    local real_file = vim.fn.filereadable(data.file) == 1
    -- directory?
    local directory = vim.fn.isdirectory(data.file) == 1

    -- if no file is provided, open the tree
    -- if a directory is provided, open the tree and change directory
    if directory then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
      return
    end

    -- if a real file is provided, open the tree but verify the file is focused
    if real_file then
      require("nvim-tree.api").tree.open { focus = false, find_file = true }
      return
    end

    -- Fallback: open tree if no args provided (dashboard replacement)
    -- Session restore is available via <leader>ql
    if data.file == "" and vim.bo.buftype == "" then
      require("nvim-tree.api").tree.open()
    end
  end,
})
