# Neovim Keybindings Reference

`<leader>` is **Space**. All mappings are organized by intent and mnemonic namespace for quick discovery via `which-key`.

---

## Quick Reference Table

| Namespace | Purpose | Example |
|-----------|---------|---------|
| `<leader>a*` | **AI & Copilot** | `<leader>ai` = toggle AI, `<leader>aa` = chat |
| `<leader>b*` | **Buffers** | `<leader>bd` = delete buffer |
| `<leader>c*` | **Color/Colorscheme** | `<leader>cc` = choose theme (50+) |
| `<leader>d*` | **Debug** (DAP) | `<leader>db` = toggle breakpoint |
| `<leader>f*` | **Files & Finding** | `<leader>ff` = find files |
| `<leader>F*` | **Flutter** (language) | `<leader>FR` = run Flutter app |
| `<leader>g*` | **Git** | `<leader>gs` = stage hunk |
| `<leader>l*` | **LSP & Language** | `<leader>lr` = rename symbol |
| `<leader>L*` | **Language Support** | `<leader>Lp` = toggle language panel |
| `<leader>m*` | **Bookmarks & Markdown** | `<leader>ma` = toggle bookmark, `<leader>mo` = open in Typora |
| `<leader>M*` | **Minimap** | `<leader>MM` = toggle minimap |
| `<leader>n*` | **Notifications** | `<leader>nl` = show last message |
| `<leader>p*` | **Python** (venv) | `<leader>pv` = select virtualenv |
| `<leader>q*` | **Quit/Session** | `<leader>qq` = quit window |
| `<leader>r*` | **Remote Development** | `<leader>rc` = connect to server |
| `<leader>R*` | **Rust** (language) | `<leader>Rr` = run, `<leader>Rc` = check |
| `<leader>C*` | **Crates** (Cargo.toml) | `<leader>Cu` = upgrade crate |
| `<leader>s*` | **Search & Replace** | `<leader>S` = Spectre search/replace |
| `<leader>S*` | **Spectre** | `<leader>sw` = search current word |
| `<leader>t*` | **Testing** | `<leader>tn` = run nearest test |
| `<leader>u*` | **UI/Display** | `<leader>uw` = toggle wrap |
| `<leader>w*` | **Windows** | `<leader>ws` = horizontal split |
| `<leader>x*` | **Diagnostics** | `<leader>xx` = toggle diagnostics |

---

## Essential Keybindings

| Keybinding | Description |
|---|---|
| `jk` (insert) | Exit insert mode |
| `<C-a>` | Select entire buffer |
| `<C-s>` | Save file |
| `<C-c>` | Copy entire file to clipboard |
| `;` | Enter command mode (alternative to `:`) |
| `<Esc>` | Clear search highlights |

---

## Insert Mode Navigation

| Keybinding | Description |
|---|---|
| `<C-b>` | Move to beginning of line |
| `<C-e>` | Move to end of line |
| `<C-h>` | Move left |
| `<C-l>` | Move right |
| `<C-j>` | Move down |
| `<C-k>` | Move up |

---

## Files & Finding (`<leader>f*`)

### Telescope Integration
| Keybinding | Description |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep / search text |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files / oldfiles |
| `<leader>fh` | Help tags |
| `<leader>ft` | Find todos |

### File Explorer
| Keybinding | Description |
|---|---|
| `<leader>fe` | Toggle NvimTree file explorer |
| `<C-n>` | Toggle NvimTree file explorer (alternative) |

### File Operations
| Keybinding | Description |
|---|---|
| `<leader>fs` | Save file |

---

## Remote Development (`<leader>r*`)

**Distant.nvim - Remote development like VS Code Remote**

### Connection Management
| Keybinding | Description |
|---|---|
| `<leader>rc` | Connect to remote server via SSH |
| `<leader>rd` | Disconnect from remote server |
| `<leader>ro` | Open remote directory/file |
| `<leader>rs` | Show remote system info |
| `<leader>rS` | Open shell on remote server |

### Remote File Operations
| Keybinding | Description |
|---|---|
| `<leader>rf` | Find files on remote (Telescope) |
| `<leader>rg` | Live grep on remote (Telescope) |

