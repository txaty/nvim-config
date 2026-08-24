# Gemini Context for Neovim Configuration

## Project Overview
Custom, self-maintained Neovim configuration using `lazy.nvim` for plugins and `mason.nvim` for tooling (LSP, DAP, linters, formatters). Written in Lua with modular `lua/core/` + `lua/plugins/` architecture.

**Important**: Completely removed all NvChad files and dependencies. Fully independent configuration.

## Key Technologies
- **Core**: Neovim (Lua), `lazy.nvim`, `mason.nvim`
- **LSP**: `vim.lsp.config` (new Neovim 0.11+ API)
- **Formatting**: `conform.nvim` (stylua, black, isort, goimports, rustfmt, prettier)
- **Linting**: `nvim-lint`
- **Completion**: `blink.cmp`
- **Syntax**: `nvim-treesitter`
- **Fuzzy Finder**: `snacks.nvim` (primary), `telescope.nvim` (fallback)
- **Git**: `gitsigns.nvim`, `lazygit.nvim`
- **AI**: `copilot.lua` + `CopilotChat.nvim`
- **UI**: `noice.nvim`, `lualine.nvim`, `bufferline.nvim`, `nvim-tree.lua`
- **Navigation**: `flash.nvim`
- **Session**: `persistence.nvim`
- **Remote**: `distant.nvim`
- **Themes**: 78 themes (50 dark, 26 light, 2 custom txaty)

## Directory Structure
- `init.lua` — Entry point, loads `lua/core/init.lua`
- `lazy-lock.json` — Plugin version lockfile
- `.stylua.toml` — Lua formatter (120 column, 2-space indent)
- `.luacheckrc` — Lua linter (Lua 5.1, vim globals)
- `lua/core/` — Core settings and bootstrap
  - `init.lua`, `options.lua`, `keymaps.lua`, `lazy.lua`
  - `autocmds/` — Core autocmds by concern (filetype, cursor, word_highlight, persistence, ui_state, images)
  - `lifecycle/` — VimEnter orchestration via declarative `steps` table (colorscheme, session, nvim_tree, reconcile)
  - `commands/` — User commands (ai, lang, cleanup, ui, session, theme)
  - `ui/` — Config-owned UI that owns no plugin (`theme_picker.lua`, `lang_panel.lua`)
  - `theme.lua` — Theme registry (`get_themes()`, `get_theme_info()`, `get_registry_entry(name)`)
  - `theme_txaty.lua` + `theme_txaty_colors.lua` + `theme_txaty_highlights.lua` — Custom theme split: entry / palette / highlight groups
  - `ai_toggle.lua`, `session_toggle.lua`, `lang_toggle.lua`, `ui_toggle.lua` — Feature toggles
  - `persist_flag.lua` — Factory behind the persisted boolean toggles
  - `lang_utils.lua`, `lsp_capabilities.lua`, `persist.lua` — Source-of-truth shared utilities
  - `cleanup.lua` — Automatic cleanup
- `lua/plugins/` — Self-contained plugin specs. `import` is NOT recursive:
  `core/lazy.lua` lists `plugins` and `plugins.languages` explicitly, and a new
  subdirectory needs its own entry or is silently ignored.
  - `lsp.lua`, `tools.lua`, `cmp.lua`, `treesitter.lua`
  - `ui.lua`, `snacks.lua`, `telescope.lua`
  - `git.lua`, `lazygit.lua`, `remote.lua`
  - `copilot.lua`, `session.lua`, `dap.lua`, `test.lua`
  - `languages/` — python.lua, rust.lua, go.lua, web.lua, flutter.lua
- `lua/dap_configs/` — Language-specific DAP configs (not `lua/dap/`, which collides with nvim-dap's require namespace)
- `docs/` — User documentation (keymaps.md)

## Commands
```bash
nvim                                              # Start
nvim --headless "+lua require('lazy').sync()" +qa # Sync plugins
nvim --headless '+TSUpdateSync' +qa               # Update Treesitter
nvim --headless '+checkhealth' +qa                # Health check
stylua lua/                                       # Format Lua
luacheck lua/                                     # Lint Lua
```

## Key Features & Workflows

### LSP
- Uses new `vim.lsp.config()` API (Neovim 0.11+)
- Key mappings: `gd` (definition), `gr` (references), `K` (hover), `<leader>la` (code action), `<leader>lf` (format)
- Installed servers are enabled from `mason-lspconfig.get_installed_servers()` after all `vim.lsp.config()` calls
- **CRITICAL**: Never set `cmd` or `root_dir` manually. Rust handled by `rustaceanvim`.

### Navigation & UI
- Flash: `s` (jump), `S` (Treesitter select)
- Snacks picker: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers)
- File Explorer: `<C-n>` (nvim-tree)
- Bufferline: `<Tab>`/`<S-Tab>` (navigate), `<leader>bd` (close)

