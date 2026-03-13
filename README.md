# Neovim Configuration

A modern, modular Neovim configuration focusing on **productivity, language support, and explicit trust boundaries**.

## Features

- **Fast Startup**: Lazy-loading plugins for instant startup
- **Full Language Support**: Python, Go, Rust, JavaScript/TypeScript, Flutter, LaTeX, Typst
- **AI Integration**: Copilot with chat interface and inline suggestions (toggleable)
- **Testing**: Integrated test runner (neotest) for multiple languages
- **Debugging**: Debug Adapter Protocol (DAP) support with visual breakpoints
- **Project Navigation**: Snacks picker + nvim-tree for fast file discovery
- **Code Quality**: LSP, linting, and formatting with explicit opt-in automation
- **Git Integration**: Gitsigns hunk operations, diffview, lazygit TUI
- **Remote Development**: VS Code Remote-like experience with distant.nvim
- **Session Management**: Session restore and opt-in persistence
- **50+ Themes**: Dark, light, and custom ergonomic themes with smart switching
- **Modular Language Toggle**: Enable/disable language tooling per-language

## Performance Notes

- Some UI-only plugins load on `BufReadPost` instead of `BufReadPre` so file contents render before decorative integrations attach.
- Inline git blame is off by default to avoid steady cursor-hold git work. Toggle it when needed with `<leader>gB`.
- Fallback word-highlighting caches LSP `documentHighlight` support per buffer to avoid repeated client scans on every `CursorHold`.

## Security Model

This configuration is hardened to prefer explicit trust over convenience.

- No project-local `.nvim.lua` or `.exrc` files are executed.
- Modelines are disabled.
- Automatic plugin bootstrap is disabled.
- Automatic plugin installation and build hooks are restricted.
- Automatic session restore/save is disabled by default.
- Automatic startup cleanup is disabled by default.
- Automatic format-on-save and lint-on-write are disabled by default.
- Automatic LSP startup is disabled by default.
- AI integrations are disabled by default.
- Mutable editor state is written only under Neovim `stdpath("data"|"state"|"cache")` directories.

Opt-in flags for trusted environments:

```lua
vim.g.enable_session_persistence = true
vim.g.enable_auto_cleanup = true
vim.g.enable_lsp_automatic_start = true
vim.g.enable_format_on_save = true
vim.g.enable_lint_on_write = true
```

## Quick Start

### Prerequisites

- Neovim 0.11+ (required for new LSP API)
- Git
- Node.js 18+ (for Copilot)
- Python 3.8+ (for Python support)
- Go 1.19+ (for Go support)
- Rust 1.70+ (for Rust support)
- lazygit (optional, for git TUI)

### Installation

```bash
# Clone configuration
git clone https://github.com/yourusername/nvim ~/.config/nvim

# Install lazy.nvim manually (automatic bootstrap is intentionally disabled)
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
  --branch=stable ~/.local/share/nvim/lazy/lazy.nvim

# Start Neovim, then install plugins explicitly
nvim
# :Lazy sync

# Install language servers and tools explicitly
# :MasonInstallAll
# :Mason
```

### First Run Checklist

After installation, verify everything works:

```bash
# Inside Neovim
:checkhealth           # Run comprehensive health check
:LspInfo               # Verify LSP servers are available
:ConformInfo           # Check formatter configuration
:MasonInstallAll       # Install the curated tool set explicitly
:Mason                 # Inspect/install individual tools
:TSUpdate              # Install/update treesitter parsers explicitly
```

## Usage Guide

### Essential Keybindings

**Press `<leader>` (Space) to see all available keybindings** via which-key popup.

Common workflows:

- **Find files**: `<leader>ff` (Snacks picker)
- **Search text**: `<leader>fg` (Live grep)
- **Rename symbol**: `<leader>lr` (LSP rename)
- **Format code**: `<leader>lf` (manual format)
- **Git stage**: `<leader>gs` (stage hunk)
- **Run tests**: `<leader>tn` (nearest test)
- **Debug**: `<leader>db` (toggle breakpoint)
- **AI Chat**: `<leader>aa` (Copilot)
- **Switch theme**: `<leader>cc` (interactive picker)
- **Remote connect**: `<leader>rc` (distant.nvim)

See **[docs/keymaps.md](docs/keymaps.md)** for complete keybinding reference.

### Language Setup

#### Python