**How it works:**
- Neovim runs locally, but files, LSP, and formatters execute on the remote server
- Supports SSH connections with compression for better performance
- Automatic LSP attachment when opening remote files
- Remote connection status shown in lualine statusline (󰢹 indicator)
- All file operations work transparently with remote paths

**Usage example:**
1. Press `<leader>rc` → enter SSH connection string (e.g., `ssh://user@hostname`)
2. Press `<leader>ro` → open remote directory
3. Use `<leader>rf` and `<leader>rg` to navigate remote files
4. Edit files normally - LSP, formatting, and all features work on remote

---

## Buffers (`<leader>b*`)

| Keybinding | Description |
|---|---|
| `<TAB>` | Next buffer |
| `<S-TAB>` | Previous buffer |
| `<leader>bd` | Delete/close buffer |

---

## Windows (`<leader>w*`)

| Keybinding | Description |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Navigate to window (left/down/up/right) |
| `<leader>ws` | Split window horizontally |
| `<leader>wv` | Split window vertically |
| `<leader>wa` | Add workspace folder (LSP) |
| `<leader>wr` | Remove workspace folder (LSP) |
| `<leader>wl` | List workspace folders (LSP) |

---

## LSP & Language Server (`<leader>l*`)

### Navigation
| Keybinding | Description |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover documentation |

### LSP Operations
| Keybinding | Description |
|---|---|
| `<leader>lr` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>lf` | Format document (via conform) |
| `<leader>lF` | Format injected languages |
| `<leader>ls` | Show signature help |
| `<leader>D` | Go to type definition |

### Diagnostics
| Keybinding | Description |
|---|---|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>ld` | Show diagnostics in floating window |

### Tools
| Keybinding | Description |
|---|---|
| `<leader>lm` | Open Mason (tool manager) |

---

## AI & Copilot (`<leader>a*`)

### AI Features Toggle
| Keybinding | Description |
|---|---|
| `<leader>ai` | Toggle AI features on/off (requires restart) |

**Commands:**
- `:AIToggle` — Toggle AI features
- `:AIEnable` — Enable AI features
- `:AIDisable` — Disable AI features
- `:AIStatus` — Show current AI status

**Note:** When AI is disabled, Copilot plugins are never loaded (improves performance). Useful for sensitive codebases or when using external AI tools like Claude Code.

### Copilot Chat
| Keybinding | Description |
|---|---|
| `<leader>aa` | Toggle Copilot Chat window |
| `<leader>aq` | Quick chat with Copilot |
| `<leader>ae` | Explain code using Copilot |
| `<leader>at` | Generate tests using Copilot |
| `<leader>af` | Fix code using Copilot |
| `<leader>ar` | Review code using Copilot |

### Copilot Inline Suggestions (Insert Mode)
| Keybinding | Description |
|---|---|
| `<M-l>` (Alt+L) | Accept suggestion |
| `<C-]>` | Dismiss suggestion |
| `<M-[>` | Previous suggestion |
| `<M-]>` | Next suggestion |

### Copilot Panel (Insert Mode)
| Keybinding | Description |
|---|---|
| `<M-CR>` | Open Copilot panel |
| `[[` | Jump to previous suggestion (in panel) |
| `]]` | Jump to next suggestion (in panel) |
| `<CR>` | Accept suggestion (in panel) |
| `gr` | Refresh suggestions |

---

## Flutter (`<leader>F*`)

**Note:** Only available in `.dart` files

| Keybinding | Description |
|---|---|
| `<leader>FR` | Run Flutter app |
| `<leader>Fq` | Quit running app |
| `<leader>Fr` | Hot restart app |
| `<leader>Fl` | Hot reload app |
| `<leader>Fd` | Select device |
| `<leader>Fe` | Launch emulator |
| `<leader>Fo` | Toggle widget outline |
| `<leader>FL` | Toggle dev logs |

---

## Rust (`<leader>R*`)

**Note:** Only available in `.rs` (Rust) files. Uses capital `R` to avoid conflict with Remote (`<leader>r*`).

