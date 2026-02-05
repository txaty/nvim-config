# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a custom, self-maintained Neovim configuration that has completely migrated away from NvChad. The architecture prioritizes modularity, lazy-loading, and explicit configuration over abstraction.

**Performance:** Heavily optimized for sub-30ms startup time (~25ms typical, ~40ms cold cache). Achieved through aggressive lazy-loading, deferred initialization, and minimal require-time work.

## Quick Reference

### Essential Commands
```bash
nvim                                              # Start Neovim
nvim --headless "+lua require('lazy').sync()" +qa # Sync plugins
nvim --headless '+TSUpdateSync' +qa               # Update Treesitter
nvim --headless '+checkhealth' +qa                # Health check
stylua lua/                                       # Format Lua
luacheck lua/                                     # Lint Lua
```

### Inside Neovim
```vim
:Lazy sync          " Sync plugins
:Mason              " Manage LSP/DAP/formatter/linter tools
:LspInfo            " Check LSP server status
:checkhealth        " Comprehensive diagnostics
:ConformInfo        " Check formatter configuration
:Lazy profile       " Profile plugin load times

" AI/Language/UI Control (requires restart to apply)
:AIToggle           " Toggle AI features on/off
:AIEnable/AIDisable " Explicit control
:LangPanel          " Open language support panel (Telescope)
:LangToggle <lang>  " Toggle language support
:UIStatus           " Show UI toggle states
:CleanupNvim        " Clean up temporary and cache files
:LoadOrder          " Show plugin load order (debug mode only)
```

### Debug Mode
```bash
nvim --cmd "let g:debug_lifecycle=1" --cmd "let g:debug_plugin_load=1"  # Load order logging
nvim --cmd "let g:debug_keymaps=1"                                       # Keymap conflict detection
```

## Critical Architectural Principles

### 1. No NvChad Dependencies
- **NEVER** reference or use NvChad plugins (base46, ui, nvchad.core)
- All functionality is explicitly implemented in `lua/core/` and `lua/plugins/`
- Do not create any NvChad-specific files (chadrc.lua, custom/, lua/configs/)

### 2. Configuration Inlining
- **NEVER** create a `lua/configs/` directory
- All plugin configuration must be inlined in plugin specs using `config` or `opts` functions
- Each plugin file in `lua/plugins/` should be self-contained with its config, keymaps, and dependencies

### 3. Lazy-Loading by Default
- All plugins have `defaults = { lazy = true }` in lazy.nvim setup
- New plugins must specify load triggers: `event`, `cmd`, `ft`, or `keys`
- Exception: colorscheme plugins load immediately with `lazy = false` and `priority = 1000`

### 4. Performance Optimizations (2026-02)
Recent optimizations reduced startup time by 40.6% (42.6ms → 25.3ms):
- **OPT-1**: Guarded `keymap_audit` require (saves ~0.3ms when debug disabled)
- **OPT-2**: Deferred UI state autocmd to VeryLazy (saves ~1-2ms)
- **OPT-3**: Conditional cleanup module load with throttle check (saves ~1-2ms on 90% of startups)
- **OPT-4**: Fold-aware view saving (saves ~1-3ms per buffer switch)

Re-profile with `:Lazy profile` if startup time exceeds 30ms.

## Core Architecture

### Bootstrap Sequence
```
init.lua → core/init.lua → loads in order:
  ├─ core/options.lua    (vim.opt settings)
  ├─ core/keymaps.lua    (general keybindings)
  ├─ core/autocmds.lua   (event handlers + lifecycle setup)
  │   └─ core/lifecycle/init.lua (VimEnter orchestrator)
  └─ core/lazy.lua       (plugin manager bootstrap)
      └─ plugins/*       (lazy-loaded plugin specs)

Plugin Load Layers (deterministic):
  A. require-time:  options, keymaps, autocmds, lazy bootstrap
  B. lazy setup:    snacks.nvim (priority=1000, lazy=false)
  C. VimEnter:      colorscheme → session → ui_toggle → nvim_tree → commands
  D. BufReadPre:    navic, lspconfig, gitsigns (LSP foundation)
  E. BufReadPost:   treesitter, treesitter-context
  F. VeryLazy:      lualine, bufferline, noice, which-key
  G. InsertEnter:   blink.cmp, copilot, mini.pairs

VimEnter Lifecycle (deterministic order):
  1. colorscheme.lua  (theme restore FIRST)
  2. session.lua      (session restore)
  3. ui_toggle.init() (initialize globals only)
  4. retrigger_buffer_events() (ASYNC - triggers BufReadPre/Post/FileType)
     └─ on_complete: ui_toggle.apply_all() + nvim_tree.lua
  5. commands/init.lua (register user commands)
  6. reconcile.lua    (focus fix, waits for VeryLazy)
  7. cleanup.lua      (deferred 2s, low priority)
```

