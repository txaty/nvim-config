require "nvchad.mappings"

local map = vim.keymap.set
local function telescope(builtin)
  return function()
    require("telescope.builtin")[builtin]()
  end
end

map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select entire buffer" })
map("n", "<C-m>", "<C-i>", { desc = "Forward in jumplist" })
map("n", "<leader>sc", "<cmd>nohlsearch<cr>", { desc = "Search: clear highlights" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Files: save" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit all" })

-- Files
map("n", "<leader>ff", telescope "find_files", { desc = "Files: find" })
map("n", "<leader>fg", telescope "live_grep", { desc = "Files: grep" })
map("n", "<leader>fb", telescope "buffers", { desc = "Files: buffers" })
map("n", "<leader>fr", telescope "oldfiles", { desc = "Files: recent" })
map("n", "<leader>fe", "<cmd>NvimTreeToggle<cr>", { desc = "Files: explorer" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Buffer: next" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Buffer: previous" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Buffer: delete" })

-- Windows
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Window: horizontal split" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Window: vertical split" })
map("n", "<leader>wh", "<C-w>h", { desc = "Window: left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window: down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window: up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window: right" })
map("n", "<leader>wq", "<cmd>close<cr>", { desc = "Window: close" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: references" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: implementation" })
map("n", "<leader>lh", vim.lsp.buf.signature_help, { desc = "LSP: signature help" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: rename" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: code action" })
map("n", "<leader>lf", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "LSP: format" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "LSP: line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: next diagnostic" })

-- Git
map("n", "<leader>gs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Git: stage hunk" })
map("n", "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Git: reset hunk" })
map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Git: preview hunk" })
map("n", "<leader>gb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Git: toggle blame" })

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add {
    { "<leader>b", group = "Buffers" },
    { "<leader>f", group = "Files" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "LSP" },
    { "<leader>m", group = "Bookmarks" },
    { "<leader>p", group = "Python" },
    { "<leader>q", group = "Quit" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Tests" },
    { "<leader>w", group = "Window" },
  }
end
