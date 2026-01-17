# Gemini Context for Neovim Configuration

## Project Overview
This repository contains a custom, self-maintained Neovim configuration. It uses `lazy.nvim` for plugin management and `mason.nvim` for managing external editor tooling (LSP servers, DAP servers, linters, and formatters). The configuration is written in Lua and organized around a modular `lua/core/` + `lua/plugins/` architecture.

**Important**: This config has **completely removed all NvChad files and dependencies**. It is now a fully independent, standalone configuration with no NvChad remnants in the codebase.

## Key Technologies
*   **Core**: Neovim (Lua)
*   **Package Manager**: `lazy.nvim`
*   **Tool Management**: `mason.nvim`, `mason-lspconfig`, `mason-nvim-dap`
*   **LSP**: `nvim-lspconfig`
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
*   **Session**: `persistence.nvim` (VS Code-like session management)
*   **Themes**: Catppuccin, Tokyonight, Kanagawa, Gruvbox, Nord, and more

## Directory Structure
*   `init.lua`: The entry point for Neovim. Loads `lua/core/init.lua`.
*   `lazy-lock.json`: Lockfile for plugin versions.
*   `.stylua.toml`: Configuration for stylua (Lua formatter).
*   `lua/core/`: Core Neovim settings and bootstrap
    *   `init.lua`: Loads all core modules (options, keymaps, autocmds, lazy).
    *   `options.lua`: Vim options (vim.opt) and sane defaults.
    *   `keymaps.lua`: General keybindings and navigation shortcuts.
    *   `autocmds.lua`: Event-driven logic (cursor restoration, view saving, auto-open nvim-tree).
    *   `lazy.lua`: Bootstraps lazy.nvim with custom performance settings.
*   `lua/plugins/`: Plugin specifications (using lazy.nvim syntax), organized by domain
    *   `init.lua`: Core plugins (telescope, which-key, git, etc.).
    *   `lsp.lua`: Mason + nvim-lspconfig with LspAttach autocmd and buffer-local keymaps.
    *   `formatting.lua`: conform.nvim configuration.
    *   `linting.lua`: nvim-lint setup.
    *   `cmp.lua`: nvim-cmp completion configuration.
    *   `treesitter.lua`: Treesitter setup.
    *   `ui.lua`: nvim-tree, lualine, bufferline.
    *   `colorscheme.lua`: Multiple theme options with lazy-loading.
    *   `session.lua`: persistence.nvim for session management.
    *   `noice.lua`, `flash.lua`, `trouble.lua`, `todo.lua`, `spectre.lua`: UI/UX plugins.
    *   `copilot.lua`: GitHub Copilot integration.
    *   `dap.lua`: Debug adapter protocol setup.
    *   Language-specific: `python.lua`, `go.lua`, `rust.lua`, `flutter.lua`, `web.lua`, `tex.lua`, `typst.lua`, `minimap.lua`.
*   `lua/dap/`: Debug Adapter Protocol configurations (web.lua, cpp.lua).
*   **Note**: `lua/configs/` and other NvChad-related directories have been completely removed. All configuration is inlined into plugin specs.

## Building and Running
Since this is a configuration project, "building" refers to installing dependencies and "running" refers to starting Neovim.

### Commands
*   **Start Neovim**: `nvim`
*   **Sync Plugins**: `nvim --headless "+lua require('lazy').sync()" +qa`
*   **Update Treesitter Parsers**: `nvim --headless '+TSUpdateSync' +qa`
*   **Health Check**: `nvim --headless '+checkhealth' +qa`
*   **Format Lua Config**: `stylua lua/`

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
    *   Servers are configured via mason-lspconfig in `lua/plugins/lsp.lua:74-97`.
    *   Buffer-local keymaps are set in LspAttach autocmd at `lua/plugins/lsp.lua:44-71`.
    *   Key mappings: `gd` (definition), `gr` (references), `K` (hover), `<leader>la` (code action), `<leader>rn` (rename), `<leader>lf` (format).
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
*   **Session Management**:
    *   Save session: `<leader>qs`
    *   Load session: `<leader>ql`
    *   Powered by `persistence.nvim` for VS Code-like session restoration.
*   **Markdown**: Automatic rendering of headings, tables, and checkboxes (Obsidian-style).
*   **Flutter**:
    *   Run: `<leader>cF`
    *   Hot Reload/Restart: `<leader>cR` / `<leader>cr`
    *   Emulators: `<leader>ce`
*   **Debugging (DAP)**:
    *   Managed by `mason-nvim-dap` and configured in `lua/plugins/dap.lua`.
    *   Language-specific configs in `lua/dap/`.

### Configuration Pattern
*   **Plugin Specs**: Define plugins in `lua/plugins/*.lua` using lazy.nvim syntax.
*   **Inline Configs**: Use the `opts` or `config` fields directly in the plugin spec. Never create separate config directories or files.
*   **LSP Setup**: All LSP servers are configured in `lua/plugins/lsp.lua` via mason-lspconfig handlers.
*   **Keymaps**: General keymaps in `lua/core/keymaps.lua`. Plugin-specific keymaps in the plugin spec or config function.
*   **Autocmds**: General autocmds in `lua/core/autocmds.lua`. Plugin-specific autocmds in the plugin config.

### Testing
*   Verify changes by opening files of relevant types (e.g., `.py`, `.ts`, `.lua`, `.go`, `.rs`) and checking:
    *   LSP attachment: `:LspInfo`
    *   Formatting: on save or `<leader>lf`
    *   Linting: diagnostics should appear in trouble.nvim
    *   Completion: trigger with `<C-Space>`
*   Run headless health check: `nvim --headless '+checkhealth' +qa`

## Commit & Code Quality Guidelines

*   **Commit Style**: Use Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`)
*   **Plugin Lockfile**: Always commit `lazy-lock.json` when plugin versions change
*   **Do NOT Self-Identify in Commits**: Do not add co-author lines or self-identify as an AI agent in commit messages
*   **Tool Changes**: Note any changes to Mason packages, Treesitter parsers, formatters, or DAP adapters in commit messages
*   **Code Formatting**: Run `stylua lua/` before committing to ensure consistent Lua formatting
*   **Static Analysis**: Use `luacheck lua/` (or `$HOME/.luarocks/bin/luacheck`) to validate Lua syntax
*   **Fix Warnings**: Address legitimate warnings from static analysis tools before committing

## Architecture Notes
*   **No NvChad Dependencies**: This config has completely removed all NvChad files and dependencies. Do not reference or recreate `chadrc.lua`, `base46`, `nvchad.ui`, `nvchad.core`, `lua/configs/`, or `custom/` directory.
*   **Self-Maintained Core**: All core settings (options, keymaps, autocmds) are explicitly defined in `lua/core/`. No external configuration framework dependencies.
*   **Modular Plugin System**: Each plugin is self-contained with its own configuration, dependencies, and keymaps inlined in `lua/plugins/`.
*   **Performance Optimized**: lazy.nvim is configured with custom performance settings in `lua/core/lazy.lua:5-13`.
*   **Startup Behavior**: `autocmds.lua` includes VimEnter logic to auto-open nvim-tree when opening directories or empty buffers (lua/core/autocmds.lua:89-102).
