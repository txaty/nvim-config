# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a custom, self-maintained Neovim configuration that has completely migrated away from NvChad. The architecture prioritizes modularity, lazy-loading, and explicit configuration over abstraction.

## Quick Reference

### Essential Commands
```bash
# Start Neovim
nvim

# Sync all plugins
nvim --headless "+lua require('lazy').sync()" +qa

# Update Treesitter parsers
nvim --headless '+TSUpdateSync' +qa

# Health check
nvim --headless '+checkhealth' +qa

# Format Lua config files
stylua lua/

# Lint Lua config files
luacheck lua/
```

### Inside Neovim
```vim
:Lazy sync          " Sync plugins
:Mason              " Manage LSP/DAP/formatter/linter tools
:LspInfo            " Check LSP server status
:checkhealth        " Comprehensive diagnostics
:ConformInfo        " Check formatter configuration
:Lazy profile       " Profile plugin load times

" AI Features Control (requires restart to apply)
:AIToggle           " Toggle AI features on/off
:AIEnable           " Enable AI features
:AIDisable          " Disable AI features
:AIStatus           " Show current AI status

" Language Support Control (requires restart to apply)
:LangPanel          " Open language support panel (Telescope)
:LangToggle <lang>  " Toggle language support
:LangEnable <lang>  " Enable language support
:LangDisable <lang> " Disable language support
:LangStatus [lang]  " Show language support status
```

## Critical Architectural Principles

### 1. No NvChad Dependencies
- **NEVER** reference or use NvChad plugins (base46, ui, nvchad.core)
- All functionality is explicitly implemented in `lua/core/` and `lua/plugins/`
- This is now a fully independent configuration with no NvChad dependencies
- NvChad files and directories have been completely removed from the codebase
- Do not create any NvChad-specific files (chadrc.lua, custom/, etc.)

### 2. Configuration Inlining
- **NEVER** create a `lua/configs/` directory - it has been completely removed
- All plugin configuration must be inlined in plugin specs using `config` or `opts` functions
- Each plugin file in `lua/plugins/` should be self-contained with its config, keymaps, and dependencies

### 3. Lazy-Loading by Default
- All plugins have `defaults = { lazy = true }` in lazy.nvim setup
- New plugins must specify load triggers: `event`, `cmd`, `ft`, or `keys`
- Exception: colorscheme plugins load immediately with `lazy = false` and `priority = 1000`

## Core Architecture

### Bootstrap Sequence
```
init.lua (entry point)
  └─ core/init.lua → loads in order:
      ├─ core/options.lua    (vim.opt settings)
      ├─ core/keymaps.lua    (general keybindings)
      ├─ core/autocmds.lua   (event handlers)
      └─ core/lazy.lua       (plugin manager bootstrap)
          └─ plugins/*       (lazy-loaded plugin specs)
```

### Directory Structure
- `lua/core/` — Fundamental Neovim settings and lazy.nvim bootstrap
  - `theme.lua` — Theme switching module with JSON persistence
  - `theme_txaty.lua` — Custom low-saturation ergonomic dark theme
  - `lang_utils.lua` — Shared utilities for language support (reduces boilerplate)
  - `ai_toggle.lua` — AI features toggle module (enables/disables Copilot)
  - `lang_toggle.lua` — Language support toggle module (enables/disables language tooling)
- `lua/plugins/` — Self-contained plugin specifications (all `.lua` files auto-imported)
  - `ui.lua` — nvim-tree, lualine, bufferline, vim-illuminate
  - `whichkey.lua` — Popup showing available keybindings
  - `telescope.lua` — Fuzzy finder and file navigation
  - `git.lua` — Gitsigns for git decorations and hunk operations
  - `lazygit.lua` — Terminal UI for git operations
  - `remote.lua` — Distant.nvim for VS Code-like remote development
  - `markdown.lua` — Markdown rendering and live preview
  - `lang_panel.lua` — Telescope-based language support panel
  - `languages/` — Language-specific configurations (python, rust, go, web, flutter)
- `lua/dap/` — Language-specific debug adapter configurations
- `docs/` — User documentation (keymaps reference)
- `.stylua.toml` — Lua formatter configuration (120 column width, 2-space indent)
- `.luacheckrc` — Lua linter configuration (Lua 5.1 std, vim globals)
- `lazy-lock.json` — Plugin version lockfile (always commit when plugins change)

## Plugin Development Patterns

### Pattern 1: Using Language Utilities (Recommended)
Language-specific plugins use `lang_utils` helpers to reduce boilerplate:

