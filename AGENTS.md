# Repository Guidelines

## Project Structure & Module Organization
- Root: `init.lua` (core loader), `lazy-lock.json` (plugin lockfile), `.stylua.toml` (Lua formatting - 120 column width, 2-space indent), `.luacheckrc` (Lua linter configuration).
- Core Lua: `lua/`
  - `core/` — fundamental Neovim settings and bootstrap:
    - `init.lua` — loads all core modules in sequence.
    - `options.lua` — vim options (vim.opt) and sane defaults.
    - `keymaps.lua` — general keybindings and navigation.
    - `autocmds.lua` — event-driven logic (restore cursor position, view saving, auto-open nvim-tree).
    - `lazy.lua` — lazy.nvim bootstrap with custom performance settings.
    - `theme.lua` — theme switching module with JSON persistence.
    - `theme_txaty.lua` — custom low-saturation ergonomic dark theme.
    - `lang_utils.lua` — shared utilities for language support (reduces boilerplate).
  - `plugins/` — modular plugin specs with inlined configurations:
    - `lsp.lua` — Mason + vim.lsp.config (new Neovim 0.11+ API) with LspAttach autocmd.
    - `tools.lua` — conform.nvim (formatting) + nvim-lint (merged file).
    - `cmp.lua` — nvim-cmp completion setup.
    - `treesitter.lua` — syntax highlighting and parsing.
    - `ui.lua` — nvim-tree, lualine, bufferline, vim-illuminate.
    - `whichkey.lua` — Popup showing available keybindings.
    - `telescope.lua` — Fuzzy finder and file navigation.
    - `git.lua` — Gitsigns for git decorations and hunk operations.
    - `lazygit.lua` — Terminal UI for git operations.
    - `markdown.lua` — Markdown rendering and live preview.
    - `colorscheme.lua` — theme options (21+ themes: dark, light, custom).
    - `theme_switcher.lua` — Telescope-based theme picker.
    - `session.lua` — persistence.nvim with auto-save/auto-restore.
    - `bookmark.lua` — bookmarks.nvim with telescope extension.
    - `documents.lua` — vimtex (LaTeX) + typst-preview (merged file).
    - `noice.lua`, `flash.lua`, `trouble.lua`, `todo.lua`, `spectre.lua` — UI/UX enhancements.
    - `copilot.lua` — GitHub Copilot integration.
    - `dap.lua` — debug adapter protocol setup.
    - `test.lua` — neotest testing framework.
    - `minimap.lua` — neominimap.nvim code minimap.
    - `languages/` — language-specific configurations using lang_utils:
      - `python.lua`, `go.lua`, `rust.lua`, `flutter.lua`, `web.lua`.
  - `dap/` — language-specific DAP configurations (`web.lua`, `cpp.lua`, `python.lua`, `flutter.lua`).
- **Note**: `lua/configs/` and other NvChad directories have been completely removed. All configuration is inlined into plugin specs.

## Build, Test, and Development Commands
- Format Lua: `stylua lua/` (uses `.stylua.toml`).
- Lint Lua: `luacheck lua/` or `$HOME/.luarocks/bin/luacheck lua/` (recognizes vim globals, Lua 5.1 std).
- Health check: `nvim --headless '+checkhealth' +qa` (reports missing deps).
- Sync plugins: `nvim --headless "+lua require('lazy').sync()" +qa`.
- Update Treesitter parsers: `nvim --headless '+TSUpdateSync' +qa`.
- Verify tooling: inside Neovim run `:Mason`, `:LspInfo`, `:ConformInfo`, and test with sample files.
- Theme testing: `:ThemeSwitch`, `<leader>cc` (picker), `<leader>cd/cl/cp` (quick switch), `<leader>cn/cN` (cycle themes).

## Coding Style & Naming Conventions
- Lua: 2-space indent; avoid globals; prefer local helpers.
- Filenames: lowercase snake_case. Plugin specs live in `lua/plugins/`; inline configs directly in plugin `config` or `opts` functions.
- Formatting via `conform.nvim`: JS/TS/HTML/CSS use `prettierd` (fallback `prettier`); Lua uses `stylua`; Python uses `black`/`isort`; Go uses `goimports`/`gofmt`; Rust uses `rustfmt`; TeX uses `latexindent`.
- Run `stylua` and validate `conform` runs on save where configured.
- All plugin configuration must be inlined into plugin specs - never create separate config files.

