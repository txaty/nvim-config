# Repository Guidelines

## Project Structure & Module Organization
- Root: `init.lua` (core loader), `lazy-lock.json` (plugin lockfile), `.stylua.toml` (Lua formatting).
- Core Lua: `lua/`
  - `core/` — fundamental Neovim settings and bootstrap:
    - `init.lua` — loads all core modules in sequence.
    - `options.lua` — vim options (vim.opt) and sane defaults.
    - `keymaps.lua` — general keybindings and navigation.
    - `autocmds.lua` — event-driven logic (restore cursor position, view saving, auto-open nvim-tree).
    - `lazy.lua` — lazy.nvim bootstrap with custom performance settings.
  - `plugins/` — modular plugin specs with inlined configurations:
    - `init.lua` — core plugins (telescope, which-key, git).
    - `lsp.lua` — Mason + nvim-lspconfig with LspAttach autocmd.
    - `formatting.lua` — conform.nvim setup.
    - `linting.lua` — nvim-lint configuration.
    - `cmp.lua` — nvim-cmp completion setup.
    - `treesitter.lua` — syntax highlighting and parsing.
    - `ui.lua` — nvim-tree, lualine, bufferline.
    - `colorscheme.lua` — theme options (Catppuccin, Tokyonight, Kanagawa, etc.).
    - `session.lua` — persistence.nvim for VS Code-like session restoration.
    - `noice.lua`, `flash.lua`, `trouble.lua`, `todo.lua`, `spectre.lua` — UI/UX enhancements.
    - `copilot.lua` — GitHub Copilot integration.
    - `dap.lua` — debug adapter protocol setup.
    - Language-specific: `python.lua`, `go.lua`, `rust.lua`, `flutter.lua`, `web.lua`, `tex.lua`, `typst.lua`, `minimap.lua`.
  - `dap/` — language-specific DAP configurations (`web.lua`, `cpp.lua`).
- **Note**: `lua/configs/` and other NvChad directories have been completely removed. All configuration is inlined into plugin specs.

## Build, Test, and Development Commands
- Format Lua: `stylua lua/` (uses `.stylua.toml`).
- Health check: `nvim --headless '+checkhealth' +qa` (reports missing deps).
- Sync plugins: `nvim --headless "+lua require('lazy').sync()" +qa`.
- Update Treesitter parsers: `nvim --headless '+TSUpdateSync' +qa`.
- Optional lint: `luacheck lua` (if installed).
- Verify tooling: inside Neovim run `:Mason`, `:LspInfo`, and test with sample files.

## Coding Style & Naming Conventions
- Lua: 2-space indent; avoid globals; prefer local helpers.
- Filenames: lowercase snake_case. Plugin specs live in `lua/plugins/`; inline configs directly in plugin `config` or `opts` functions.
- Formatting via `conform.nvim`: JS/TS/HTML/CSS use `prettierd` (fallback `prettier`); Lua uses `stylua`; Python uses `black`/`isort`; Go uses `goimports`/`gofmt`; Rust uses `rustfmt`; TeX uses `latexindent`.
- Run `stylua` and validate `conform` runs on save where configured.
- All plugin configuration must be inlined into plugin specs - never create separate config files.

## Testing Guidelines
- Manual: launch Neovim, open representative files (py, go, ts, tex, typst, lua) and verify LSP (`:LspInfo`), formatting (on save or `<leader>lf`), and linting.
- Headless: run the health, sync, and Treesitter commands above to catch startup issues.
- DAP: adapters are managed by `mason-nvim-dap`; verify via `:Mason` and test with sample launch configs.
- UI: Test lualine, bufferline, nvim-tree, and theme switching.
- Session: Test session save (`<leader>qs`) and load (`<leader>ql`) with persistence.nvim.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `feat: …`, `fix: …`, `refactor: …`, `chore: …`).
- Commit `lazy-lock.json` when plugin versions change.
- If you modify tool matrices (Mason, Treesitter, Conform, Lint, DAP), note them in the PR.
- PRs should include: summary, validation steps, and screenshots/GIFs for UI changes.
- End commit messages with `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>` when applicable.

## Security & Configuration Tips
- Don't commit secrets (DAP/API keys, tokens). Prefer env vars or local files.
- Use project-local configs where possible (e.g., `.prettierrc`, `pyproject.toml`, `.editorconfig`).
- Python: prefer per-project venvs via `venv-selector.nvim` over global `python3_host_prog` edits.
- LSP: All server configs should go through mason-lspconfig handlers in `lua/plugins/lsp.lua`.

## Architecture Notes
- **No NvChad**: This config has completely removed all NvChad files and dependencies. Do not reference or recreate NvChad plugins (base46, ui, nvchad.core), directories (lua/configs/, custom/), or patterns (chadrc.lua).
- **Self-Maintained**: All functionality is explicitly configured in `lua/core/` and `lua/plugins/`. No external dependencies on configuration frameworks.
- **Modular Design**: Each plugin is self-contained with its own config, keymaps, and dependencies inlined in the plugin spec.
- **Performance**: lazy.nvim is configured with custom performance settings in `lua/core/lazy.lua`.
- **Startup**: `autocmds.lua` handles VimEnter logic to auto-open nvim-tree for directories/empty buffers.