```lua
-- In lua/plugins/languages/python.lua
local lang = require "core.lang_utils"

return {
  lang.extend_treesitter { "python", "toml" },
  lang.extend_mason { "pyright", "ruff", "black", "isort" },
  lang.extend_conform { python = { "black", "isort" } },
  lang.extend_lspconfig {
    pyright = { settings = { ... } },
    ruff = {},
  },
  -- Additional language-specific plugins...
}
```

Legacy pattern (for manual extension):
```lua
{
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if opts.ensure_installed ~= "all" then
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "toml" })
    end
  end,
}
```

### Pattern 2: LspAttach Autocmd for Keymaps
LSP keymaps are registered via `LspAttach` event in `lua/plugins/lsp.lua`:

```lua
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
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
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function() ... end
}
```

### Pattern 4: Language-Specific Modules
Each language gets its own plugin file in `lua/plugins/languages/` that uses `lang_utils`:
- `languages/python.lua` — Python support with venv-selector
- `languages/rust.lua` — Rust support with rustaceanvim and crates.nvim
- `languages/go.lua` — Go support with gopls, goimports, delve
- `languages/web.lua` — JS/TS/HTML/CSS support
- `languages/flutter.lua` — Flutter development tools and hot reload
- `documents.lua` — LaTeX (vimtex) and Typst support (merged file)
- `test.lua` — Testing framework integration (neotest)

## Common Development Workflows

### Adding Language Support
1. Create `lua/plugins/languages/<language>.lua`
2. Use `lang_utils` helpers to extend treesitter, mason, conform, and lspconfig
3. Add language-specific plugins with `ft = "<language>"` lazy-loading
4. If needed, create DAP config in `lua/dap/<language>.lua`

Example:
```lua
-- lua/plugins/languages/newlang.lua
local lang = require "core.lang_utils"

return {
  lang.extend_treesitter { "newlang" },
  lang.extend_mason { "newlang-lsp", "newlang-formatter" },
  lang.extend_conform { newlang = { "newlang-formatter" } },
  lang.extend_lspconfig {
    newlang_lsp = { settings = { ... } },
  },
}
```

### Adding/Modifying Plugins
1. Create or edit file in `lua/plugins/`
2. Return table of plugin specs with lazy-loading triggers
3. Inline all configuration in `opts` or `config` functions
4. Run `:Lazy sync` to install/update
5. Commit `lazy-lock.json` changes

### Modifying Keymaps
- **General keymaps**: Edit `lua/core/keymaps.lua`
- **Plugin-specific keymaps**: Add `keys` table in plugin spec
- **LSP keymaps**: Edit `LspAttach` autocmd in `lua/plugins/lsp.lua`
- **Update documentation**: Modify `docs/keymaps.md`

### LSP Server Configuration
All LSP servers are configured in `lua/plugins/lsp.lua` using the **new vim.lsp.config API** (Neovim 0.11+):

```lua
-- New API (migrated from deprecated require('lspconfig'))
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } }
    }
  }
})
```

For servers managed by mason-lspconfig, pass handlers to setup():

```lua
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "pyright" },
  handlers = {
    function(server_name)
      vim.lsp.enable(server_name)
    end,
  },
}
```

**CRITICAL**:
- Use `vim.lsp.config()` instead of `require('lspconfig')[server].setup()`
- **NEVER** set `cmd` or `root_dir` fields manually (causes conflicts with Mason)
- Rust is handled exclusively by `rustaceanvim` (not included in lspconfig)

## Testing and Validation

### Health Checks
```bash
nvim --headless '+checkhealth' +qa
```

### Plugin Management
```bash
# Sync plugins (inside Neovim)
:Lazy sync

# Or headless
nvim --headless "+lua require('lazy').sync()" +qa

# Update Treesitter parsers
nvim --headless '+TSUpdateSync' +qa
```

### Formatting
```bash
# Format all Lua files
stylua lua/

# Uses .stylua.toml config
```

### LSP/Tool Verification
```vim
:Mason        " Check installed tools
:LspInfo      " Check LSP server status
:checkhealth  " Comprehensive health check
```

### Manual Testing Checklist
1. Open representative files (py, go, rs, ts, tex, lua)
2. Verify LSP attaches (`:LspInfo`)
3. Test formatting (`<leader>lf` or on save)
4. Test DAP breakpoints (`<leader>db`)
5. Test session save/restore (`<leader>qs` / `<leader>ql`)
6. Verify nvim-tree auto-opens on empty buffers

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
  - `<leader>rc` — Connect to remote server
  - `<leader>rd` — Disconnect from remote
  - `<leader>ro` — Open remote directory/file
  - `<leader>rf` — Find files on remote
  - `<leader>rg` — Live grep on remote
  - `<leader>rs` — System info
  - `<leader>rS` — Shell on remote
