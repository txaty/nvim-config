local opt = vim.opt
local g = vim.g

--------------------------------------
-- Globals
--------------------------------------
g.mapleader = " "
g.maplocalleader = " "

-- Disable netrw for nvim-tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

--------------------------------------
-- Options
--------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.cursorlineopt = "number"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- Disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Folding (foldmethod/foldexpr set by treesitter after it loads)
opt.foldlevel = 99
opt.foldmethod = "manual"

--------------------------------------
-- UI Polish
--------------------------------------
opt.cmdheight = 0 -- Hide cmdline when not in use (works with noice.nvim)
opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor
opt.pumheight = 10 -- Limit popup menu height
opt.confirm = true -- Confirm before closing unsaved buffers
opt.wrap = false -- Disable line wrap by default
opt.linebreak = true -- Wrap at word boundaries when wrap is enabled
opt.list = true -- Show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Subtle indicators
