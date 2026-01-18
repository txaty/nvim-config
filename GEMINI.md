# Gemini Context for Neovim Configuration

## Project Overview
This repository contains a custom, self-maintained Neovim configuration. It uses `lazy.nvim` for plugin management and `mason.nvim` for managing external editor tooling (LSP servers, DAP servers, linters, and formatters). The configuration is written in Lua and organized around a modular `lua/core/` + `lua/plugins/` architecture.

**Important**: This config has **completely removed all NvChad files and dependencies**. It is now a fully independent, standalone configuration with no NvChad remnants in the codebase.

## Key Technologies
*   **Core**: Neovim (Lua)
*   **Package Manager**: `lazy.nvim`
*   **Tool Management**: `mason.nvim`, `mason-lspconfig`, `mason-nvim-dap`
*   **LSP**: `vim.lsp.config` (new Neovim 0.11+ API, migrated from nvim-lspconfig)
*   **Formatting**: `conform.nvim` (prettierd, prettier, stylua, black, isort, gofmt, rustfmt, clang-format, latexindent)
*   **Linting**: `nvim-lint`
*   **Completion**: `nvim-cmp` + `cmp-nvim-lsp`
*   **Syntax**: `nvim-treesitter`
*   **Diagnostics UI**: `trouble.nvim`
*   **Todo Highlighting**: `todo-comments.nvim`
*   **Search & Replace**: `nvim-spectre`
*   **Git TUI**: `lazygit.nvim`
*   **AI**: `copilot.lua` + `CopilotChat.nvim`
*   **UI Polish**: `noice.nvim` + `dressing.nvim`
*   **Navigation**: `flash.nvim`
*   **Mobile**: `flutter-tools.nvim`
*   **Markdown**: `render-markdown.nvim`
*   **File Explorer**: `nvim-tree.lua`
*   **Statusline**: `lualine.nvim`
*   **Bufferline**: `bufferline.nvim`
*   **Fuzzy Finder**: `telescope.nvim`
*   **Git**: `gitsigns.nvim`
*   **Debugging**: `nvim-dap`
*   **Session**: `persistence.nvim` (auto-save/auto-restore session management)
*   **Themes**: 21+ themes (10 dark, 10 light, 1 custom txaty - low-saturation ergonomic)
*   **Theme Switcher**: Telescope-based picker with persistence