### Directory Structure
- `lua/core/` — Fundamental Neovim settings and bootstrap
  - `lifecycle/` — VimEnter orchestration (colorscheme, session, nvim_tree)
  - `commands/` — User commands (ai, lang, cleanup, ui)
  - `theme.lua` — Unified theme registry with 50+ themes
  - `theme_txaty.lua` — Custom ergonomic theme (dark/light variants)
  - `lang_utils.lua` — Shared utilities for language support
  - `lsp_capabilities.lua` — Single source of truth for LSP capabilities
  - `ai_toggle.lua`, `lang_toggle.lua`, `ui_toggle.lua` — Feature toggles
  - `cleanup.lua` — Automatic cleanup for temporary/cache files
- `lua/plugins/` — Self-contained plugin specs (all `.lua` files auto-imported)
  - `lsp.lua` — Mason + vim.lsp.config with LspAttach autocmd
  - `tools.lua` — conform.nvim (formatting) + nvim-lint
  - `ui.lua` — nvim-tree, lualine, bufferline, vim-illuminate
  - `snacks.lua` — Primary fuzzy finder (picker), dashboard, zen mode
  - `telescope.lua` — Fallback fuzzy finder for plugin integrations
  - `copilot.lua` — GitHub Copilot (respects AI toggle)
  - `session.lua` — persistence.nvim with auto-save/restore
  - `remote.lua` — Distant.nvim for remote development
  - `languages/` — Language-specific configs (python, rust, go, web, flutter)
- `lua/dap/` — Language-specific debug adapter configurations
- `docs/` — User documentation (keymaps reference)
- `.stylua.toml` — Lua formatter (120 column width, 2-space indent)
- `.luacheckrc` — Lua linter (Lua 5.1 std, vim globals)
- `lazy-lock.json` — Plugin version lockfile (always commit when plugins change)

## Plugin Development Patterns

### Pattern 1: Language Utilities (Recommended)
```lua
local lang = require "core.lang_utils"
return {
  lang.extend_treesitter { "python", "toml" },
  lang.extend_mason { "pyright", "ruff", "black", "isort" },
  lang.extend_conform { python = { "black", "isort" } },
  lang.extend_lspconfig { pyright = { settings = { ... } } },
}
```

### Pattern 2: LspAttach Autocmd for Keymaps
LSP keymaps are registered via `LspAttach` event in `lua/plugins/lsp.lua`:
```lua
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  end,
})
```

### Pattern 3: Dependency Chains
Plugins declare dependencies to ensure load order:
```lua
{
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
}
```

## Common Development Workflows

### Adding Language Support
1. Create `lua/plugins/languages/<language>.lua`
2. Use `lang_utils` helpers to extend treesitter, mason, conform, and lspconfig
3. Add language-specific plugins with `ft = "<language>"` lazy-loading
4. If needed, create DAP config in `lua/dap/<language>.lua`

### Modifying Keymaps
- **General**: Edit `lua/core/keymaps.lua`
- **Plugin-specific**: Add `keys` table in plugin spec
- **LSP**: Edit `LspAttach` autocmd in `lua/plugins/lsp.lua`
- **Update docs**: Modify `docs/keymaps.md`

### LSP Server Configuration
All LSP servers use the **new vim.lsp.config API** (Neovim 0.11+):
```lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = { Lua = { diagnostics = { globals = { "vim" } } } }
})
```

**CRITICAL**:
- Use `vim.lsp.config()` instead of `require('lspconfig')[server].setup()`
- **NEVER** set `cmd` or `root_dir` fields manually (causes conflicts with Mason)
- Rust is handled exclusively by `rustaceanvim` (not included in lspconfig)
- **ALWAYS** use `require("core.lsp_capabilities").get()` for capabilities

## Testing and Validation

### Health Checks
```bash
nvim --headless '+checkhealth' +qa
nvim --headless "+lua print(require('lazy').stats().count)" +qa
```

### Manual Testing Checklist
1. Open representative files (py, go, rs, ts, tex, lua)
2. Verify LSP attaches (`:LspInfo`)
3. Test formatting (`<leader>lf` or on save)
4. Test DAP breakpoints (`<leader>db`)
5. Test session save/restore (`<leader>qs` / `<leader>ql`)
6. Verify nvim-tree auto-opens on empty buffers