```bash
# 1. Create virtual environment in project
python -m venv .venv

# 2. Inside Neovim, select virtualenv
<leader>pv

# 3. Enable automatic LSP startup in trusted environments or use :LspStart
```

**Recommended tools:** `pyright`, `black`, `isort`, `ruff`

#### Go

Open any `.go` file, then use `:LspStart` or set `vim.g.enable_lsp_automatic_start = true`.

**Recommended tools:** `gopls`, `goimports`, `delve` (debugger)

#### Rust

Install Rust via `rustup`, then open `.rs` file.

**Recommended tools:** `rust-analyzer`, `rustfmt`, `codelldb` (debugger)

**Rust keybindings** (use `<leader>R*` prefix):
```
<leader>Rr    # Runnables
<leader>RR    # Rerun last runnable
<leader>Rt    # Testables
<leader>RT    # Rerun last test
<leader>RD    # Debuggables
<leader>Rd    # Debug target
<leader>Rc    # Open Cargo.toml
```

**Crates keybindings** (in Cargo.toml):
```
<leader>Cv    # Show versions
<leader>Cu    # Upgrade crate
<leader>CA    # Upgrade all crates
```

#### TypeScript/JavaScript

Open `.ts`, `.tsx`, `.js`, `.jsx` files, then use `:LspStart` or enable automatic LSP startup.

**Recommended tools:** `typescript-language-server`, `prettier`, `eslint`

#### Flutter

```bash
# 1. Install Flutter SDK (not via Mason)
flutter --version

# 2. Open .dart file
# 3. Use Flutter keybindings:
<leader>FR    # Run app
<leader>Fr    # Hot restart
<leader>Fl    # Hot reload
```

#### Lua

Write Lua, then use `:LspStart` or enable automatic LSP startup. Formatting uses `stylua`.

### Testing

Run tests with neotest:

```
<leader>tn    # Nearest test
<leader>tf    # All tests in file
<leader>ts    # Entire test suite
<leader>to    # Show output
```

Supported: Python, Go, Rust, JavaScript

### Debugging

Set breakpoints and debug:

```
<leader>db    # Toggle breakpoint
<leader>dc    # Continue / start
<leader>di    # Step into
<leader>do    # Step over
<leader>dO    # Step out
<leader>dx    # Stop debugging
```

Supported: Python, Go, Rust

### Git Workflow

**Stage changes:**
```
<leader>gs    # Stage hunk (or visual selection)
<leader>gS    # Stage entire buffer
<leader>gp    # Preview changes
<leader>gB    # Toggle inline git blame
```

**View history:**
```
<leader>gd    # Diff current file
<leader>gD    # Diff against HEAD
<leader>gdo   # Open Diffview
```

**Launch Git UI:**
```
<leader>gg    # Open lazygit (requires `lazygit` CLI)
```

### AI Assistance (Copilot)

AI integrations are disabled by default. Enable them explicitly for trusted codebases:

```
:AIEnable
# Restart Neovim
```

Chat with Copilot:

```
<leader>aa    # Toggle chat
<leader>aq    # Quick question
<leader>ae    # Explain this code
<leader>at    # Generate tests
<leader>af    # Fix code
<leader>ar    # Review code
```

Inline suggestions appear automatically. Accept with `<M-l>` (Alt+L).

**Toggle AI features** (useful for sensitive codebases):
```
<leader>ai    # Toggle AI on/off (requires restart)
:AIStatus     # Check current state
```

### Remote Development

Connect to remote servers (VS Code Remote-like experience):

```
<leader>rc    # Connect to remote (SSH)
<leader>ro    # Open remote file/directory
<leader>rf    # Find files on remote
<leader>rg    # Live grep on remote
<leader>rd    # Disconnect
```

Remote open/connect/shell mappings validate input and ask for confirmation before launching privileged actions.
Remote LSP still follows the same secure default: use `:LspStart` or opt into automatic startup.

### File Navigation

**Find files:**
```
<leader>ff    # Find by name
<leader>fg    # Search by content
<leader>fb    # Switch buffer
<leader>fr    # Recent files
<leader>fe    # Toggle sidebar
```

Use **Flash** for instant navigation:
```
s             # Press 's' + 2 chars = jump anywhere
S             # Select code block by scope
```

---

## Troubleshooting

### Security Defaults

If you expect old convenience behavior, check these defaults first:

```lua
vim.g.enable_session_persistence = true
vim.g.enable_auto_cleanup = true
vim.g.enable_lsp_automatic_start = true
vim.g.enable_format_on_save = true
vim.g.enable_lint_on_write = true
```