### Build & Run
| Keybinding | Description |
|---|---|
| `<leader>Rr` | Run Rust project |
| `<leader>RR` | Run Rust project (release mode) |
| `<leader>Rt` | Run tests |
| `<leader>RT` | Run tests (release mode) |
| `<leader>Rc` | Check project (cargo check) |
| `<leader>Rb` | Build project (cargo build) |

### Debugging & Analysis
| Keybinding | Description |
|---|---|
| `<leader>Ra` | Expand macro at cursor |
| `<leader>Rx` | Explain error under cursor |
| `<leader>RD` | Show debuggables picker |
| `<leader>RH` | Hover action |
| `<leader>Rl` | Run clippy (lint) |
| `<leader>Rd` | Toggle inlay hints |

---

## Crates (`<leader>C*`)

**Note:** Only available in `Cargo.toml` files.

| Keybinding | Description |
|---|---|
| `<leader>Cv` | Show versions popup |
| `<leader>Cf` | Show features popup |
| `<leader>Cd` | Show dependencies popup |
| `<leader>Cu` | Upgrade crate under cursor |
| `<leader>CA` | Upgrade all crates |

---

## Git (`<leader>g*`)

### Gitsigns (Hunk Operations)
| Keybinding | Description |
|---|---|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage entire buffer |
| `<leader>gR` | Reset entire buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line (show author/date) |
| `<leader>gB` | Toggle line blame display |
| `<leader>gd` | Diff this file |
| `<leader>gD` | Diff against HEAD |
| `ih` (text object) | Select hunk (in visual/operator mode) |

### Diffview
| Keybinding | Description |
|---|---|
| `<leader>gdo` | Open Diffview |
| `<leader>gdc` | Close Diffview |
| `<leader>gdf` | Show file history |

### Git UI
| Keybinding | Description |
|---|---|
| `<leader>gg` | Launch lazygit TUI |

---

## Debug (DAP) (`<leader>d*`)

| Keybinding | Description |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Toggle conditional breakpoint |
| `<leader>dc` | Continue / start debugging |
| `<leader>dl` | Run last configuration |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | Toggle REPL |
| `<leader>du` | Toggle UI panels |
| `<leader>dx` | Terminate session |

---

## Testing (`<leader>t*`)

| Keybinding | Description |
|---|---|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run tests in current file |
| `<leader>ts` | Run entire test suite |
| `<leader>to` | Show test output |
| `<leader>tt` | Toggle test summary window |

---

## Diagnostics & Issues (`<leader>x*`)

| Keybinding | Description |
|---|---|
| `<leader>xx` | Toggle all diagnostics (Trouble) |
| `<leader>xw` | Toggle buffer diagnostics (Trouble) |
| `<leader>xs` | Toggle document symbols (Trouble) |
| `<leader>xl` | Toggle LSP definitions/references (Trouble) |
| `<leader>xL` | Toggle location list (Trouble) |
| `<leader>xq` | Toggle quickfix list (Trouble) |
| `<leader>xt` | Toggle todo list (Trouble) |

---

## Search & Replace (`<leader>S`, `<leader>s*`)

### Spectre Panel
| Keybinding | Description |
|---|---|
| `<leader>S` | Toggle Spectre search/replace panel |
| `<leader>sw` | Search current word in Spectre |

### Inside Spectre Buffer
| Keybinding | Description |
|---|---|
| `dd` | Toggle selected line for replace |
| `<CR>` | Open file at result |
| `<leader>c` | Replace command |
| `<leader>o` | Show Spectre options |
| `<leader>rc` | Replace current line |
| `<leader>R` | Replace all matches |
| `<leader>v` | Change view mode |
| `trs` | Toggle regex (sed) engine |
| `tu` | Toggle live update |
| `ti` | Toggle ignore case |
| `th` | Toggle ignore hidden files |
| `<leader>q` | Send results to quickfix |

### General Search
| Keybinding | Description |
|---|---|
| `<leader>sc` | Clear search highlights |

---

## Session Management (`<leader>q*`)

