# Neovim Configuration Refactoring Plan

This document outlines the complete refactoring plan for the Neovim configuration,
addressing the issues identified in the Phase 1 architecture audit.

## Executive Summary

The refactoring focuses on:
1. **Fixing critical bugs** (LspAttach augroup, colorscheme ordering, race conditions)
2. **Decomposing monolithic files** (autocmds.lua → lifecycle modules)
3. **Adding conflict detection** (keymaps, augroups)
4. **Establishing clear initialization order** (deterministic boot sequence)

## Phase 2: Target Architecture

### Directory Structure

```
lua/
├── core/
│   ├── init.lua                    # Boot orchestrator (simplified)
│   ├── options.lua                 # vim.opt, vim.g settings [UNCHANGED]
│   ├── keymaps.lua                 # General keymaps [UNCHANGED]
│   ├── lazy.lua                    # Plugin manager bootstrap [UNCHANGED]
│   │
│   ├── autocmds.lua                # REFACTORED: Core autocmds only
│   │
│   ├── lifecycle/                  # NEW: Initialization lifecycle
│   │   ├── init.lua                # VimEnter orchestrator
│   │   ├── colorscheme.lua         # Theme restoration (priority)
│   │   ├── session.lua             # Session save/restore
│   │   ├── ui_state.lua            # UI toggle application
│   │   └── nvim_tree.lua           # NvimTree auto-open logic
│   │
│   ├── commands/                   # NEW: User command definitions
│   │   ├── init.lua                # Command registry & loader
│   │   ├── theme.lua               # :ThemeSwitch, :ThemeDark, etc
│   │   ├── ai.lua                  # :AIToggle, :AIEnable, etc
│   │   ├── lang.lua                # :LangToggle, :LangPanel, etc
│   │   ├── cleanup.lua             # :CleanupNvim
│   │   └── ui.lua                  # :UIStatus
│   │
│   ├── util/                       # NEW: Shared utilities
│   │   ├── init.lua                # Utility module index
│   │   ├── augroup.lua             # Augroup helper with registry
│   │   ├── keymap.lua              # Keymap helper with conflict detection
│   │   └── safe_require.lua        # pcall wrapper with error handling
│   │
│   ├── buffers.lua                 # Buffer management [UNCHANGED]
│   ├── theme.lua                   # Theme registry [MINOR CHANGES]
│   ├── theme_txaty.lua             # Custom theme [UNCHANGED]
│   ├── ui_toggle.lua               # UI toggle state [FIX: remove require-time I/O]
│   ├── ai_toggle.lua               # AI toggle [UNCHANGED]
│   ├── lang_toggle.lua             # Language toggle [UNCHANGED]
│   ├── lang_utils.lua              # Language utilities [UNCHANGED]
│   └── cleanup.lua                 # Cleanup module [UNCHANGED]
│
└── plugins/                        # Plugin specs [MINOR FIXES]
    ├── lsp.lua                     # FIX: LspAttach augroup clear
    ├── ui.lua                      # FIX: Simplify nvim-tree integration
    └── [other plugin files]        # UNCHANGED
```

### Boot Sequence (Deterministic Order)

```
STAGE 1: Synchronous Core Setup (before any plugin)
├── core/options.lua          # vim.opt, vim.g.mapleader
├── core/keymaps.lua          # General keybindings
└── core/autocmds.lua         # Minimal core autocmds

STAGE 2: Plugin Manager Bootstrap
└── core/lazy.lua             # lazy.nvim setup, triggers plugin loading

STAGE 3: VimEnter Lifecycle (single handler, deterministic order)
├── 1. colorscheme.restore()  # Theme FIRST (before UI plugins render)
├── 2. session.restore()      # Session restore (if applicable)
├── 3. ui_state.apply_all()   # UI toggles to all windows
├── 4. nvim_tree.auto_open()  # File explorer (session-aware)
└── 5. commands.register()    # User commands (after plugins ready)

STAGE 4: Plugin-Triggered Initialization
├── BufReadPre/BufNewFile     # LSP, Treesitter, Gitsigns, Lint
├── InsertEnter               # Completion, Copilot
├── VeryLazy                  # Lualine, Bufferline, Which-key, Noice
└── Filetype triggers         # Language-specific plugins
```

### Module Specifications

#### 1. `core/init.lua` (Simplified Orchestrator)

```lua
-- Minimal boot sequence - no business logic here
require "core.options"
require "core.keymaps"
require "core.autocmds"
require "core.lazy"
-- lifecycle handled by VimEnter autocmd in core/lifecycle/init.lua
```

#### 2. `core/autocmds.lua` (Minimal Core Autocmds)

**Responsibilities:**
- Cursor position restoration (BufReadPost)
- View/fold save/load (BufWinLeave/BufWinEnter)
- Prose settings for markdown/tex (FileType)
- Python folding override (FileType)
- VimLeavePre session save hook
- ColorScheme theme auto-save hook