### Load Order Verification
```bash
nvim --cmd "let g:debug_lifecycle=1" --cmd "let g:debug_plugin_load=1" test.lua
:LoadOrder  # Inside Neovim
```

**Load Order Assertions (Debug Mode):**
- navic loads before lspconfig (critical for breadcrumbs)
- colorscheme loads before UI plugins (prevents white flash)
- snacks.nvim loads early (priority=1000)
- mason-lspconfig available for language extensions

## Key Keymap Groups

- `<leader>` is Space
- `<leader>f*` — Files (find, grep, tree)
- `<leader>b*` — Buffers (next, prev, delete)
- `<leader>l*` — LSP (rename, format, diagnostics)
- `<leader>g*` — Git (stage, reset, blame, diffview)
- `<leader>d*` — Debug (breakpoints, step, REPL)
- `<leader>t*` — Testing (nearest, file, suite)
- `<leader>p*` — Python (venv selector)
- `<leader>r*` — Remote development (distant.nvim)
- `<leader>R*` — Rust operations (rustaceanvim)
- `<leader>C*` — Crates management (Cargo.toml)
- `<leader>c*` — Theme/Color switching
- `<leader>a*` — AI assistance (Copilot Chat)
- `<leader>L*` — Language support panel
- `<leader>u*` — UI/Display toggles (session-persistent)
- `<leader>q*` — Session/Quit
- `<leader>x*` — Diagnostics/Trouble
- `<leader>S` — Search & Replace (grug-far)
- `<leader>M*` — Minimap
- `s/S` — Flash navigation
- `<C-n>` — Toggle nvim-tree

See `docs/keymaps.md` for complete reference.

## Theme System

50+ themes: 25+ dark, 20+ light, 2 custom (txaty ergonomic dark/light).

**Usage:**
- `<leader>cc` — Choose theme (Telescope picker)
- `<leader>cd/cl/cp` — Switch to dark/light/txaty theme
- `<leader>cn/cN` — Cycle themes

**Custom txaty theme:** Factory pattern with ergonomic design (low saturation 15-25%, warm neutrals, WCAG 2.1 AA compliant). Theme preference saved to `$XDG_DATA_HOME/theme_config.json`.

## Session Management

- **Auto-save**: Sessions saved on VimLeavePre
- **Auto-restore**: Restored when opening Neovim without arguments
- **Per-directory**: Each workspace maintains its own session state
- **Manual**: `<leader>qs` (save), `<leader>ql` (load last), `<leader>qS` (select)

**Note:** Global variables (vim.g.*) are NOT in sessions. UI state persisted separately via JSON config files to maintain single source of truth.

## Automatic Cleanup

Runs on startup (throttled to once per 24 hours) to minimize disk footprint:
- Log files (>7 days old)
- Swap files (orphaned >1 day)
- View files (missing source)
- Luac cache (>30 days)
- LSP logs (>7 days)

Manual trigger: `:CleanupNvim`. Opt-out: `vim.g.disable_auto_cleanup = true`

## Language-Specific Notes

| Language | LSP | Formatters | Notes |
|----------|-----|------------|-------|
| Python | pyright, ruff | black, isort | venv-selector (`<leader>pv`) |
| Rust | rustaceanvim | rustfmt | **Never** configure rust-analyzer manually |
| Go | gopls | goimports, gofmt | No manual cmd/root_dir |
| Flutter | flutter-tools | - | `<leader>FR` run, `<leader>Fr` reload |
| LaTeX | - | latexindent | vimtex |
| Typst | - | - | typst-preview live preview |

## Additional Plugins

### UI/UX
- **noice.nvim** — Modern UI for messages, cmdline, popupmenu
- **flash.nvim** — Fast navigation (`s` jump, `S` Treesitter select)
- **trouble.nvim** — Pretty diagnostics, references, quickfix
- **which-key.nvim** — Popup showing available keybindings

### Git
- **lazygit.nvim** — Terminal UI for git (`<leader>gg`)
- **gitsigns.nvim** — Git decorations and hunk operations

### Remote Development
- **distant.nvim** — VS Code Remote-like experience (`<leader>r*`)
  - SSH-based with compression (zstd)
  - Auto LSP attachment for remote buffers

### AI Assistance
- **copilot.lua** — Ghost text completion (`<M-l>` to accept)
- **CopilotChat.nvim** — Chat interface (`<leader>aa` toggle)

