# Repository Guidelines

## Project Structure & Module Organization
- Root: `init.lua` (entry), `lazy-lock.json` (plugin lockfile), `.stylua.toml` (Lua formatting), `.luacheckrc` (Lua linter)
- `lua/config/` — Normalized bootstrap entry modules (compatibility shims):
  - `init.lua`, `options.lua`, `keymaps.lua`, `autocmds.lua`
- `lua/core/` — Fundamental settings and bootstrap:
  - `init.lua` — Loads normalized `config.*` modules, then lazy bootstrap
  - `options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`
  - `lifecycle/` — VimEnter orchestration (colorscheme, session, nvim_tree)
  - `commands/` — User commands (ai, lang, cleanup, ui)
  - `theme.lua`, `theme_txaty.lua` — Theme registry and custom theme
  - `ai_toggle.lua`, `lang_toggle.lua`, `ui_toggle.lua` — Feature toggles
  - `lang_utils.lua`, `lsp_capabilities.lua`, `persist.lua`, `cleanup.lua` (source-of-truth modules)
- `lua/util/` — Shared helper aliases (compatibility shims):
  - `persist.lua`, `lang_utils.lua`, `lsp_capabilities.lua`
- `lua/plugins/` — Self-contained plugin specs with inlined configs:
  - `lsp.lua` — Mason + vim.lsp.config (Neovim 0.11+ API), enables installed servers via `mason-lspconfig.get_installed_servers()`
  - `tools.lua` — conform.nvim + nvim-lint
  - `cmp.lua`, `treesitter.lua`, `ui.lua`, `snacks.lua`, `telescope.lua`
  - `git.lua`, `lazygit.lua`, `remote.lua`, `copilot.lua`, `session.lua`
  - `dap.lua`, `test.lua`, `minimap.lua`
  - `languages/` — python.lua, rust.lua, go.lua, web.lua, flutter.lua
- `lua/dap/` — Language-specific DAP configs
- **Note**: `lua/configs/` and NvChad directories removed. All config inlined in plugin specs.

## Build, Test, and Development Commands
```bash
stylua lua/                                       # Format Lua
luacheck lua/                                     # Lint Lua
nvim --headless '+checkhealth' +qa                # Health check
nvim --headless "+lua require('lazy').sync()" +qa # Sync plugins
nvim --headless '+TSUpdateSync' +qa               # Update Treesitter
```

Inside Neovim: `:Mason`, `:LspInfo`, `:ConformInfo`, `:Lazy profile`

### Feature Toggles
- Theme: `<leader>cc` (picker), `<leader>cd/cl/cp` (dark/light/txaty), `<leader>cn/cN` (cycle)
- AI: `:AIToggle`, `<leader>ai` (requires restart)
- Language: `:LangPanel`, `<leader>Lp` (panel), `<leader>Ls` (status)
- UI: `<leader>u*` (`uw` wrap, `us` spell, `un` numbers, `ur` relative, `uc` conceal)
- Keymaps: conflict audit auto-runs on `VeryLazy`; use `:lua require("core.keymap_audit").full_audit()` for manual checks
- Cleanup: `:CleanupNvim` (manual, auto-runs on startup throttled to 24h)
- Rust: `<leader>R*` (runnables, testables, Cargo.toml via rustaceanvim)
- Crates: `<leader>C*` in Cargo.toml (upgrade, versions, features)

## Coding Style & Naming Conventions
- Lua: 2-space indent; avoid globals; prefer local helpers
- Filenames: lowercase snake_case
- Plugin specs in `lua/plugins/`; inline configs in `opts` or `config` functions
- Formatting via conform.nvim: stylua (Lua), black/isort (Python), goimports/gofmt (Go), rustfmt (Rust), prettier (JS/TS/HTML/CSS)

## Testing Guidelines
- Manual: Open files (py, go, rs, ts, tex, lua), verify LSP (`:LspInfo`), formatting, linting
- Headless: Run health, sync, Treesitter commands
- DAP: Verify via `:Mason`, test breakpoints (`<leader>db`)
- Theme: Test `:ThemeSwitch`, `<leader>cc`, verify persistence
- Session: Test auto-save on exit, auto-restore on `nvim` (no args)
- UI Toggles: Test `<leader>u*`, verify persistence via `:UIStatus`
- Minimap: `<leader>MM` toggle

## Commit & Pull Request Guidelines
- Conventional Commits: `feat:`, `fix:`, `refactor:`, `chore:`
- Commit `lazy-lock.json` when plugins change
- **CRITICAL: Do NOT add yourself as co-author**
  - **NEVER** add `Co-Authored-By:` for AI assistants
  - Commits reflect human author only
- Run `stylua lua/` and `luacheck lua/` before committing

## Security & Configuration Tips
- Don't commit secrets (DAP/API keys). Use env vars or local files.
- Python: Use venv-selector (`<leader>pv`) over global python3_host_prog
- LSP: `vim.lsp.config()` API (Neovim 0.11+). **Never** set `cmd` or `root_dir` (conflicts with Mason). Rust via `rustaceanvim`.
- Theme: Preference in `$XDG_DATA_HOME/theme_config.json`
- Session: Files in `~/.local/state/nvim/sessions/`. Auto-restore only without arguments.

## Architecture Notes
- **No NvChad**: Completely removed. Do not reference or recreate NvChad patterns.
- **Self-Maintained**: All functionality in `lua/core/` and `lua/plugins/`
- **Modular**: Each plugin self-contained with config, keymaps, dependencies inlined
- **Performance**: lazy.nvim with custom settings, disabled runtime plugins, sub-30ms startup
- **Startup**: `lifecycle/init.lua` handles VimEnter (theme → session → UI state → nvim-tree → commands)
- **Theme System**: 50+ themes (25+ dark, 20+ light, 2 custom txaty). Factory pattern for custom theme.
- **Session**: Auto-save on VimLeavePre, auto-restore when opening without arguments
- **LSP Migration**: `vim.lsp.config()` API, Rust via `rustaceanvim`
- **AI Toggle**: Copilot disabled entirely when off, state persisted
- **Language Toggle**: Per-language tooling disable, state persisted
- **Remote**: Distant.nvim for VS Code Remote-like experience