**NOT included (moved to lifecycle/):**
- VimEnter handlers (session restore, theme restore, nvim-tree)
- User command definitions (moved to commands/)
- UI toggle initialization

#### 3. `core/lifecycle/init.lua` (VimEnter Orchestrator)

```lua
-- Single point of control for post-startup initialization
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("NvimLifecycle", { clear = true }),
    once = true,
    nested = true,
    callback = function()
      -- Deterministic order, no nested schedules
      M.run_sequence()
    end,
  })
end

function M.run_sequence()
  -- Step 1: Colorscheme (sync, before any UI)
  require("core.lifecycle.colorscheme").restore()

  -- Step 2: Session (may change buffers/windows)
  local session_restored = require("core.lifecycle.session").restore()

  -- Step 3: UI state (apply to all windows)
  require("core.lifecycle.ui_state").apply_all()

  -- Step 4: NvimTree (session-aware)
  require("core.lifecycle.nvim_tree").auto_open(session_restored)

  -- Step 5: Commands (after plugins ready)
  require("core.commands").register_all()

  -- Step 6: Cleanup (throttled, background)
  vim.schedule(function()
    local ok, cleanup = pcall(require, "core.cleanup")
    if ok then pcall(cleanup.auto_cleanup) end
  end)
end

return M
```

#### 4. `core/lifecycle/colorscheme.lua`

```lua
local M = {}

function M.restore()
  local ok, theme = pcall(require, "core.theme")
  if not ok then
    pcall(vim.cmd.colorscheme, "catppuccin")
    return
  end

  local saved = theme.load_saved_theme()
  if saved then
    local success = pcall(theme.restore_theme)
    if not success then
      pcall(theme.apply_theme, "catppuccin")
    end
  else
    pcall(theme.apply_theme, "catppuccin")
  end
end

return M
```

#### 5. `core/lifecycle/session.lua`

```lua
local M = {}

function M.should_restore()
  local argc = vim.fn.argc()
  if argc == 0 then return true end
  if argc == 1 then
    local arg = vim.fn.argv(0)
    return arg == "" or arg == "." or vim.fn.isdirectory(arg) == 1
  end
  return false
end

function M.restore()
  if not M.should_restore() then
    return false
  end

  local ok, persistence = pcall(require, "persistence")
  if not ok then return false end

  local session_file = persistence.current()
  if vim.fn.filereadable(session_file) ~= 1 then
    return false
  end

  local success = pcall(persistence.load)
  return success
end

function M.save()
  local ok, persistence = pcall(require, "persistence")
  if ok then pcall(persistence.save) end
end

return M
```

#### 6. `core/lifecycle/nvim_tree.lua`

```lua
local M = {}

-- Clean stale NvimTree buffers from session restore
local function cleanup_stale_buffers()
  local cleaned = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("NvimTree_") then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
        cleaned = true
      end
    end
  end
  return cleaned
end

local function open_tree(opts)
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then pcall(api.tree.open, opts) end
end

function M.auto_open(session_restored)
  local file = vim.fn.expand("%")
  local is_dir = vim.fn.isdirectory(file) == 1
  local is_file = vim.fn.filereadable(file) == 1

  -- Always cleanup stale buffers first
  local cleaned = cleanup_stale_buffers()

  -- Defer tree open if we cleaned buffers
  local do_open = function(opts)
    if cleaned then
      vim.schedule(function() open_tree(opts) end)
    else
      open_tree(opts)
    end
  end

  if is_dir then
    vim.cmd.cd(file)
    do_open()
  elseif is_file then
    do_open({ focus = false, find_file = true })
  elseif file == "" and vim.bo.buftype == "" and not session_restored then
    do_open()
  end
end

return M
```

#### 7. `core/util/augroup.lua`

```lua
local M = {}

-- Registry of all augroups for conflict detection
M.registry = {}

function M.create(name, opts)
  opts = opts or {}
  opts.clear = opts.clear ~= false  -- Default to clear = true

  -- Check for duplicate registration (warn in development)
  if M.registry[name] and not opts.clear then
    vim.notify(
      string.format("Augroup '%s' already registered", name),
      vim.log.levels.WARN
    )
  end

  M.registry[name] = {
    created_at = vim.uv.now(),
    source = debug.getinfo(2, "S").source,
  }

  return vim.api.nvim_create_augroup(name, opts)
end

function M.list()
  return vim.tbl_keys(M.registry)
end

return M
```

#### 8. `core/util/keymap.lua`

