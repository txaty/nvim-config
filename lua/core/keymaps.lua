local map = vim.keymap.set

-- General Mappings
map("i", "<C-b>", "<ESC>^i", { desc = "Move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move end of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<C-h>", "<C-w>h", { desc = "Switch Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch Window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "General Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General Copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>nr", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- User Mappings from mappings.lua
map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select entire buffer" })
map("n", "<C-m>", "<C-i>", { desc = "Forward in jumplist" })
map("n", "<leader>sc", "<cmd>nohlsearch<cr>", { desc = "Search: clear highlights" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Files: save" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit all" })

-- Files & Finding (Telescope)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Files: find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Files: live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Files: find buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Files: recent files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Files: help tags" })

-- File Explorer (NvimTree)
-- Intentional aliases: both keys toggle nvim-tree for different workflows
-- <leader>fe follows Files group convention, <C-n> is quick toggle
map("n", "<leader>fe", "<cmd>NvimTreeToggle<cr>", { desc = "Files: toggle explorer" })
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Files: toggle explorer" })

-- Window Split
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Window: horizontal split" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Window: vertical split" })

-- Buffer navigation
map("n", "<TAB>", "<cmd>bnext<CR>", { desc = "Buffer Next" })
map("n", "<S-TAB>", "<cmd>bprev<CR>", { desc = "Buffer Prev" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Buffer Close" })

-- AI Feature Toggle
map("n", "<leader>ai", "<cmd>AIToggle<cr>", { desc = "AI: Toggle AI features" })
