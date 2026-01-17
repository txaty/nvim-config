# Neovim Keybindings Reference

`<leader>` is **Space**. All mappings are organized by intent and mnemonic namespace for quick discovery via `which-key`.

---

## Quick Reference Table

| Namespace | Purpose | Example |
|-----------|---------|---------|
| `<leader>a*` | **AI & Copilot** | `<leader>aa` = AI Chat toggle |
| `<leader>b*` | **Buffers** | `<leader>bd` = delete buffer |
| `<leader>d*` | **Debug** (DAP) | `<leader>db` = toggle breakpoint |
| `<leader>f*` | **Files & Finding** | `<leader>ff` = find files |
| `<leader>F*` | **Flutter** (language) | `<leader>FR` = run Flutter app |
| `<leader>g*` | **Git** | `<leader>gs` = stage hunk |
| `<leader>l*` | **LSP & Language** | `<leader>lr` = rename symbol |
| `<leader>m*` | **Bookmarks** | `<leader>ma` = toggle bookmark |
| `<leader>M*` | **Minimap** | `<leader>MM` = toggle minimap |
| `<leader>n*` | **Notifications** | `<leader>nl` = show last message |
| `<leader>p*` | **Python** (venv) | `<leader>pv` = select virtualenv |
| `<leader>q*` | **Quit/Session** | `<leader>qq` = quit window |
| `<leader>s*` | **Search & Replace** | `<leader>S` = Spectre search/replace |
| `<leader>S*` | **Spectre** | `<leader>sw` = search current word |
| `<leader>t*` | **Testing** | `<leader>tn` = run nearest test |
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
| `<C-l>` | Accept suggestion |
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

## Line Number & Display Toggle

| Keybinding | Description |
|---|---|
| `<leader>n` | Toggle line numbers on/off |
| `<leader>nr` | Toggle relative line numbers on/off |

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
| `<leader>F*` | Capital F for Flutter - language-specific like Python, easy distinction from file ops |
| `<leader>M*` | Capital M for Minimap - less frequent UI feature, prioritizes lowercase `m*` for bookmarks |
| `<leader>l*` | "L" for LSP - consolidates all language server operations including Mason |
| `<leader>f*` | "F" for Files - includes Telescope discovery + file explorer |
| `<leader>g*` | "G" for Git - includes hunk operations + diffview + lazygit |
| `<leader>m*` | "M" for Markers - bookmarks are more frequently used than minimap |
| `<leader>x*` | "X" for eXtensions - diagnostics, trouble, quickfix management |
| `<leader>d*` | "D" for Debug - DAP operations for all supported languages |
| `<leader>t*` | "T" for Testing - test runner operations across all languages |
| `<leader>n*` | "N" for Notifications - Noice message/notification management |

---

## Migration Notes (From Old Config)

The following keymaps have changed to resolve conflicts and improve organization:

| Old Keymap | New Keymap | Reason |
|---|---|---|
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
