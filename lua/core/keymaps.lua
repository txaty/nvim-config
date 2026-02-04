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
-- Note: ui_toggle is loaded on-demand to avoid startup cost
map("n", "<leader>uw", function()
  require("core.ui_toggle").toggle "wrap"
end, { desc = "UI: Toggle line wrap" })
map("n", "<leader>us", function()
  require("core.ui_toggle").toggle "spell"
end, { desc = "UI: Toggle spell check" })
map("n", "<leader>un", function()
  require("core.ui_toggle").toggle "number"
end, { desc = "UI: Toggle line numbers" })
map("n", "<leader>ur", function()
  require("core.ui_toggle").toggle "relativenumber"
end, { desc = "UI: Toggle relative numbers" })
map("n", "<leader>uc", function()
  require("core.ui_toggle").toggle "conceallevel"
end, { desc = "UI: Toggle conceal" })
map("n", "<leader>ug", function()
  require("core.ui_toggle").toggle "tree_git"
end, { desc = "UI: Toggle nvim-tree git status" })

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

-- Copy file path to clipboard
map("n", "<leader>fy", function()
  local path = vim.fn.expand "%:p"
  if path ~= "" then
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path, vim.log.levels.INFO)
  else
    vim.notify("No file in current buffer", vim.log.levels.WARN)
  end
end, { desc = "Files: yank absolute path" })

map("n", "<leader>fY", function()
  local path = vim.fn.expand "%:."
  if path ~= "" then
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path, vim.log.levels.INFO)
  else
    vim.notify("No file in current buffer", vim.log.levels.WARN)
  end
end, { desc = "Files: yank relative path" })

map("n", "<leader>fN", function()
  local name = vim.fn.expand "%:t"
  if name ~= "" then
    vim.fn.setreg("+", name)
    vim.notify("Copied: " .. name, vim.log.levels.INFO)
  else
    vim.notify("No file in current buffer", vim.log.levels.WARN)
  end
end, { desc = "Files: yank filename" })

-- Window Split and Layout
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Window: horizontal split" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Window: vertical split" })
map("n", "<leader>w=", "<C-w>=", { desc = "Window: equalize sizes" })
map("n", "<leader>wo", "<cmd>only<cr>", { desc = "Window: close others" })
map("n", "<leader>wz", function()
  if vim.t.zoomed then
    vim.cmd.wincmd "="
    vim.t.zoomed = false
  else
    vim.cmd.wincmd "_"
    vim.cmd.wincmd "|"
    vim.t.zoomed = true
  end
end, { desc = "Window: toggle zoom" })

-- Buffer navigation
map("n", "<TAB>", "<cmd>bnext<CR>", { desc = "Buffer Next" })
map("n", "<S-TAB>", "<cmd>bprev<CR>", { desc = "Buffer Prev" })
-- <leader>bd is defined in lua/plugins/ui.lua (centralized buffer close)

-- AI Feature Toggle (Lua function avoids race with VimEnter command registration)
map("n", "<leader>ai", function()
  local ok, ai = pcall(require, "core.ai_toggle")
  if ok then
    ai.toggle()
  else
    vim.notify("Failed to load ai_toggle module", vim.log.levels.ERROR)
  end
end, { desc = "AI: Toggle AI features" })

-- Language Support Panel (uses capital L to avoid conflict with <leader>l* LSP keymaps)
-- Lua functions avoid race with VimEnter command registration
map("n", "<leader>Lp", function()
  local ok = pcall(vim.cmd, "LangPanel")
  if not ok then
    vim.notify("LangPanel not yet available, try again shortly", vim.log.levels.WARN)
  end
end, { desc = "Language: toggle panel" })
map("n", "<leader>Ls", function()
  local ok, lang = pcall(require, "core.lang_toggle")
  if ok then
    lang.show_all_status()
  else
    vim.notify("Failed to load lang_toggle module", vim.log.levels.ERROR)
  end
end, { desc = "Language: show status" })