## Directory Structure
*   `init.lua`: The entry point for Neovim. Loads `lua/core/init.lua`.
*   `lazy-lock.json`: Lockfile for plugin versions.
*   `.stylua.toml`: Configuration for stylua (Lua formatter - 120 column width, 2-space indent).
*   `.luacheckrc`: Lua linter configuration (Lua 5.1 std, vim globals).
*   `lua/core/`: Core Neovim settings and bootstrap
    *   `init.lua`: Loads all core modules (options, keymaps, autocmds, lazy).
    *   `options.lua`: Vim options (vim.opt) and sane defaults.
    *   `keymaps.lua`: General keybindings and navigation shortcuts.
    *   `autocmds.lua`: Event-driven logic (cursor restoration, view saving, auto-open nvim-tree).
    *   `lazy.lua`: Bootstraps lazy.nvim with custom performance settings.
    *   `theme.lua`: Theme switching module with JSON persistence.
    *   `theme_txaty.lua`: Custom low-saturation ergonomic dark theme (#0f1419).
    *   `lang_utils.lua`: Shared utilities for language support (reduces boilerplate).
*   `lua/plugins/`: Plugin specifications (using lazy.nvim syntax), organized by domain
    *   `lsp.lua`: Mason + vim.lsp.config (new Neovim 0.11+ API) with LspAttach autocmd.
    *   `tools.lua`: conform.nvim (formatting) + nvim-lint (merged file).
    *   `cmp.lua`: nvim-cmp completion configuration.
    *   `treesitter.lua`: Treesitter setup.
    *   `ui.lua`: nvim-tree, lualine, bufferline, vim-illuminate.
    *   `colorscheme.lua`: 21+ theme options (10 dark, 10 light, 1 custom).
    *   `theme_switcher.lua`: Telescope-based interactive theme picker.
    *   `session.lua`: persistence.nvim with auto-save/auto-restore.
    *   `bookmark.lua`: bookmarks.nvim with telescope extension.
    *   `documents.lua`: vimtex (LaTeX) + typst-preview (merged file).
    *   `noice.lua`, `flash.lua`, `trouble.lua`, `todo.lua`, `spectre.lua`: UI/UX plugins.
    *   `copilot.lua`: GitHub Copilot integration.
    *   `dap.lua`: Debug adapter protocol setup.
    *   `test.lua`: neotest testing framework.
    *   `minimap.lua`: neominimap.nvim code minimap.
    *   `languages/`: Language-specific configurations using lang_utils:
        *   `python.lua`, `go.lua`, `rust.lua`, `flutter.lua`, `web.lua`.
*   `lua/dap/`: Debug Adapter Protocol configurations (web.lua, cpp.lua, python.lua, flutter.lua).
*   `docs/`: User documentation (keymaps.md reference).
*   **Note**: `lua/configs/` and other NvChad-related directories have been completely removed. All configuration is inlined into plugin specs.

## Building and Running
Since this is a configuration project, "building" refers to installing dependencies and "running" refers to starting Neovim.

### Commands
*   **Start Neovim**: `nvim`
*   **Sync Plugins**: `nvim --headless "+lua require('lazy').sync()" +qa`
*   **Update Treesitter Parsers**: `nvim --headless '+TSUpdateSync' +qa`
*   **Health Check**: `nvim --headless '+checkhealth' +qa`
*   **Format Lua Config**: `stylua lua/`
*   **Lint Lua Config**: `luacheck lua/` or `$HOME/.luarocks/bin/luacheck lua/`

### Tool Installation
Tools (LSP, Formatters, Linters, DAP) are managed by Mason.
*   **:Mason**: Open the Mason UI to install/update tools.
*   **:MasonInstallAll**: Install all tools defined in `lua/plugins/lsp.lua`.

## Development Conventions

### Code Style
*   **Lua**: Indent with 2 spaces. Use `local` variables where possible. Avoid globals.
*   **Formatting**: Handled by `conform.nvim` (auto-format on save for supported filetypes).
    *   Lua: `stylua`
    *   Python: `black`, `isort`
    *   Web (JS/TS/CSS/HTML): `prettierd` (fallback to `prettier`)
    *   Go: `goimports`, `gofmt`
    *   Rust: `rustfmt`
    *   C/C++: `clang-format`
    *   TeX: `latexindent`

### Key Features & Workflows
*   **LSP**:
    *   Servers use new `vim.lsp.config()` API (Neovim 0.11+, migrated from deprecated nvim-lspconfig).
    *   Configured via mason-lspconfig handlers in `lua/plugins/lsp.lua`.
    *   Buffer-local keymaps set in LspAttach autocmd.
    *   Key mappings: `gd` (definition), `gr` (references), `K` (hover), `<leader>la` (code action), `<leader>rn` (rename), `<leader>lf` (format).
    *   **CRITICAL**: NEVER set `cmd` or `root_dir` manually (conflicts with Mason). Rust is handled by `rustaceanvim`, not lspconfig.
*   **Formatting**: `<leader>lf` or auto-format on save (via conform.nvim).
*   **Diagnostics**: Use `trouble.nvim` (`<leader>xx`) to view and filter project-wide diagnostics.
*   **Todo Comments**: Use keywords (`TODO`, `FIXME`, `HACK`, `NOTE`) in code. Search with `<leader>ft`.
*   **Search & Replace**: Use `nvim-spectre` (`<leader>S`) for project-wide find and replace.
*   **Git**: Use `lazygit` (`<leader>gg`) for staging, committing, amending, rebasing.
*   **AI**:
    *   Completion: GitHub Copilot (ghost text). Accept with `<C-l>`.
    *   Chat: `<leader>cc` to toggle chat. `<leader>ce` to explain, `<leader>cf` to fix.
*   **Navigation**:
    *   Flash: Press `s` to jump anywhere. Press `S` to select Treesitter nodes.
    *   Telescope: `<leader>ff` (find files), `<leader>fg` (live grep), `<leader>fb` (buffers).
*   **UI**:
    *   File Explorer: `<C-n>` to toggle nvim-tree.
    *   Statusline: lualine (auto theme).
    *   Bufferline: Navigate buffers with `<Tab>` / `<S-Tab>` or `<leader>x` to close.
    *   Noice History: `<leader>nh`. Dismiss Notifications: `<leader>nd`.
*   **Theme Switching**:
    *   Choose theme: `<leader>cc` (Telescope picker) or `:ThemeSwitch`
    *   Quick switch: `<leader>cd` (dark), `<leader>cl` (light), `<leader>cp` (txaty custom)
    *   Cycle themes: `<leader>cn` (next), `<leader>cN` (previous)
    *   21+ themes available: 10 dark, 10 light, 1 custom txaty (low-saturation ergonomic)
    *   Preference persisted to `$XDG_DATA_HOME/theme_config.json`
*   **Session Management**:
    *   Auto-save: Sessions automatically saved on VimLeavePre
    *   Auto-restore: Automatically restored when opening Neovim without arguments
    *   Manual controls: `<leader>qs` (restore/save), `<leader>ql` (restore last), `<leader>qS` (select), `<leader>qd` (don't save)
    *   Per-directory sessions maintain buffers, windows, tabs, and state
    *   Session-aware nvim-tree: Won't auto-open if session exists for current directory
*   **Markdown**: Automatic rendering of headings, tables, and checkboxes (Obsidian-style).
*   **Flutter**:
    *   Run: `<leader>FR`
    *   Hot Reload: `<leader>Fr`
    *   Hot Restart: `<leader>FR`
    *   Emulator management and device selection available
*   **Debugging (DAP)**:
    *   Managed by `mason-nvim-dap` and configured in `lua/plugins/dap.lua`.
    *   Language-specific configs in `lua/dap/`.
    *   Toggle breakpoint: `<leader>db`
    *   Step over/into/out, continue, REPL available
*   **Minimap**:
    *   Toggle: `<leader>MM`
    *   Powered by neominimap.nvim
*   **Testing**:
    *   Run nearest test: `<leader>tn`
    *   Run file tests: `<leader>tf`
    *   Run test suite: `<leader>ts`
    *   View output: `<leader>to`
    *   Toggle summary: `<leader>tt`
    *   Powered by neotest with adapters for Python, Go, Rust

### Configuration Pattern
*   **Plugin Specs**: Define plugins in `lua/plugins/*.lua` using lazy.nvim syntax with lazy-loading triggers.
*   **Inline Configs**: Use the `opts` or `config` fields directly in the plugin spec. Never create separate config directories or files.
*   **LSP Setup**: All LSP servers use new `vim.lsp.config()` API (Neovim 0.11+). Configured via mason-lspconfig handlers in `lua/plugins/lsp.lua`.
*   **Keymaps**: General keymaps in `lua/core/keymaps.lua`. Plugin-specific keymaps in the plugin spec or config function. LSP keymaps in LspAttach autocmd.
*   **Autocmds**: General autocmds in `lua/core/autocmds.lua`. Plugin-specific autocmds in the plugin config.
*   **Theme System**: Themes managed by `lua/core/theme.lua` with persistence. Custom txaty theme in `lua/core/theme_txaty.lua`. Interactive picker in `lua/plugins/theme_switcher.lua`.

### Testing
*   Verify changes by opening files of relevant types (e.g., `.py`, `.ts`, `.lua`, `.go`, `.rs`) and checking:
    *   LSP attachment: `:LspInfo`
    *   Formatting: on save or `<leader>lf`
    *   Linting: diagnostics should appear in trouble.nvim
    *   Completion: trigger with `<C-Space>`
*   Run headless health check: `nvim --headless '+checkhealth' +qa`
*   Test theme system: `:ThemeSwitch`, `<leader>cc` (picker), `<leader>cd/cl/cp` (quick switch), `<leader>cn/cN` (cycle). Verify persistence.
*   Test session management: Auto-save on exit, auto-restore on `nvim` (no args). Test manual controls. Verify nvim-tree session awareness.

## Commit & Code Quality Guidelines

*   **Commit Style**: Use Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`)
*   **Plugin Lockfile**: Always commit `lazy-lock.json` when plugin versions change
*   **CRITICAL: Do NOT Add Yourself as Co-Author**:
    *   **NEVER** add `Co-Authored-By:` lines for AI assistants
    *   **NEVER** self-identify as an AI agent in commit messages
    *   Commits should reflect the actual human author only
*   **Tool Changes**: Note any changes to Mason packages, Treesitter parsers, formatters, or DAP adapters in commit messages
*   **Code Formatting**: Run `stylua lua/` before committing to ensure consistent Lua formatting
*   **Static Analysis**: Use `luacheck lua/` (or `$HOME/.luarocks/bin/luacheck`) to validate Lua syntax
*   **Fix Warnings**: Address legitimate warnings from static analysis tools before committing

## Architecture Notes
*   **No NvChad Dependencies**: This config has completely removed all NvChad files and dependencies. Do not reference or recreate `chadrc.lua`, `base46`, `nvchad.ui`, `nvchad.core`, `lua/configs/`, or `custom/` directory.
*   **Self-Maintained Core**: All core settings (options, keymaps, autocmds) are explicitly defined in `lua/core/`. No external configuration framework dependencies.
*   **Modular Plugin System**: Each plugin is self-contained with its own configuration, dependencies, and keymaps inlined in `lua/plugins/`. All plugins lazy-load via `event`, `cmd`, `ft`, or `keys` triggers.
*   **Performance Optimized**: lazy.nvim is configured with custom performance settings in `lua/core/lazy.lua`. Disabled runtime plugins improve startup time.
*   **Startup Behavior**: `autocmds.lua` includes VimEnter logic to auto-open nvim-tree for directories/empty buffers (session-aware: won't open if session exists).
*   **Theme System**: Seamless theme switching with 21+ themes (10 dark, 10 light, 1 custom txaty). Custom txaty theme is low-saturation ergonomic dark (#0f1419) based on research showing too many colors impair code reading. Preference persisted to `$XDG_DATA_HOME/theme_config.json`.
*   **Session Management**: Auto-save on VimLeavePre, auto-restore when opening Neovim without arguments. Per-directory sessions maintain buffers, windows, tabs, and state. Integrates with nvim-tree auto-open logic.
*   **LSP Migration**: Migrated from deprecated `require('lspconfig')` to new `vim.lsp.config()` API (Neovim 0.11+). All servers managed through mason-lspconfig handlers with `vim.lsp.enable()`. Rust handled exclusively by `rustaceanvim`.