| Keybinding | Description |
|---|---|
| `<leader>qq` | Quit current window |
| `<leader>qQ` | Quit all windows (force) |
| `<leader>qs` | Restore/save session |
| `<leader>qS` | Select session to load |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |

---

## Color/Colorscheme (`<leader>c*`)

**Note:** Theme preference is automatically saved and restored on next startup. Smart switching remembers last-used theme per category (dark/light).

### Theme Selection
| Keybinding | Description |
|---|---|
| `<leader>cc` | Choose theme from Telescope picker (all 50+ themes) |
| `<leader>cd` | Switch to last-used dark theme (smart) |
| `<leader>cl` | Switch to last-used light theme (smart) |
| `<leader>cp` | Switch to custom "txaty" theme |
| `<leader>cn` | Cycle to next theme in rotation |
| `<leader>cN` | Cycle to previous theme in rotation |

### Available Themes (50+)

**Dark Themes (25+):**
- `tokyonight` — Modern Tokyo night with vibrant colors
- `kanagawa` — Japanese-inspired wave aesthetic
- `catppuccin` — Soothing pastel colors (mocha)
- `rose-pine` — Soft, elegant rose pine theme
- `nightfox` — Clean dark theme with excellent contrast
- `onedark` — Atom-inspired one dark theme
- `cyberdream` — Neon cyberpunk aesthetic
- `gruvbox` — Retro groove with warm colors
- `nord` — Arctic, north-bluish theme (cool and calm)
- `dracula` — High contrast dark theme
- `ayu` — Minimalist dark theme
- `solarized` — Scientific color palette (dark)
- `jellybeans` — Colorful dark theme
- `everforest` — Green-based comfortable colorscheme
- `duskfox`, `nordfox`, `terafox`, `carbonfox` — Nightfox variants
- `material` — Material design dark theme
- `vscode` — VS Code Dark+ lookalike
- `moonfly`, `nightfly` — Moonlit/night flight themes
- `melange` — Warm, cozy dark theme
- `zenbones` — Minimal, readability-focused
- `oxocarbon` — IBM Carbon design system
- `github_dark*` — GitHub dark variants (default, dimmed, high contrast, colorblind, tritanopia)

**Light Themes (20+):**
- `tokyonight-day` — Tokyo day - modern light variant
- `rose-pine-dawn` — Rose pine dawn - soft light variant
- `kanagawa-lotus` — Kanagawa lotus - minimal light variant
- `onelight` — Atom one light theme
- `ayu-light` — Ayu light - minimalist design
- `solarized-light` — Solarized light - scientific color palette
- `papercolor` — PaperColor - clean paper-like appearance
- `gruvbox-light` — Retro groove light - warm colors
- `dayfox`, `dawnfox` — Nightfox light variants
- `everforest-light` — Green-based comfortable light
- `material-lighter` — Material design light
- `vscode-light` — VS Code Light+ lookalike
- `zenbones-light` — Minimal, readability-focused light
- `github_light*` — GitHub light variants (default, high contrast, colorblind)