## Testing Guidelines
- Manual: launch Neovim, open representative files (py, go, rs, ts, tex, typst, lua) and verify LSP (`:LspInfo`), formatting (on save or `<leader>lf`), and linting.
- Headless: run the health, sync, and Treesitter commands above to catch startup issues.
- DAP: adapters are managed by `mason-nvim-dap`; verify via `:Mason` and test with sample launch configs and breakpoints (`<leader>db`).
- UI: Test lualine, bufferline, nvim-tree, and theme switching (21+ themes available).
- Theme System: Test `:ThemeSwitch`, `<leader>cc` (picker), `<leader>cd/cl/cp` (quick switch), `<leader>cn/cN` (cycle). Verify persistence across sessions.
- Session: Test auto-save on exit and auto-restore on `nvim` (no args). Test manual controls (`<leader>qs`, `<leader>ql`). Verify nvim-tree doesn't auto-open when session exists.
- Minimap: Test `<leader>MM` (toggle), verify neominimap.nvim integration.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `feat: …`, `fix: …`, `refactor: …`, `chore: …`).
- Commit `lazy-lock.json` when plugin versions change.
- **CRITICAL: Do NOT add yourself as co-author in commits**
  - **NEVER** add `Co-Authored-By:` lines for AI assistants
  - **NEVER** self-identify as an AI agent in commit messages
  - Commits should reflect the actual human author only
- If you modify tool matrices (Mason, Treesitter, Conform, Lint, DAP), note them in the PR.
- PRs should include: summary, validation steps, and screenshots/GIFs for UI changes.
- Always run `stylua lua/` for formatting and use `luacheck lua/` or equivalent static analysis before committing to catch issues early.

## Security & Configuration Tips
- Don't commit secrets (DAP/API keys, tokens). Prefer env vars or local files.
- Use project-local configs where possible (e.g., `.prettierrc`, `pyproject.toml`, `.editorconfig`).
- Python: prefer per-project venvs via `venv-selector.nvim` (`<leader>pv`) over global `python3_host_prog` edits.
- LSP: All server configs use the new `vim.lsp.config()` API (Neovim 0.11+). NEVER set `cmd` or `root_dir` manually (conflicts with Mason). Rust is handled by `rustaceanvim`, not lspconfig.
- Theme: Preference saved to `$XDG_DATA_HOME/theme_config.json`. Clear if experiencing glitches.
- Session: Files stored in `~/.local/state/nvim/sessions/`. Auto-restore only when opening Neovim without arguments.

## Architecture Notes
- **No NvChad**: This config has completely removed all NvChad files and dependencies. Do not reference or recreate NvChad plugins (base46, ui, nvchad.core), directories (lua/configs/, custom/), or patterns (chadrc.lua).
- **Self-Maintained**: All functionality is explicitly configured in `lua/core/` and `lua/plugins/`. No external dependencies on configuration frameworks.
- **Modular Design**: Each plugin is self-contained with its own config, keymaps, and dependencies inlined in the plugin spec.
- **Performance**: lazy.nvim is configured with custom performance settings in `lua/core/lazy.lua`.
- **Startup**: `autocmds.lua` handles VimEnter logic to auto-open nvim-tree for directories/empty buffers (session-aware: won't open if session exists).
- **Theme System**: 21+ themes (10 dark, 10 light, 1 custom txaty). Seamless switching with persistence. Custom txaty theme is low-saturation ergonomic dark (#0f1419) based on research showing too many colors impair code reading.
- **Session Management**: Auto-save on VimLeavePre, auto-restore when opening Neovim without arguments. Per-directory sessions maintain buffers, windows, tabs, and state.
- **LSP Migration**: Migrated from deprecated `require('lspconfig')` to new `vim.lsp.config()` API (Neovim 0.11+). All servers managed through mason-lspconfig handlers.
