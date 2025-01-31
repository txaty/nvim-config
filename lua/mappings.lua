require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Select all
map("n", "<C-a>", "gg<S-v>G")

local opts = { noremap = true, silent = true }

-- Jumplist
map("n", "<C-m>", "<C-i>", opts)

-- New tab
-- map("n", "te", "tabedit", opts)
-- map("n", "<tab>", ":tabnext<Return>", opts)
-- map("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
-- map("n", "ss", ":split<Return>", opts)
-- map("n", "sv", ":vplist<Return>", opts)

-- Move window
-- map("n", "sh", "<C-w>h")
-- map("n", "sk", "<C-w>k")
-- map("n", "sj", "<C-w>j")
-- map("n", "sl", "<C-w>l")

-- Resize window
-- map("n", "<C-w><left>", "<C-w><")
-- map("n", "<C-w><right>", "<C-w>>")
-- map("n", "<C-w><up>", "<C-w>+")
-- map("n", "<C-w><down>", "<C-w>-")