### Theme System (`<leader>c*`)
- `<leader>cc` — Interactive picker
- `<leader>cd/cl/cp` — Dark/light/txaty
- `<leader>cn/cN` — Cycle themes
- 78 themes, preference saved to `$XDG_DATA_HOME/theme_config.json`

### AI (`<leader>a*`)
- `<leader>ai` — Toggle AI (requires restart)
- `<leader>aa` — Toggle chat
- `<leader>aq/ae/at/af/ar` — Quick question/explain/tests/fix/review
- Copilot: `<M-l>` (accept)

### Session Management
- Auto save/restore defaults to **enabled**, persisted in `$XDG_DATA_HOME/nvim/session_config.json`
- Toggle with `:SessionToggle` / `<leader>qp` (mirrored into `vim.g.enable_session_persistence`)
- Manual, independent of the toggle: `<leader>qs` (restore current-dir session), `<leader>ql` (load last), `<leader>qS` (select)

### Language Toggle
- `<leader>Lp` or `:LangPanel` — Telescope panel
- Supported: python, rust, go, web, flutter, latex, typst
- State saved to `$XDG_DATA_HOME/language_config.json`

### UI Toggles (`<leader>u*`)
- `<leader>uw` (wrap), `<leader>us` (spell), `<leader>un` (numbers), `<leader>ur` (relative), `<leader>uc` (conceal), `<leader>uD` (inline diagnostics)

### Remote Development (`<leader>r*`)
- `<leader>rc` (connect, validated + confirmed), `<leader>rd` (disconnect), `<leader>ro` (open, validated + confirmed)
- `<leader>rf` (find files), `<leader>rg` (grep)

### Rust (`<leader>R*`)
- `<leader>Rr` (runnables), `<leader>Rt` (testables), `<leader>Rc` (Cargo.toml)
- Uses rustaceanvim `:RustLsp` commands

### Crates (`<leader>C*` in Cargo.toml)
- `<leader>Cu` (upgrade), `<leader>Cv` (versions), `<leader>Cf` (features)

## Configuration Pattern
- **Plugin Specs**: Self-contained in `lua/plugins/*.lua` with lazy-loading triggers
- **Inline Configs**: Use `opts` or `config` fields directly
- **LSP**: `vim.lsp.config()` then enable installed servers via `mason-lspconfig.get_installed_servers()`
- **Keymaps**: General in `lua/core/keymaps.lua`, LSP in LspAttach autocmd, plugin-specific in spec

## Testing
- Verify LSP: `:LspInfo`
- Verify formatting: on save or `<leader>lf`
- Verify completion: `<C-Space>`
- Verify theme: `:ThemeSwitch`, `<leader>cc`
- Verify session restore only after enabling persistence
- Headless: `nvim --headless '+checkhealth' +qa`

## Commit Guidelines
- Conventional Commits: `feat:`, `fix:`, `refactor:`, `chore:`
- Commit `lazy-lock.json` when plugins change
- **CRITICAL: Do NOT add yourself as co-author**
- Run `stylua lua/` and `luacheck lua/` before committing

## Architecture Notes
- **Comment non-obvious implementations**: When a change resolves a compatibility issue, plugin API migration, version-specific behavior, or any non-obvious problem, add a comment at the implementation site explaining (1) what problem it solves, (2) why this approach was chosen, and (3) version constraints or what breaks if reverted. Omit where intent is self-evident.
- **No NvChad**: Do not reference or recreate NvChad patterns
- **Self-Maintained**: All core settings in `lua/core/`, no framework dependencies
- **Modular**: Each plugin self-contained with lazy-loading
- **Performance**: Custom lazy.nvim settings, disabled runtime plugins
- **LSP Migration**: `vim.lsp.config()` API (Neovim 0.11+), Rust via `rustaceanvim`
- **AI Toggle**: Copilot plugins disabled entirely when off, state persisted
- **Language Toggle**: Per-language tooling disable, state persisted
- **Session**: Restore/save logic exists, but persistence is opt-in
