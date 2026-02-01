-- Core bootstrap sequence (all execute at require-time)
--
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
require "core.options"
require "core.keymaps"
require "core.autocmds"
require "core.lazy"