These are intentionally off unless you opt in.

### LSP Not Attaching

**Check status:**
```
:LspInfo          # See active servers for current buffer
:checkhealth      # Full diagnostics
```

**Install missing tools:**
```
:MasonInstallAll  # Install the curated tool set explicitly
:Mason            # Inspect/install individual tools
```

**Common issue:** Python virtualenv not selected
```
<leader>pv        # Select Python virtualenv
```

### Formatter Not Working

**Check configuration:**
```
:ConformInfo      # View formatter setup
```

**Verify tool installed:**
```
:Mason            # Search for formatter (e.g., "black", "prettier")
```

**Manual format:**
```
<leader>lf        # Format current file
```

### Copilot Not Working

**Verify authentication:**
```
:Copilot setup
```

**Check status:**
```
:Copilot status
```

**Requirements:**
- Node.js 18+ installed
- GitHub account with Copilot subscription

### Plugin Installation Failed

**Resync plugins:**
```
:Lazy sync
:TSUpdate
```

**Resolve conflicts:**
```
:Lazy clean       # Remove unused plugins
:Lazy restore     # Restore to last known good state
```

### Slow Performance

**Profile startup:**
```
:Lazy profile     # Shows slowest plugins
```

**Check health:**
```
:checkhealth      # Look for warnings/errors
```

**Reduce plugins:** Edit `lua/plugins/` to disable unused plugins.

### DAP (Debugging) Not Working

**Check adapter installed:**
```
:Mason            # Search for debugger (e.g., "python-debugpy", "delve", "codelldb")
```

**Set breakpoint and debug:**
```
<leader>db        # Toggle breakpoint
<leader>dc        # Start debugging
```

**View logs:**
```
:DapShowLog
```

### Git Commands Not Available

**Install lazygit (optional, for git UI):**
```bash
# macOS
brew install lazygit

# Linux
sudo apt install lazygit

# Or download from https://github.com/jesseduffield/lazygit/releases
```

### Treesitter Parser Missing

**Update all parsers:**
```
:TSUpdate
```

**Or in shell:**
```bash
nvim --headless '+TSUpdateSync' +qa
```

### Security Re-Audit After Plugin Updates

After changing plugin specs or updating plugins, re-check these areas:

1. Search for new external execution paths:
   `rg -n "(vim\\.system|system\\(|jobstart|termopen|build\\s*=|run\\s*=|post_install|autocmd)" lua`
2. Search for filesystem writes and deletes:
   `rg -n "(writefile|fs_open\\(|fs_write\\(|delete\\()" lua`
3. Search for new network/bootstrap behavior:
   `rg -n "(git clone|checker|update\\(|MasonInstall|DistantInstall|Copilot|Octo)" lua`
4. Review `lazy-lock.json` for newly added plugins and branch-based dependencies.

## Shared Machine / Server Guidance

- Keep AI disabled unless the host and codebase are explicitly trusted.
- Leave automatic session restore/save disabled on shared hosts.
- Leave automatic cleanup disabled unless you are comfortable with Neovim pruning its own state directories.
- Prefer manual `:LspStart`, `:Mason`, `:Lazy sync`, and `:TSUpdate`.
- Treat remote development commands and external viewers as privileged actions; this config asks for confirmation before launching them from keymaps.

---

## Configuration

### Change Keybindings

Edit `lua/core/keymaps.lua`:

```lua
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
```

### Enable/Disable Plugins

Each plugin file in `lua/plugins/` can be edited or removed:

```lua
-- Disable plugin by returning empty table
return {}

-- Or set enabled = false
{ "plugin-name", enabled = false }
```

### Enable/Disable Language Support

Toggle entire language toolchains (LSP, formatter, linter, treesitter):

```
<leader>Lp          # Open language support panel (Telescope)
<leader>Ls          # Show status of all languages
:LangToggle python  # Toggle Python support
:LangEnable rust    # Enable Rust support
:LangDisable web    # Disable Web (JS/TS) support
```

**Inside Language Panel:**
- `e` - Enable selected language
- `d` - Disable selected language
- `<CR>` - Toggle selected language

Supported: `python`, `rust`, `go`, `web` (JS/TS), `flutter`, `latex`, `typst`

Changes require Neovim restart to take effect. State persisted across sessions.

### Change Colorscheme