- `<leader>c*` — Theme/Color switching
  - `<leader>cc` — Choose theme (Telescope picker)
  - `<leader>cd` — Switch to dark theme
  - `<leader>cl` — Switch to light theme
  - `<leader>cp` — Switch to txaty custom theme
  - `<leader>cn/cN` — Next/Previous theme
- `<leader>a*` — AI assistance (Copilot Chat)
  - `<leader>ai` — Toggle AI features on/off (requires restart)
  - `<leader>aa` — Toggle AI chat
  - `<leader>aq` — Quick question
  - `<leader>ae` — Explain code
  - `<leader>at` — Generate tests
  - `<leader>af` — Fix code
  - `<leader>ar` — Review code
- `<leader>L*` — Language support panel (capital L to avoid LSP conflict)
  - `<leader>Lp` — Open language support panel (Telescope)
  - `<leader>Ls` — Show language support status
- `<leader>q*` — Session/Quit (save, load, quit)
- `<leader>x*` — Diagnostics/Trouble
- `<leader>S` — Spectre (project-wide search and replace)
- `<leader>M*` — Minimap (toggle, enable, disable, refresh)
- `s/S` — Flash navigation (jump to location/Treesitter node)
- `<C-n>` — Toggle nvim-tree file explorer

See `docs/keymaps.md` for complete reference.

## Theme System

### Architecture
The configuration features a seamless theme switching system with 21+ themes:

**Components:**
1. **Theme Module** (`lua/core/theme.lua`)
   - Manages theme switching and persistence
   - Saves preference to `$XDG_DATA_HOME/theme_config.json`
   - Supports 10 dark themes + 10 light themes + 1 custom theme
   - Commands: `:ThemeSwitch`, `:ThemeDark`, `:ThemeLight`, `:ThemeTxaty`