**AI Toggle:** `:AIToggle` or `<leader>ai` (requires restart). State saved to `$XDG_DATA_HOME/ai_config.json`.

**Language Toggle:** `:LangPanel` or `<leader>Lp`. Toggle per-language tooling. State saved to `$XDG_DATA_HOME/language_config.json`.

## Formatting & Linting

### Conform.nvim
- Format on save with `lsp_fallback = true`
- Manual format: `<leader>lf`
- Formatters: stylua (Lua), black/isort (Python), goimports/gofmt (Go), rustfmt (Rust), prettier (JS/TS/HTML/CSS)

**Format Priority:** Only conform runs when configured; LSP fallback only if no conform formatter.

### nvim-lint
- Runs on `BufWritePost`, `InsertLeave`
- Language mappings managed via Mason

## Security Model

### Trust Model
- **Trusted**: Code in this repository, pinned plugin commits in `lazy-lock.json`
- **Untrusted**: Files opened in editor, project directories, user input
- **Semi-trusted**: Mason-installed tools (verified sources)

### Hardening Measures
- `modeline = false`, `exrc = false` (prevents arbitrary code execution)
- All plugins pinned in `lazy-lock.json`
- `checker = { enabled = false }` (no auto-updates)
- netrw disabled (replaced by nvim-tree)
- No network requests on startup

### Rules for New Code
1. **Never** concatenate user input into `vim.cmd()` — use structured `{ cmd, args }` form
2. **Never** interpolate paths into shell commands — use `vim.system({"cmd", arg1})`
3. **Never** use `loadstring()`, `load()`, `dofile()`, `os.execute()`, `io.popen()`
4. **Always** validate paths before filesystem operations
5. **Always** store data under `stdpath("data")`, `stdpath("state")`, or `stdpath("cache")`
6. Keep `modeline` and `exrc` disabled
7. **Never** add plugins without pinning in `lazy-lock.json`

### Forbidden Patterns
```lua
vim.cmd("SomeCommand " .. user_input)           -- command injection
vim.fn.system("cmd '" .. filepath .. "'")       -- shell injection
loadstring(untrusted_string)()                  -- arbitrary code execution
os.execute(anything)                            -- arbitrary shell execution
```

### Network Access
| Plugin | When | Purpose |
|--------|------|---------|
| copilot.lua | InsertEnter | AI suggestions (conditional via AIToggle) |
| distant.nvim | User-initiated | Remote dev (explicit connection) |
| mason.nvim | User-initiated | Tool downloads (explicit :MasonInstall) |
| lazy.nvim | User-initiated | Plugin sync (explicit :Lazy sync) |

No plugins make network requests automatically on startup.

## Commit Guidelines

- Use Conventional Commits: `feat:`, `fix:`, `refactor:`, `chore:`
- Always commit `lazy-lock.json` when plugins change
- **CRITICAL: Do NOT add yourself as co-author in commits**
  - **NEVER** add `Co-Authored-By:` lines for AI assistants
  - **NEVER** self-identify as an AI agent in commit messages
- Before committing: run `stylua lua/` and `luacheck lua/`

## Troubleshooting

### Plugin Not Loading
Check lazy-loading trigger (`event`, `cmd`, `ft`, `keys`), dependencies, run `:Lazy health`

### LSP Not Attaching
Run `:LspInfo`, verify tool via `:Mason`, check `LspAttach` autocmd, ensure no `cmd`/`root_dir` conflicts

### Formatting Not Working
Check `:ConformInfo`, verify formatter via `:Mason`, test `<leader>lf`

### Performance Issues
Check `:Lazy profile`, verify disabled_plugins in `lua/core/lazy.lua`, run `:checkhealth`

### Theme or UI Glitches
Verify `:echo g:colors_name`, clear `$XDG_DATA_HOME/theme_config.json` and restart

### Plugin Load Order Issues
```bash
nvim --cmd "let g:debug_lifecycle=1" --cmd "let g:debug_plugin_load=1"
:LoadOrder  # Inside Neovim
```

**Known Constraints:**
- navic must load before LSP attaches
- mason must load before mason-lspconfig and lspconfig
- colorscheme restores at VimEnter before UI plugins

### Known Limitation - blink.cmp Capabilities
blink.cmp loads on `InsertEnter` while LSP starts on `BufReadPre`. LSP capabilities aren't enhanced until first InsertEnter. This rarely matters in practice.