```lua
local M = {}

-- Registry for conflict detection
M.registry = {}

local function make_key(mode, lhs)
  return mode .. ":" .. lhs
end

function M.set(mode, lhs, rhs, opts)
  opts = opts or {}
  local key = make_key(mode, lhs)

  -- Check for conflicts (only warn, don't prevent)
  if M.registry[key] and not opts.override then
    local existing = M.registry[key]
    vim.schedule(function()
      vim.notify(
        string.format(
          "Keymap conflict: '%s' (%s) already set by %s",
          lhs, mode, existing.source or "unknown"
        ),
        vim.log.levels.DEBUG
      )
    end)
  end

  M.registry[key] = {
    source = opts.source or debug.getinfo(2, "S").source,
    desc = opts.desc,
  }

  -- Remove our custom options before passing to vim
  opts.override = nil
  opts.source = nil

  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.check_conflicts()
  -- Return list of potential conflicts
  local conflicts = {}
  -- Implementation: group by lhs, report multiple registrations
  return conflicts
end

return M
```

#### 9. `core/commands/init.lua`

```lua
local M = {}

local modules = {
  "core.commands.theme",
  "core.commands.ai",
  "core.commands.lang",
  "core.commands.cleanup",
  "core.commands.ui",
}

function M.register_all()
  for _, mod in ipairs(modules) do
    local ok, m = pcall(require, mod)
    if ok and m.register then
      m.register()
    end
  end
end

return M
```

### Critical Bug Fixes

#### Fix 1: LspAttach Augroup (lsp.lua:48)

**Before:**
```lua
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),  -- Missing clear!
  callback = function(ev) ... end,
})
```

**After:**
```lua
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev) ... end,
})
```

#### Fix 2: ui_toggle.lua Require-Time I/O (line 57)

**Before:**
```lua
-- At module level (runs on require)
load_config_once()
```

**After:**
```lua
-- Remove module-level call
-- Ensure init() is called explicitly during lifecycle
```

#### Fix 3: Colorscheme Ordering

**Before:**
- Theme restoration happens via scheduled VimEnter autocmd
- VeryLazy plugins (lualine, bufferline) may load first

**After:**
- Theme restoration is first action in lifecycle sequence
- Runs synchronously before session restore

### Implementation Order

The refactoring will be implemented in this order (each step is atomic):

1. **Create utility modules** (`core/util/`)
   - `augroup.lua`, `keymap.lua`, `safe_require.lua`
   - No changes to existing behavior

2. **Fix LspAttach augroup** (one-line change)
   - Add `{ clear = true }` to lsp.lua

3. **Fix ui_toggle require-time I/O**
   - Remove line 57, ensure init() called in lifecycle

4. **Create lifecycle modules** (`core/lifecycle/`)
   - Extract from autocmds.lua
   - No behavior change yet

5. **Create command modules** (`core/commands/`)
   - Extract from autocmds.lua
   - No behavior change yet

6. **Refactor core/autocmds.lua**
   - Remove extracted code
   - Wire up lifecycle/init.lua
   - Single VimEnter handler

7. **Simplify nvim-tree integration**
   - Use new lifecycle/nvim_tree.lua
   - Remove nested vim.schedule()

8. **Add conflict detection** (optional enhancement)
   - Integrate util/keymap.lua into keymaps.lua
   - Add startup conflict report

### Verification Checklist

After refactoring, verify:

- [ ] `nvim --headless "+checkhealth" +q` passes
- [ ] Open Lua file → LSP attaches → completion works
- [ ] Open Rust file → rust-analyzer attaches → completion works
- [ ] Open Python file → pyright attaches → completion works
- [ ] Format on save works (single format, not double)
- [ ] Telescope works (`<leader>ff`)
- [ ] Git signs show without errors
- [ ] Session save/restore works
- [ ] Theme persists across restarts
- [ ] NvimTree opens correctly on startup
- [ ] `:LspRestart` doesn't accumulate handlers
- [ ] No startup errors or warnings

### Behavior Changes

**Intentional changes:**
1. Commands now register after VimEnter (was immediate in autocmds.lua)
   - Impact: Commands available ~10ms later, negligible
2. Theme applies synchronously before session restore
   - Impact: More consistent UI appearance on startup
3. NvimTree cleanup uses single vim.schedule() instead of nested
   - Impact: More predictable timing

**No changes to:**
- All keybindings remain identical
- Plugin lazy-loading behavior unchanged
- Format-on-save behavior unchanged
- Session file locations unchanged
- Theme persistence format unchanged

---

## Appendix: File-by-File Changes

| File | Change Type | Description |
|------|-------------|-------------|
| `core/init.lua` | Minor | Same requires, add lifecycle setup |
| `core/autocmds.lua` | Major | Remove 400+ lines, keep core autocmds only |
| `core/ui_toggle.lua` | Minor | Remove line 57 (require-time load) |
| `plugins/lsp.lua` | Trivial | Add `clear = true` to augroup |
| `plugins/ui.lua` | Minor | Simplify nvim-tree VimEnter (use lifecycle) |
| `core/lifecycle/*` | New | 5 new files (~200 lines total) |
| `core/commands/*` | New | 6 new files (~350 lines, extracted from autocmds) |
| `core/util/*` | New | 3 new files (~100 lines) |

**Net change:** ~650 new lines in modular structure, ~400 lines removed from autocmds.lua
