-- Core bootstrap sequence (all execute at require-time)
--
-- 0. loader   — enable bytecode cache BEFORE any module loads
-- 1. options   — vim.opt/vim.g settings (leader, netrw, editor defaults)
-- 2. keymaps   — general keybindings (plugin keymaps live in plugin specs)
-- 3. autocmds  — core event handlers; also calls lifecycle.setup() which
--                registers a VimEnter autocmd for the deterministic startup
--                sequence (colorscheme → session → ui_toggle → nvim_tree →
--                commands → reconcile → cleanup)
-- 4. lazy      — bootstraps lazy.nvim and imports all plugins/* specs
--
-- Timing guarantee: steps 1-3 complete synchronously before any plugin loads.
-- VimEnter fires after init.lua returns and the UI draws the first frame.

-- Enable bytecode cache early so core modules benefit on subsequent startups.
-- lazy.nvim calls this again during setup() (idempotent).
vim.loader.enable()

require "config.options"
require "config.keymaps"
require "config.autocmds"
require "core.lazy"
