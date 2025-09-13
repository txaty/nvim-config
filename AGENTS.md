# Repository Guidelines

## Project Structure & Module Organization
- Root: `init.lua` (NvChad + lazy.nvim bootstrap), `lazy-lock.json` (plugin lockfile), `.stylua.toml` (Lua formatting).
- Core Lua: `lua/`
  - `options.lua`, `mappings.lua`, `chadrc.lua` — editor settings, keymaps, theme/UI.
  - `configs/` — plugin configs (`lspconfig.lua`, `treesitter.lua`, `conform.lua`, `nvimtree.lua`).
  - `plugins/` — split specs by domain (`python.lua`, `web.lua`, `rust.lua`, `git.lua`, `typst.lua`, `tex.lua`, `minimap.lua`).
  - `dap/` — language DAP setups (JS `web.lua`, C/C++ `cpp.lua`, common hooks).
- Spelling: `spell/` for custom dictionaries.

## Build, Test, and Development Commands
- Format Lua: `stylua lua/` (uses `.stylua.toml`).
- Health check: `nvim --headless '+checkhealth' +qa` (reports missing deps).
- Sync plugins: `nvim --headless "+lua require('lazy').sync()" +qa`.
- Update Treesitter parsers: `nvim --headless '+TSUpdateSync' +qa`.
- Optional lint: `luacheck lua` (if installed).
- Verify tooling: inside Neovim run `:Mason`, `:LspInfo`, and exercise sample files.

## Coding Style & Naming Conventions
- Lua: 2-space indent; avoid globals; prefer local helpers.
- Filenames: lowercase snake_case. Specs live in `lua/plugins/`; configs in `lua/configs/`.
- Formatting via `conform.nvim`: JS/TS/HTML/CSS use `prettierd` (fallback `prettier`); Lua uses `stylua`; TeX uses `latexindent`.
- Run `stylua` and validate `conform` runs on save where configured.

## Testing Guidelines
- Manual: launch Neovim, open representative files (py, go, ts, tex, typst) and verify LSP, formatting, and linting.
- Headless: run the health, sync, and Treesitter commands above to catch startup issues.
- DAP: adapters are managed by `mason-nvim-dap`; verify via `:Mason` and a simple launch config.
- Minimap: disabled by default; load on demand with `<leader>mm` or `:Neominimap`.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `feat: …`, `fix: …`, `chore: …`).
- Commit `lazy-lock.json` when plugin versions change.
- If you modify tool matrices (Mason, Treesitter, Conform, Dap), note them in the PR.
- PRs should include: summary, validation steps, and screenshots/GIFs for UI changes.

## Security & Configuration Tips
- Don’t commit secrets (DAP/API keys). Prefer env vars or local files.
- Use project-local configs where possible (e.g., `.prettierrc`, `pyproject.toml`).
- Python: prefer per-project venvs via `venv-selector` (`,v`) over global `python3_host_prog` edits.
