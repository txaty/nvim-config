# Changelog

All notable user-facing changes to this Neovim configuration are documented
here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

Entries are written for humans — read them for *what changed and why it
matters*, not for a reproduction of the git history. For the full commit-level
record, use `git log`.

## [Unreleased]

### Added

- The custom **txaty** theme is now split into three focused files so that
  editing colors no longer means scrolling past a thousand highlight rules.
  Edit `lua/core/theme_txaty_colors.lua` to tune palette hex values, and
  `lua/core/theme_txaty_highlights.lua` to adjust highlight group
  assignments. The public API (`apply(variant)`, `get_palette(variant)`) is
  unchanged.
- The theme registry exposes two explicit accessors — `get_themes()` and
  `get_theme_info()` — with clear lazy initialization. The existing
  `M.themes` and `M.theme_info` field access still works for backward
  compatibility, so no call sites need updating.

### Changed

- The VimEnter lifecycle is now driven by a declarative `steps` table in
  `lua/core/lifecycle/init.lua`. Each step declares its timing mode
  (immediate, scheduled, very-lazy, or deferred) and any gating conditions
  in one place, instead of being woven through imperative control flow.
  Adding or removing a startup step is now a one-line change to the table.
  Observable behavior is identical to before.

### Fixed

- Corrupted JSON configuration files (for example, a partially written
  `ui_config.json` after a crash) now produce a visible warning instead of
  silently reverting to defaults — the user sees why settings aren't being
  remembered.
- File-cleanup failures during `:CleanupNvim` and startup cleanup are now
  accumulated and reported. Previously a permission error on a single log
  file would be swallowed with no indication; now the failure count and
  details surface through `vim.notify`.
- The `LangPanel` UI is noticeably snappier on repeat opens because the
  language-enabled state is cached in memory instead of being re-read from
  disk on every per-language query.

---

## 2026-04-12

Documented here as the prior stable snapshot before the unreleased work
above. Dates reflect when the work landed on `main`.

### Added

- Automatic `lazy.nvim` bootstrap on first run, with explicit user opt-in
  so nothing is fetched silently.
- `snacks.bufdelete` integration and `scope.nvim` for tab-scoped buffers.
- Multicursor support and a more informative diagnostics UI.
- Breadcrumb navigation via `dropbar.nvim` (replacing `nvim-navic`), plus
  several LSP and UI quality-of-life plugins.

### Changed

- UI and DAP plugin surface area consolidated; a handful of redundant
  plugins were removed.
- Autocmd bootstrap split into focused modules under `core/autocmds/`,
  one per concern (filetype, cursor, word highlighting, persistence, UI
  state) — easier to read and reason about.
- Shell configuration simplified to read the `SHELL` environment variable
  directly rather than maintaining its own mapping.
- Cursor animation responsiveness increased; inline git blame is now off
  by default to avoid steady cursor-hold work, and can be re-enabled with
  `<leader>gB`.
- Fallback word-highlighting now caches LSP `documentHighlight` support
  per buffer, avoiding repeated client scans on every `CursorHold`.
- The `diffview` file panel now uses a list-style layout.

### Fixed

- Treesitter now tracks its `main` branch. The old `master` branch ships a
  `query_predicates.lua` that's incompatible with Neovim 0.12's match
  table format (arrays of nodes instead of single nodes) and produced
  cryptic `conceal_line` errors. The `main` branch removes that file and
  resolves the crash. **Requires Neovim 0.11+; 0.12 recommended.**

### Security

- Hardened Neovim startup defaults: `modeline=false`, `exrc=false`,
  `secure=true`, shell pinned to an explicit binary path, and legacy
  surfaces (`netrw`, `rplugin`, `spellfile`, `editorconfig`) disabled.
  Automatic behaviors that previously ran silently at startup — session
  restore, cleanup, LSP startup, format-on-save, lint-on-write, AI
  integrations — are now off by default and require an explicit opt-in
  via `vim.g.enable_*` flags. See README.md for the full list.

---

## Migration notes

### Editing the custom txaty theme

Colors and highlight group definitions now live in separate files. The
entry point (`theme_txaty.lua`) and its public API are unchanged, so
existing callers don't need any updates.

| You want to change | Edit this file |
| --- | --- |
| A palette color (hex value) | `lua/core/theme_txaty_colors.lua` |
| A highlight group assignment | `lua/core/theme_txaty_highlights.lua` |
| How the theme is wired up | `lua/core/theme_txaty.lua` |

### Adding a startup step

Open `lua/core/lifecycle/init.lua` and add an entry to the `steps` table.
The table is processed in order; each entry looks like:

```lua
{
  name = "my_step",
  mode = "deferred",       -- "sync" | "scheduled" | "very_lazy" | "deferred"
  delay_ms = 500,          -- only meaningful when mode = "deferred"
  condition = function() return vim.g.my_feature end,  -- optional gate
  needs_session = false,   -- optional: skip when no session was restored
  fn = function(ctx) ... end,
}
```

There is no imperative `run_sequence()` wiring to update.

### Reading theme lists programmatically

Both forms are supported; the explicit accessor is preferred for new
code because it's self-documenting:

```lua
-- Preferred
require("core.theme").get_themes().dark
require("core.theme").get_theme_info()["kanagawa"]

-- Still works (backward compatible)
require("core.theme").themes.dark
```

### Restoring pre-hardening behavior

If you're on a trusted personal machine and want the old convenience
defaults (automatic session restore, automatic cleanup, automatic LSP
startup, format-on-save, lint-on-write, AI), set the corresponding
`vim.g.enable_*` flags in your local init — see the Security Model
section of README.md for the full list.