**Interactive switching (recommended):**
```
<leader>cc    # Open interactive theme picker
<leader>cd    # Switch to last-used dark theme
<leader>cl    # Switch to last-used light theme
<leader>cp    # Switch to txaty custom theme
<leader>cn    # Cycle to next theme
<leader>cN    # Cycle to previous theme
```

**50+ themes available:**
- **Dark (25+):** tokyonight, kanagawa, catppuccin, rose-pine, nightfox, onedark, cyberdream, gruvbox, nord, dracula, github_dark variants, everforest, material, vscode, and more
- **Light (20+):** tokyonight-day, rose-pine-dawn, kanagawa-lotus, onelight, ayu-light, papercolor, github_light variants, and more
- **Custom:** txaty (ergonomic dark), txaty-light (ergonomic light)

Theme preference is automatically saved and restored on next startup.

### Add Language Support

Create file `lua/plugins/mylang.lua`:

```lua
return {
  { "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "mylang" })
    end,
  },
  { "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "mylang-lsp")
    end,
  },
}
```

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/               # Fundamental settings
│   │   ├── init.lua         # Bootstrap loader
│   │   ├── options.lua      # Vim options
│   │   ├── keymaps.lua      # Global keybindings
│   │   ├── autocmds.lua     # Core autocommands (lifecycle handled by lifecycle/)
│   │   ├── lazy.lua         # Lazy.nvim bootstrap
│   │   ├── theme.lua        # Theme registry (50+ themes)
│   │   ├── theme_txaty.lua  # Custom ergonomic theme
│   │   ├── ai_toggle.lua    # AI features toggle
│   │   ├── lang_toggle.lua  # Language support toggle
│   │   ├── lang_utils.lua   # Language utilities
│   │   ├── buffers.lua      # Buffer close/management
│   │   ├── cleanup.lua      # Automatic temp file cleanup
│   │   ├── ui_toggle.lua    # UI toggle persistence
│   │   ├── lifecycle/       # VimEnter orchestration
│   │   │   ├── init.lua     # Lifecycle orchestrator
│   │   │   ├── colorscheme.lua
│   │   │   ├── session.lua
│   │   │   ├── reconcile.lua
│   │   │   └── nvim_tree.lua
│   │   └── commands/        # User command definitions
│   │       ├── init.lua     # Command registry
│   │       ├── ai.lua
│   │       ├── lang.lua
│   │       ├── cleanup.lua
│   │       └── ui.lua
│   └── plugins/            # Plugin specifications
│       ├── lsp.lua          # LSP + Mason
│       ├── colorscheme.lua  # 40+ theme plugins
│       ├── theme_switcher.lua
│       ├── copilot.lua      # AI (respects toggle)
│       ├── remote.lua       # Remote development
│       └── languages/       # Language-specific
│           ├── python.lua
│           ├── go.lua
│           ├── rust.lua
│           ├── flutter.lua
│           └── web.lua
├── lua/dap/                # Debug configurations
├── docs/
│   └── keymaps.md          # Keybinding reference
├── lazy-lock.json          # Plugin versions (auto-updated)
└── README.md               # This file
```

---

## Updates & Maintenance

### Update Plugins

```
:Lazy sync        # Inside Neovim
```

Or from shell:

```bash
nvim --headless "+lua require('lazy').sync()" +qa
```

### Update Treesitter Parsers

```
:TSUpdate         # Inside Neovim
```

Or from shell:

```bash
nvim --headless '+TSUpdateSync' +qa
```

### Check Configuration Health

```bash
nvim --headless '+checkhealth' +qa
```

---

## Performance Tips

1. **Use relative line numbers**: `<leader>ur` for vim motion speed
2. **Lazy-load plugins**: All plugins load only when needed
3. **Use Flash navigation**: `s` key is faster than j/k movement
4. **Incremental search**: `<leader>fg` for live preview
5. **Session management**: `<leader>qs` to restore the current directory session

---

## Getting Help

- **Documentation**: See `docs/keymaps.md` for full reference
- **In-editor help**: Press `<leader>` to see available commands
- **Health check**: Run `:checkhealth` in Neovim
- **Configuration**: See `CLAUDE.md` for architecture details

---

## License

This configuration is a personal project. Feel free to fork and customize for your needs.

---

## Credits

Based on modular Neovim best practices. Inspired by:
- [LazyVim](https://www.lazyvim.org/)
- [nvim-lua](https://github.com/nvim-lua/kickstart.nvim)
- Community configurations