2. **Custom txaty Theme** (`lua/core/theme_txaty.lua`)
   - Low-saturation, ergonomic dark theme (#0f1419 background)
   - Based on research: "Too many colors impairs code reading"
   - Muted color palette for sustained focus
   - Comprehensive highlight groups for all plugins (LSP, Treesitter, UI, git, bufferline, etc.)

3. **Theme Switcher** (`lua/plugins/theme_switcher.lua`)
   - Telescope-based interactive theme picker
   - Navigation: `<leader>cn` (next), `<leader>cN` (previous)
   - Quick switching: `<leader>cd` (dark), `<leader>cl` (light), `<leader>cp` (txaty)

**Available Themes:**
- Dark: tokyonight, kanagawa, catppuccin, rose-pine, nightfox, onedark, cyberdream, gruvbox, nord, dracula
- Light: tokyonight-day, rose-pine-dawn, kanagawa-lotus, onelight, ayu-light, solarized-light, papercolor, omni, jellybeans-light, dayfox
- Custom: txaty (low-saturation ergonomic dark)

### Usage
```vim
:ThemeSwitch      " Open Telescope picker
<leader>cc        " Choose theme interactively (Telescope)
<leader>cd        " Switch to first dark theme (quick)
<leader>cl        " Switch to first light theme (quick)
<leader>cp        " Switch to txaty custom theme (quick)
<leader>cn        " Next theme (cycle forward)
<leader>cN        " Previous theme (cycle backward)
```

Note: Theme keybindings use `<leader>c*` prefix (for "color"). AI chat uses `<leader>a*` prefix.

## Session Management

### Auto-Save and Auto-Restore
The configuration uses `persistence.nvim` with automatic session management:

**Behavior:**
- **Auto-save**: Sessions are automatically saved when exiting Neovim (VimLeavePre)
- **Auto-restore**: Sessions are automatically restored when opening Neovim without arguments
- **Smart logic**: Only restores if `nvim` is run with no files (prevents unwanted restore when opening specific files)
- **Per-directory**: Each workspace maintains its own session state

**Session Contents:**
- Open buffers and their positions
- Window layouts and splits
- Tab pages
- Current working directory
- Window sizes
- Global variables
- Help windows

**Manual Controls:**
- `<leader>qs` — Restore/save current session
- `<leader>qS` — Select session from list
- `<leader>ql` — Restore last session
- `<leader>qd` — Don't save current session on exit

**Integration with nvim-tree:**
The nvim-tree auto-open logic is session-aware: if a session exists for the current directory, it won't auto-open nvim-tree, allowing the session to restore the workspace state instead.

## Language-Specific Notes

### Python
- Virtual environment selection via `<leader>pv` (venv-selector.nvim)
- Prefers per-project venvs over global `python3_host_prog`
- Formatters: black, isort (via conform.nvim)
- LSP: pyright, ruff

### Rust
- Uses rustaceanvim (not rust-tools)
- Crate management via crates.nvim
- DAP: codelldb adapter
- **CRITICAL**: Never manually configure rust-analyzer server; rustaceanvim handles it

### Go
- gopls configured without `cmd` or `root_dir` (managed by Mason)
- Formatters: goimports, gofmt
- DAP: delve adapter

### Flutter
- Uses flutter-tools.nvim for development workflow
- Run: `<leader>FR`, Hot reload: `<leader>Fr`, Hot restart: `<leader>FR`
- Emulator management and device selection available

### LaTeX (TeX)
- Uses vimtex for LaTeX editing
- Formatter: latexindent
- Integrated PDF viewer support

### Typst
- Modern alternative to LaTeX
- LSP support via typst-lsp

### Testing
- Uses neotest framework for running tests
- Adapters: neotest-python, neotest-go, neotest-rust
- Run nearest test: `<leader>tn`
- Run file tests: `<leader>tf`
- Run test suite: `<leader>ts`
- View test output: `<leader>to`
- Toggle summary: `<leader>tt`

## Additional Plugins

### UI/UX Enhancements
- **noice.nvim** — Modern UI for messages, cmdline, and popupmenu
- **flash.nvim** — Fast navigation with `s` (jump) and `S` (Treesitter select)
- **trouble.nvim** — Pretty diagnostics, references, quickfix list
- **todo-comments.nvim** — Highlight TODO, FIXME, HACK, NOTE comments
- **nvim-spectre** — Project-wide search and replace (`<leader>S`)
- **which-key.nvim** — Popup showing available keybindings
- **dressing.nvim** — Improve vim.ui.select and vim.ui.input interfaces

### Git Integration
- **lazygit.nvim** — Terminal UI for git (`<leader>gg`)
- **gitsigns.nvim** — Git decorations and hunk operations

### Remote Development
- **distant.nvim** — Remote development like VS Code Remote (`<leader>r*`)
  - Run Neovim locally, execute files/LSP/formatters on remote server
  - SSH-based with compression (zstd) for performance
  - Telescope integration for remote file operations (`<leader>rf`, `<leader>rg`)
  - Automatic LSP attachment for remote buffers
  - Connection status shown in lualine with 󰢹 indicator
  - Connection pooling for faster subsequent operations
  - Seamless integration with all existing features (git, DAP, formatting, etc.)

**Usage:**
1. Connect: `<leader>rc` → enter SSH connection (e.g., `ssh://user@hostname`)
2. Open remote: `<leader>ro` → navigate to remote directory
3. Edit files: All operations work transparently on remote
4. Disconnect: `<leader>rd`

### AI Assistance
- **copilot.lua** — GitHub Copilot integration with ghost text completion (`<C-l>` to accept)
- **CopilotChat.nvim** — Chat interface for Copilot (`<leader>aa` to toggle, `<leader>aq/ae/at/af/ar` for actions)

**AI Toggle Feature** (similar to Zed's "Disable AI"):
- Toggle AI features: `<leader>ai` or `:AIToggle`
- Explicit control: `:AIEnable`, `:AIDisable`, `:AIStatus`
- When disabled, Copilot plugins are never loaded (improves performance)
- State persists across sessions (saved to `$XDG_DATA_HOME/ai_config.json`)
- **Requires Neovim restart** to apply changes
- Useful for working on sensitive codebases or when Claude Code is sufficient

**Language Support Toggle Feature**:
- Open panel: `<leader>Lp` or `:LangPanel`
- Toggle per-language: `:LangToggle python`, `:LangEnable rust`, `:LangDisable web`
- Check status: `<leader>Ls` or `:LangStatus`
- Supported languages: python, rust, go, web, flutter, latex, typst
- When disabled, language plugins (LSP, formatter, linter, treesitter extensions) are not loaded
- State persists across sessions (saved to `$XDG_DATA_HOME/language_config.json`)
- **Requires Neovim restart** to apply changes
- Useful for improving performance or focusing on specific language stacks

### Markdown & Documentation
- **render-markdown.nvim** — Obsidian-style rendering for Markdown files
- **markdown-preview.nvim** — Live preview in browser

### Other Tools
- **nvim-surround** — Add/change/delete surrounding delimiters
- **comment.nvim** — Smart commenting with `gc` motion
- **persistence.nvim** — Session management with auto-save/restore
- **bookmark.nvim** — Enhanced bookmark functionality
- **neominimap.nvim** — Code minimap sidebar (`<leader>MM` to toggle)

## Formatting & Linting

### Conform.nvim (Formatting)
- Configured in `lua/plugins/tools.lua` (merged with linting)
- Format on save: `format_on_save = { timeout_ms = 500, lsp_fallback = true }`
- Manual format: `<leader>lf`
- Language-specific formatters configured in `lua/plugins/languages/` files using `lang_utils`
- Base language mappings:
  - Lua: stylua
  - Python: black, isort (via languages/python.lua)
  - Go: goimports, gofmt (via languages/go.lua)
  - Rust: rustfmt (via languages/rust.lua)
  - JS/TS/HTML/CSS: prettier (via languages/web.lua)

### nvim-lint (Linting)
- Configured in `lua/plugins/tools.lua` (merged with formatting)
- Runs on `BufEnter`, `BufWritePost`, `InsertLeave`
- Language mappings managed via Mason

**Luacheck Configuration** (`.luacheckrc`):
```lua
-- Lua 5.1 standard (Neovim uses LuaJIT)
-- Max line length: 120
-- Recognizes vim global
-- Unused argument checking enabled
```

**Command:**
```bash
luacheck lua/              # Lint all Lua config files
$HOME/.luarocks/bin/luacheck lua/  # If installed via luarocks
```

## Commit Guidelines

- Use Conventional Commits: `feat:`, `fix:`, `refactor:`, `chore:`
- Always commit `lazy-lock.json` when plugins change
- **CRITICAL: Do NOT add yourself as co-author in commits**
  - **NEVER** add `Co-Authored-By:` lines for AI assistants
  - **NEVER** self-identify as an AI agent in commit messages
  - Commits should reflect the actual human author only
- Note tool changes (Mason, Treesitter, formatters) in commit messages
- Before committing: run `stylua lua/` for code formatting
- Use `luacheck lua/` (or `$HOME/.luarocks/bin/luacheck`) to validate Lua code before committing
- Address any legitimate warnings from static analysis tools before committing

## Troubleshooting

### Plugin Not Loading
1. Check lazy-loading trigger: `event`, `cmd`, `ft`, `keys`
2. Verify dependencies are listed in `dependencies` table
3. Run `:Lazy health`

### LSP Not Attaching
1. Run `:LspInfo` to check server status
2. Verify tool installed via `:Mason`
3. Check `LspAttach` autocmd fired (`:autocmd LspAttach`)
4. Ensure no manual `cmd`/`root_dir` overrides conflict with Mason

### Formatting Not Working
1. Check conform.nvim config: `:ConformInfo`
2. Verify formatter installed via `:Mason`
3. Test manual format: `<leader>lf`
4. Check `format_on_save` setting in `lua/plugins/tools.lua`

### Performance Issues
1. Check lazy-loading: `:Lazy profile`
2. Verify RTP disabled_plugins in `lua/core/lazy.lua`
3. Run `:checkhealth` for general diagnostics
4. Ensure all plugins have appropriate lazy-loading triggers (`event`, `cmd`, `ft`, `keys`)
5. Check for plugin conflicts or duplicate functionality

### Treesitter Issues
1. Update parsers: `:TSUpdate` or `nvim --headless '+TSUpdateSync' +qa`
2. Check installed parsers: `:TSInstallInfo`
3. Verify treesitter configuration in `lua/plugins/treesitter.lua`

### DAP Not Working
1. Verify adapter installed: `:Mason`
2. Check DAP configuration in `lua/plugins/dap.lua`
3. Language-specific configs in `lua/dap/<language>.lua`
4. Use `:DapShowLog` to see debug adapter logs

### Git Integration Issues
1. Ensure `lazygit` CLI is installed separately: `brew install lazygit` or equivalent
2. Check gitsigns configuration in `lua/plugins/git.lua`
3. Verify git is available in PATH

### Theme or UI Glitches
1. Verify colorscheme loaded: `:echo g:colors_name`
2. Check theme file exists: `lua/core/theme_txaty.lua` for custom theme
3. Reload theme: `:lua require('core.theme_txaty').apply()`
4. For bufferline glitches: ensure theme includes bufferline highlight groups
5. Clear theme cache: delete `$XDG_DATA_HOME/theme_config.json` and restart

### Session Not Restoring
1. Check session file exists: `ls ~/.local/state/nvim/sessions/`
2. Verify you're opening Neovim without arguments (just `nvim`)
3. Check persistence autocmds: `:autocmd PersistenceAutoRestore`
4. Test manual restore: `<leader>qs` or `<leader>ql`
5. Check nvim-tree isn't interfering with session restoration
