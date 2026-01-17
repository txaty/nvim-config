# Gemini Context for Neovim Configuration

## Project Overview
This repository contains a user's Neovim configuration, built on top of [NvChad](https://nvchad.com/) v2.5. It utilizes `lazy.nvim` for plugin management and `mason.nvim` for managing external editor tooling (LSP servers, DAP servers, linters, and formatters). The configuration is written in Lua and is modularized by domain (e.g., Python, Web, Git).

## Key Technologies
*   **Core**: Neovim (Lua)
*   **Base Framework**: NvChad v2.5
*   **Package Manager**: `lazy.nvim`
*   **Tool Management**: `mason.nvim`, `mason-lspconfig`, `mason-conform`, `mason-lint`
*   **LSP**: `nvim-lspconfig`
*   **Formatting**: `conform.nvim`
*   **Linting**: `nvim-lint`
*   **Diagnostics UI**: `trouble.nvim`
*   **Todo Highlighting**: `todo-comments.nvim`
*   **Search & Replace**: `nvim-spectre`
*   **Git TUI**: `lazygit.nvim`
*   **AI**: `copilot.lua` + `CopilotChat.nvim`
*   **Mobile**: `flutter-tools.nvim`
*   **File Explorer**: `nvim-tree`
*   **Fuzzy Finder**: `telescope.nvim`
*   **Git**: `gitsigns.nvim`
*   **Debugging**: `nvim-dap`

## Directory Structure
*   `init.lua`: The entry point for Neovim. Bootstraps `lazy.nvim` and loads plugins.
*   `lazy-lock.json`: Lockfile for plugin versions.
*   `lua/`: Contains all Lua configuration modules.
    *   `chadrc.lua`: NvChad-specific overrides (theme, UI).
    *   `mappings.lua`: Custom keybindings.
    *   `options.lua`: Vim options (vim.opt).
    *   `configs/`: Configuration logic for individual plugins (e.g., `lspconfig.lua`, `conform.lua`, `treesitter.lua`).
    *   `plugins/`: Plugin specifications (using `lazy.nvim` syntax), organized by language/domain (e.g., `python.lua`, `web.lua`, `rust.lua`).
    *   `dap/`: Debug Adapter Protocol configurations.
*   `docs/`: Documentation, including keymaps.
*   `.stylua.toml`: Configuration for `stylua` (Lua formatter).

## Building and Running
Since this is a configuration project, "building" refers to installing dependencies and "running" refers to starting Neovim.

### Commands
*   **Start Neovim**: `nvim`
*   **Sync Plugins**: `nvim --headless "+lua require('lazy').sync()" +qa`
*   **Update Treesitter Parsers**: `nvim --headless '+TSUpdateSync' +qa`
*   **Health Check**: `nvim --headless '+checkhealth' +qa`
*   **Format Lua Config**: `stylua lua/`

### Tool Installation
Tools (LSP, Formatters) are generally managed by Mason.
*   **:Mason**: Open the Mason UI to install/update tools.
*   **:MasonInstallAll**: Install all tools defined in the configuration (NvChad helper).

## Development Conventions

### Code Style
*   **Lua**: Indent with 2 spaces. Use `local` variables where possible.
*   **Formatting**: Handled by `conform.nvim`.
    *   Lua: `stylua`
    *   Python: `black`, `isort`
    *   Web (JS/TS/CSS/HTML): `prettierd` (fallback to `prettier`)
    *   Go: `goimports`, `gofmt`
    *   Rust: `rustfmt`
    *   C/C++: `clang-format`
    *   TeX: `latexindent`
*   **Diagnostics**: Use `trouble.nvim` (`<leader>xx`) to view and filter project-wide diagnostics.
*   **Comments**: Use `todo-comments.nvim` keywords (`TODO`, `FIXME`, `HACK`, `NOTE`) to mark technical debt. Use `<leader>ft` to search them.
*   **Refactoring**: Use `nvim-spectre` (`<leader>S`) for project-wide find and replace.
*   **Git**: Use `lazygit` (`<leader>gg`) for complex git operations (staging, amending, rebase).
*   **AI**:
    *   Completion: GitHub Copilot (ghost text). Accept with `<C-l>`.
    *   Chat: `<leader>cc` to toggle chat. `<leader>ce` to explain, `<leader>cf` to fix.
*   **Flutter**:
    *   Run: `<leader>cF`
    *   Hot Reload/Restart: `<leader>cR` / `<leader>cr`
    *   Emulators: `<leader>ce`

### Configuration Pattern
*   **Plugin Specs**: Define new plugins in `lua/plugins/*.lua`. Use the `opts` or `config` fields to point to configuration files in `lua/configs/`.
*   **LSP**: LSP servers are defined in `lua/configs/lspconfig.lua`. This file iterates over a table of servers and sets them up using `nvim-lspconfig`.
*   **Keymaps**: Define general keymaps in `lua/mappings.lua`. Plugin-specific keymaps can be defined within the plugin spec or config.

### Testing
*   Verify changes by opening files of relevant types (e.g., `.py`, `.ts`, `.lua`) and checking for LSP attachment (`:LspInfo`), formatting (on save or `<leader>lf`), and linting.
