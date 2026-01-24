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

-- UI/Display toggles (session-persistent via vim.g.ui_*)
local ui = require "core.ui_toggle"
map("n", "<leader>uw", function()
  ui.toggle "wrap"
end, { desc = "UI: Toggle line wrap" })
map("n", "<leader>us", function()
  ui.toggle "spell"
end, { desc = "UI: Toggle spell check" })
map("n", "<leader>un", function()
  ui.toggle "number"
end, { desc = "UI: Toggle line numbers" })
map("n", "<leader>ur", function()
  ui.toggle "relativenumber"
end, { desc = "UI: Toggle relative numbers" })
map("n", "<leader>uc", function()
  ui.toggle "conceallevel"
end, { desc = "UI: Toggle conceal" })

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
-- Core telescope keymaps defined in lua/plugins/telescope.lua for lazy-loading

-- File Explorer (NvimTree)
-- <leader>fe follows Files group convention
-- <C-n> is defined in lua/plugins/ui.lua for lazy-loading
map("n", "<leader>fe", "<cmd>NvimTreeToggle<cr>", { desc = "Files: toggle explorer" })

-- Window Split
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Window: horizontal split" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Window: vertical split" })

-- Buffer navigation
map("n", "<TAB>", "<cmd>bnext<CR>", { desc = "Buffer Next" })
map("n", "<S-TAB>", "<cmd>bprev<CR>", { desc = "Buffer Prev" })
-- <leader>bd is defined in lua/plugins/ui.lua (bufdelete plugin handles edge cases)

-- AI Feature Toggle
map("n", "<leader>ai", "<cmd>AIToggle<cr>", { desc = "AI: Toggle AI features" })

-- Language Support Panel (uses capital L to avoid conflict with <leader>l* LSP keymaps)
map("n", "<leader>Lp", "<cmd>LangPanel<cr>", { desc = "Language: toggle panel" })
map("n", "<leader>Ls", "<cmd>LangStatus<cr>", { desc = "Language: show status" })