**Custom Themes:**
- `txaty` — Low-saturation ergonomic dark theme (#0f1419 background) designed for reduced eye strain
- `txaty-light` — Low-saturation ergonomic light theme (#fafafa background) with same design principles

---

## Navigation & Motion

### Flash (Super-Speed Navigation)
| Keybinding | Description |
|---|---|
| `s` | Flash jump - find any character on screen and jump |
| `S` | Flash Treesitter select - select code block by scope |
| `r` | Remote Flash - operator-pending mode jump |
| `R` | Treesitter search - operator-pending Treesitter select |

**How to use Flash:**
- Press `s` + type any 2 characters → highlights appear → type the label to jump
- Press `S` to select by code scope (brackets, blocks, etc.)
- Works in normal, visual, and operator-pending modes

---

## Python (`<leader>p*`)

| Keybinding | Description |
|---|---|
| `<leader>pv` | Select Python virtualenv |

**Note:** venv-selector automatically detects and activates project virtualenvs. Essential for LSP to work correctly.

---

## Language Support Panel (`<leader>L*`)

**Note:** Uses capital `L` to avoid conflict with LSP keymaps (`<leader>l*`)

| Keybinding | Description |
|---|---|
| `<leader>Lp` | Open language support panel (Telescope) |
| `<leader>Ls` | Show language support status |

### Panel Keybindings (Inside Telescope Picker)
| Keybinding | Description |
|---|---|
| `<CR>` | Toggle selected language |
| `e` | Enable selected language |
| `d` | Disable selected language |

### Commands
| Command | Description |
|---|---|
| `:LangPanel` | Open language support panel |
| `:LangToggle <lang>` | Toggle language support |
| `:LangEnable <lang>` | Enable language support |
| `:LangDisable <lang>` | Disable language support |
| `:LangStatus [lang]` | Show status (all or specific) |

**Supported Languages:**
- `python` — pyright, ruff, black, isort, venv-selector
- `rust` — rustaceanvim, crates.nvim, rust-analyzer
- `go` — gopls, goimports, gofmt, delve
- `web` — ts_ls, cssls, jsonls, prettier (JS/TS/HTML/CSS)
- `flutter` — flutter-tools.nvim
- `latex` — vimtex, latexindent
- `typst` — typst-preview.nvim

**Note:** Changes require Neovim restart to take effect. State is persisted across sessions.

---

## Markdown (`<leader>mo`)

**Note:** Only available in `.md` (markdown) files

| Keybinding | Description |
|---|---|
| `<leader>mo` | Open current markdown file in external reader (Typora or system default) |

**How it works:**
- On macOS: Tries to open in Typora specifically, falls back to default markdown app
- On Linux: Uses Typora if available, otherwise uses `xdg-open`
- On Windows: Uses system default application

---

## Bookmarks (`<leader>m*`)

| Keybinding | Description |
|---|---|
| `<leader>ma` | Toggle bookmark at line |
| `<leader>mn` | Jump to next bookmark |
| `<leader>mp` | Jump to previous bookmark |
| `<leader>ml` | Show all bookmarks |
| `<leader>mi` | Annotate bookmark with comment |
| `<leader>md` | Clear bookmarks in buffer |
| `<leader>mC` | Clear all bookmarks |

---

## Minimap (`<leader>M*`)

| Keybinding | Description |
|---|---|
| `<leader>MM` | Toggle minimap display |
| `<leader>Mo` | Enable minimap |
| `<leader>Mc` | Disable minimap |
| `<leader>Mr` | Refresh minimap |

---

## Notifications & Messages (`<leader>n*`)

| Keybinding | Description |
|---|---|
| `<leader>nl` | Show last message |
| `<leader>nh` | Show message history |
| `<leader>nd` | Dismiss all notifications |

---

## Completion (Insert Mode)

| Keybinding | Description |
|---|---|
| `<C-Space>` | Trigger completion menu |
| `<C-j>` / `<C-k>` | Navigate completion items (next/prev) |
| `<Tab>` | Select next item or expand snippet |
| `<S-Tab>` | Select previous item or jump backward in snippet |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |
| `<C-b>` | Scroll documentation up |
| `<C-f>` | Scroll documentation down |

---

## Treesitter

### Incremental Selection
| Keybinding | Description |
|---|---|
| `<C-Space>` | Start selection or expand to next scope |
| `<BS>` | Shrink selection to previous scope |

---

## UI/Display Toggles (`<leader>u*`)

**Note:** UI toggles are session-persistent. Toggle state is saved when exiting Neovim and restored when reopening the same project.

| Keybinding | Description | Default |
|---|---|---|
| `<leader>uw` | Toggle line wrap | OFF |
| `<leader>us` | Toggle spell check | OFF |
| `<leader>un` | Toggle line numbers | ON |
| `<leader>ur` | Toggle relative numbers | ON |
| `<leader>uc` | Toggle conceal (0/2) | ON (2) |

**Prose Override:** Markdown, text, TeX, and Typst files automatically enable word wrap regardless of session state.

---

## Configuration & Tools

- **which-key**: Press `<leader>` to see all available keybindings in current context
- **LSP Status**: Run `:LspInfo` to check active language servers
- **Mason**: Run `:Mason` or `<leader>lm` to manage tools, formatters, linters, DAP adapters
- **Format Info**: Run `:ConformInfo` to check formatting setup
- **Health Check**: Run `:checkhealth` for comprehensive diagnostics
- **Plugin Status**: Run `:Lazy` to view installed plugins and their status
- **Treesitter Status**: Run `:TSInstallInfo` to check installed parsers

---

## Namespace Design Rationale

| Namespace | Reason |
|-----------|--------|
| `<leader>a*` | "A" for AI - clear mnemonic, resolves Copilot/Flutter conflicts |
| `<leader>c*` | "C" for Color/Colorscheme - theme switching and UI color management |
| `<leader>F*` | Capital F for Flutter - language-specific like Python, easy distinction from file ops |
| `<leader>M*` | Capital M for Minimap - less frequent UI feature, prioritizes lowercase `m*` for bookmarks |
| `<leader>l*` | "L" for LSP - consolidates all language server operations including Mason |
| `<leader>f*` | "F" for Files - includes Telescope discovery + file explorer |
| `<leader>g*` | "G" for Git - includes hunk operations + diffview + lazygit |
| `<leader>m*` | "M" for Markers/Markdown - includes bookmarks and markdown file operations |
| `<leader>x*` | "X" for eXtensions - diagnostics, trouble, quickfix management |
| `<leader>d*` | "D" for Debug - DAP operations for all supported languages |
| `<leader>t*` | "T" for Testing - test runner operations across all languages |
| `<leader>u*` | "U" for UI - display toggle operations (wrap, spell, numbers, conceal) |
| `<leader>n*` | "N" for Notifications - Noice message/notification management |
| `<leader>r*` | "r" for Remote - distant.nvim remote development operations |
| `<leader>R*` | Capital "R" for Rust - language-specific, avoids collision with Remote (`<leader>r*`) |
| `<leader>C*` | Capital "C" for Crates - Cargo.toml crate management |
| `<leader>L*` | Capital "L" for Language support panel - avoids collision with LSP (`<leader>l*`) |

---

## Migration Notes (From Old Config)

The following keymaps have changed to resolve conflicts and improve organization:

| Old Keymap | New Keymap | Reason |
|---|---|---|
| `<leader>r*` (Rust) | `<leader>R*` | Moved to capital R to avoid collision with Remote (`<leader>r*`) |
| `<leader>rn` | `<leader>nr` | Freed for LSP rename |
| `<leader>cm` | `<leader>lm` | Moved to LSP namespace |
| `<leader>cc/cq/ce/ct/cf/cr` | `<leader>aa/aq/ae/at/af/ar` | Copilot now in AI namespace |
| `<leader>cF/cq/cr/cR/cd/ce/co/cl` | `<leader>FR/Fq/Fr/Fl/Fd/Fe/Fo/FL` | Flutter now in separate namespace |
| `<leader>cf` (Copilot) | `<leader>lF` | Format injected langs in LSP |
| `<leader>mc` (bookmarks) | `<leader>md` | Freed minimap collision |
| `<leader>mm/mo/mc/mr` (minimap) | `<leader>MM/Mo/Mc/Mr` | Uppercase to avoid bookmark collision |

---

## Tips for Efficiency

1. **Use `which-key`**: Press `<leader>` and wait to see all available bindings in your current context
2. **Vim motions**: Regular vim operators (`gd`, `gr`, `K`) work without `<leader>`
3. **Visual mode**: Most LSP and git commands work in visual mode for selections
4. **Hunk navigation**: Use `]h` and `[h` (no leader) to quickly jump between git changes
5. **Window navigation**: Use `<C-h/j/k/l>` instead of arrow keys—faster on home row
6. **Buffer cycling**: `<TAB>` and `<S-TAB>` cycle through recent buffers quickly
7. **Flash for speed**: Use `s` + 2 chars to jump anywhere instantly
8. **Operator modes**: Keybindings work with operators: `d<leader>xx` deletes diagnostics, etc.

---

## Related Documentation

- Setup: See `README.md` for installation and initial setup
- Plugin list: Check `lua/plugins/` directory for all installed plugins
- Config structure: See `CLAUDE.md` for architecture and development guidelines
