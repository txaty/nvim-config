# Neovim Keybindings Reference

`<leader>` is **Space**. All mappings are organized by intent and mnemonic namespace for quick discovery via `which-key`.

---

## Quick Reference Table

| Namespace | Purpose | Example |
|-----------|---------|---------|
| `<leader>a*` | **AI & Copilot** | `<leader>ai` = toggle AI, `<leader>aa` = chat |
| `<leader>b*` | **Buffers** | `<leader>bd` = delete buffer, `<leader>ba` = select all |
| `<leader>c*` | **Color/Colorscheme** | `<leader>cc` = choose theme (78) |
| `<leader>d*` | **Debug** (DAP) | `<leader>db` = toggle breakpoint |
| `<leader>f*` | **Files & Finding** | `<leader>ff` = find files, `<leader>fS` = scratch select |
| `<leader>F*` | **Flutter** (language) | `<leader>FR` = run Flutter app |
| `<leader>g*` | **Git** | `<leader>gs` = stage hunk, `<leader>gv*` = Diffview |
| `<leader>i*` | **Images/PDF** | `<leader>io` = open in external viewer |
| `<leader>l*` | **LSP & Language** | `<leader>lr` = rename symbol, `<leader>lw*` = workspace folders |
| `<leader>L*` | **Language Support** | `<leader>Lp` = toggle language panel |
| `<leader>m*` | **Markdown** | `<leader>mo` = open in external reader |
| `<leader>n*` | **Notifications** | `<leader>nl` = show last message |
| `<leader>o*` | **Tasks** (overseer) | `<leader>or` = run a task |
| `<leader>p*` | **Python** (venv) | `<leader>pv` = select virtualenv |
| `<leader>q*` | **Quit/Session** | `<leader>qq` = quit window |
| `<leader>r*` | **Remote Development** | `<leader>rc` = connect to server |
| `<leader>R*` | **Rust** (language) | `<leader>Rr` = runnables, `<leader>Rt` = testables |
| `<leader>C*` | **Crates** (Cargo.toml) | `<leader>Cu` = upgrade crate |
| `<leader>H` | **Dashboard** | Open dashboard (Home) |
| `<leader>s*` | **Search & Symbols** | `<leader>ss` = jump to symbol |
| `<leader>S` | **Search & Replace** | Open grug-far (single mapping, not a group) |
| `<leader>T*` | **Terminal** | `<leader>Tf` = float terminal |
| `<leader>t*` | **Testing** | `<leader>tn` = run nearest test |
| `<leader>u*` | **UI/Display** | `<leader>uw` = toggle wrap, `<leader>uD` = diagnostics, `<leader>up` = profiler |
| `<leader>w*` | **Windows** | `<leader>ws` = horizontal split |
| `<leader>x*` | **Diagnostics** | `<leader>xx` = toggle diagnostics |

---

## Essential Keybindings

| Keybinding | Description |
|---|---|
| `jk` (insert) | Exit insert mode |
| `<C-a>` | Smart increment (works on numbers, dates, booleans, semver) |
| `<C-x>` | Smart decrement (works on numbers, dates, booleans, semver) |
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

### Snacks Picker (Primary)
| Keybinding | Description |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (with current filters if set) |
| `<leader>fG` | Live grep with filter prompts (include → exclude → search) |
| `<leader>fT` | Live grep by file type (select from preset list) |
| `<leader>fR` | Reset grep filters |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files (with frecency scoring) |
| `<leader>fh` | Help tags |
| `<leader>fw` | Grep word under cursor |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>f/` | Search in current buffer |
| `<leader>fs` | LSP symbols |
| `<leader>fd` | Diagnostics |
| `<leader>fm` | Marks |
| `<leader>ft` | Find todos |
| `<leader>fS` | Select scratch buffer |

### Picker Navigation
| Keybinding | Description |
|---|---|
| `<C-j>` | Move to next item |
| `<C-k>` | Move to previous item |
| `<C-q>` | Send to quickfix list |
| `<Esc>` | Close picker |

### Live Grep Filters
**Filter Examples:**
- Include: `*.lua`, `src/**/*.ts`, `*.{js,jsx}`
- Exclude: `node_modules`, `*.test.js`, `dist/**`
- Types: py, js, ts, rust, go, lua, cpp, md, json, yaml, html, css

**Note:** Filters persist during session. The picker title shows active filters (e.g., "Grep [+*.lua -node_modules]"). Use `<leader>fR` to reset.

**Performance:** Snacks picker uses async matchers with built-in debouncing for better performance in large projects compared to Telescope.

### File Explorer
| Keybinding | Description |
|---|---|
| `<leader>fe` | Toggle NvimTree file explorer |
| `<C-n>` | Toggle NvimTree file explorer (alternative) |

### File Operations
| Keybinding | Description |
|---|---|
| `<leader>fW` | Save file |
| `<leader>fy` | Yank absolute path of current file |
| `<leader>fY` | Yank path relative to cwd |
| `<leader>fN` | Yank filename only |

---

## Remote Development (`<leader>r*`)

**Distant.nvim - Remote development like VS Code Remote**

### Connection Management
| Keybinding | Description |
|---|---|
| `<leader>rc` | Connect to remote server via SSH (validated + confirmed) |
| `<leader>rd` | Disconnect from remote server |
| `<leader>ro` | Open remote directory/file (validated + confirmed) |
| `<leader>rs` | Show remote system info |
| `<leader>rS` | Open shell on remote server (confirmed) |

### Remote File Operations
| Keybinding | Description |
|---|---|
| `<leader>rf` | Find files on remote (Telescope) |
| `<leader>rg` | Live grep on remote (Telescope) |

**How it works:**
- Neovim runs locally, but files, LSP, and formatters execute on the remote server
- Supports SSH connections with compression for better performance
- Automatic LSP attachment only when `vim.g.enable_lsp_automatic_start = true`
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
| `<leader>bd` | Delete/close buffer (keeps window layout) |
| `<leader>bD` | Wipe out buffer |
| `<leader>bo` | Close all other buffers |
| `<leader>bx` | Close all buffers |
| `<leader>ba` | Select entire buffer |

---

## Windows (`<leader>w*`)

### Navigation
| Keybinding | Description |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Navigate to window (left/down/up/right) |

### Split & Layout
| Keybinding | Description |
|---|---|
| `<leader>ws` | Split window horizontally |
| `<leader>wv` | Split window vertically |
| `<leader>w=` | Equalize window sizes |
| `<leader>wo` | Close other windows |
| `<leader>wz` | Toggle zoom (maximize/restore) |

### LSP Workspace Folders
Under `<leader>lw*`, not `<leader>w*`: `<leader>w` is the Windows group.

| Keybinding | Description |
|---|---|
| `<leader>lwa` | Add workspace folder |
| `<leader>lwr` | Remove workspace folder |
| `<leader>lwl` | List workspace folders |

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
| `<leader>lr` | Incremental rename (live preview as you type) |
| `<leader>la` | Code action |
| `<leader>lf` | Format document (via conform) |
| `<leader>lF` | Format injected languages |
| `<leader>ls` | Show signature help |
| `<leader>lb` | Pick a breadcrumb component (dropbar) |
| `<leader>lg` | Generate docstring/annotation (neogen) |
| `<leader>lo` | Toggle code outline |
| `<leader>D` | Go to type definition |

### Refactoring (refactoring.nvim)
| Keybinding | Description |
|---|---|
| `<leader>le` | Extract function (visual) |
| `<leader>lE` | Extract variable (visual) |
| `<leader>li` | Inline variable |
| `<leader>lR` | Open the refactoring menu |

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

### Avante (Agentic AI Editing)
| Keybinding | Description |
|---|---|
| `<leader>av` | Toggle Avante sidebar |
| `<leader>ac` | Avante chat |
| `<leader>aA` | Ask Avante with selection (normal/visual) |
| `<leader>aR` | Refresh Avante |

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

**Note:** Only available in `.rs` (Rust) files. Uses capital `R` to avoid conflict with Remote (`<leader>r*`). Powered by [rustaceanvim](https://github.com/mrcjkb/rustaceanvim).

### Run & Test
| Keybinding | Description |
|---|---|
| `<leader>Rr` | Show runnables picker |
| `<leader>RR` | Rerun last runnable |
| `<leader>Rt` | Show testables picker |
| `<leader>RT` | Rerun last test |

### Navigation & Analysis
| Keybinding | Description |
|---|---|
| `<leader>Ra` | Expand macro at cursor |
| `<leader>Rx` | Explain error under cursor |
| `<leader>Rc` | Open Cargo.toml |
| `<leader>Rp` | Go to parent module |
| `<leader>Rj` | Join lines |
| `<leader>RS` | Structural search/replace (capital S) |

### Symbol Discovery (Multi-file)
| Keybinding | Description |
|---|---|
| `<leader>Rw` | Search workspace symbols (live) |

**Recommended Workflow for Exploring Rust Codebases:**
1. **Module structure first**: `<leader>Rw` - Search `mod` to see module hierarchy
2. **Data structures**: `<leader>Rw` - Search `struct` to find main types
3. **Trait contracts**: `<leader>Rw` - Search `trait` to discover contracts
4. **State machines & errors**: `<leader>Rw` - Search `enum` for enum types
5. **Detailed navigation**: Use `gd`/`gi`/`gr`/`K` on specific symbols

**Combining tools:**
- `<leader>Rw` - Live search across workspace symbols
- `<leader>ss` (namu) - Quick outline of current file
- `<leader>lo` (outline) - Persistent sidebar for long editing sessions
- `gd`/`gi`/`gr` - Precise navigation when cursor is on a symbol

### Debugging
| Keybinding | Description |
|---|---|
| `<leader>RD` | Show debuggables picker |
| `<leader>Rd` | Debug target at cursor |
| `<leader>RH` | Show hover actions |

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
| `<leader>gI` | Toggle inline deleted text |
| `<leader>gw` | Toggle word diff |
| `<leader>gd` | Diff this file |
| `<leader>gD` | Diff against HEAD |
| `ih` (text object) | Select hunk (in visual/operator mode) |

### Diffview (`<leader>gv*`)
Prefixed `gv` ("git view") so it does not collide with gitsigns' `<leader>gd`.
A mapping that is also a prefix of longer mappings can only fire after
`timeoutlen`, so sharing `gd` made "diff this" feel laggy.

| Keybinding | Description |
|---|---|
| `<leader>gvo` | Open Diffview |
| `<leader>gvc` | Close Diffview |
| `<leader>gvf` | Show file history (current file) |
| `<leader>gvh` | Show repo history |
| `<leader>gvs` | Show staged changes |
| `<leader>gvb` | Compare with previous commit |

### Git Browse
| Keybinding | Description |
|---|---|
| `<leader>go` | Open file/selection in browser (GitHub/GitLab) |

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
| `<leader>tc` | Toggle coverage signs |
| `<leader>tC` | Show test coverage summary |
| `<leader>tL` | Load coverage data |

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

## Surround (nvim-surround)

**Note:** Works in normal, visual, and operator-pending modes with zero configuration.

| Keybinding | Description |
|---|---|
| `ys{motion}{char}` | Add surround (e.g., `ysiw"` wraps word in quotes) |
| `ds{char}` | Delete surround (e.g., `ds"` removes surrounding quotes) |
| `cs{old}{new}` | Change surround (e.g., `cs"'` changes `"` to `'`) |
| `S{char}` (visual) | Surround visual selection |

**Supported characters:** `(`, `)`, `[`, `]`, `{`, `}`, `"`, `'`, `` ` ``, `t` (HTML tags), `f` (function calls)

---

## Code Outline (`<leader>lo`)

| Keybinding | Description |
|---|---|
| `<leader>lo` | Toggle code outline sidebar (symbols from LSP) |

**Features:** Shows functions, classes, types in a sidebar. Auto-highlights current symbol as cursor moves.

---

## Symbol Navigation (`<leader>ss`)

| Keybinding | Description |
|---|---|
| `<leader>ss` | Jump to symbol (namu - preserves code order) |
| `<leader>sS` | Jump to workspace symbol |

**Inside namu picker:**
| Keybinding | Description |
|---|---|
| `<C-j>` / `<Down>` | Next symbol |
| `<C-k>` / `<Up>` | Previous symbol |

**Advantages over Telescope symbol pickers:** Preserves symbol order in code, shows hierarchy context, live preview.

---

## Terminal (`<C-\>`, `<leader>T*`)

| Keybinding | Description |
|---|---|
| `<C-\>` | Toggle terminal (works in normal and terminal mode) |
| `<leader>Tf` | Open floating terminal |
| `<leader>Th` | Open horizontal terminal |
| `<leader>Tv` | Open vertical terminal (80 columns) |

**Features:** Persistent terminals that survive buffer switching, multiple named terminals, float/horizontal/vertical layouts.

---

## Search & Replace (`<leader>S`, `<leader>s*`)

### grug-far (Project-wide Search & Replace)
| Keybinding | Description |
|---|---|
| `<leader>S` | Open grug-far search/replace panel |
| `<leader>sw` | Search current word in grug-far |
| `<leader>S` (visual) | Search visual selection in grug-far |

### General Search
| Keybinding | Description |
|---|---|
| `<leader>sc` | Clear search highlights |

### Symbols & Parameters
| Keybinding | Description |
|---|---|
| `<leader>ss` | Jump to document symbol (namu) |
| `<leader>sS` | Jump to workspace symbol (namu) |
| `<leader>sa` | Swap with next parameter |
| `<leader>sA` | Swap with previous parameter |

---

## Tasks (`<leader>o*`)

overseer.nvim — the VS Code `tasks.json` equivalent, with built-in
make/npm/cargo/go templates.

| Keybinding | Description |
|---|---|
| `<leader>or` | Run a task |
| `<leader>ot` | Toggle the task panel |
| `<leader>ol` | Restart the last task |
| `<leader>oa` | Task action menu |

---

## Images & PDFs (`<leader>i*`)

Snacks renders these inline and sets filetype `image`.

| Keybinding | Description |
|---|---|
| `<leader>io` | Open the current image/PDF in the system viewer (asks first) |

---

## Session Management (`<leader>q*`)

| Keybinding | Description |
|---|---|
| `<leader>qq` | Quit current window |
| `<leader>qQ` | Quit all windows (force) |
| `<leader>qs` | Restore session for current directory |
| `<leader>qS` | Select session to load |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |
| `<leader>qp` | Toggle session auto-persistence (persisted across restarts) |

Auto-restore and auto-save are gated by a persisted toggle (default: enabled).
Use `:SessionToggle` / `:SessionEnable` / `:SessionDisable` / `:SessionStatus` or
`<leader>qp`. State is stored in `$XDG_DATA_HOME/nvim/session_config.json`.

---

## Color/Colorscheme (`<leader>c*`)

**Note:** Theme preference is automatically saved and restored on next startup. Smart switching remembers last-used theme per category (dark/light).

### Theme Selection
| Keybinding | Description |
|---|---|
| `<leader>cc` | Open interactive theme picker (all 78 themes) |
| `<leader>cd` | Switch to last-used dark theme (smart) |
| `<leader>cl` | Switch to last-used light theme (smart) |
| `<leader>cp` | Switch to custom "txaty" theme |
| `<leader>cn` | Cycle to next theme in rotation |
| `<leader>cN` | Cycle to previous theme in rotation |

### Available Themes (78)

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
- `papercolor` — PaperColor - clean paper-like appearance
- `gruvbox-light` — Retro groove light - warm colors
- `dayfox`, `dawnfox` — Nightfox light variants
- `everforest-light` — Green-based comfortable light
- `material-lighter` — Material design light
- `vscode-light` — VS Code Light+ lookalike
- `zenbones-light` — Minimal, readability-focused light
- `github_light*` — GitHub light variants (default, high contrast, colorblind)

**Custom Themes:**
- `txaty` — Low-saturation ergonomic dark theme (#1c1e22 background) designed for reduced eye strain
- `txaty-light` — Low-saturation ergonomic light theme (#fafafa background) with same design principles

---

## Search Navigation

### Search Result Visualization (nvim-hlslens)
| Keybinding | Description |
|---|---|
| `n` | Next search result (shows "N/M" match count) |
| `N` | Previous search result (shows "N/M" match count) |
| `*` | Search word under cursor forward |
| `#` | Search word under cursor backward |

**Features:**
- Shows current match position (e.g., "3/12" for 3rd of 12 matches)
- Highlights the nearest match distinctly
- Lens clears when cursor moves away from matches

---

## Navigation & Motion

### Scope Navigation (Snacks)
| Keybinding | Description |
|---|---|
| `]i` | Jump to next scope boundary |
| `[i` | Jump to previous scope boundary |
| `ii` (text object) | Select inner scope (function body, block content) |
| `ai` (text object) | Select outer scope (function + signature, entire block) |

**How to use:**
- Press `]i` to jump to the end of the current scope or next scope
- Press `[i` to jump to the beginning of the current scope or previous scope
- Use `vii` to select the inner contents of a function/block
- Use `vai` to select the entire function/block including signature

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

## Notifications & Messages (`<leader>n*`)

| Keybinding | Description |
|---|---|
| `<leader>nl` | Show last message |
| `<leader>nh` | Show message history |
| `<leader>na` | Show all messages |
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

## Editing Enhancements

### Split/Join (treesj)
| Keybinding | Description |
|---|---|
| `<leader>j` | Toggle a block between one line and many |

### Multi-Cursor (multicursor.nvim)
| Keybinding | Description |
|---|---|
| `<C-Up>` / `<C-Down>` | Add a cursor on the line above/below |
| `gb` / `gB` | Add a cursor at the next/previous match |
| `<leader>va` | Add cursors at all matches |
| `<Esc>` | Clear extra cursors, or clear search highlight when there are none |

### Smart Increment/Decrement (dial.nvim)
| Keybinding | Description |
|---|---|
| `<C-a>` | Increment value at cursor |
| `<C-x>` | Decrement value at cursor |
| `g<C-a>` | Increment sequentially (in visual block) |
| `g<C-x>` | Decrement sequentially (in visual block) |

**Supported value types:**
- Numbers (decimal and hex)
- Dates (`2024-01-15`, `2024/01/15`)
- Booleans (`true`/`false`, `True`/`False`)
- Semver (`1.2.3`)
- Keywords (`yes`/`no`, `on`/`off`)
- Operators (`&&`/`||`)

### Yank Ring (yanky.nvim)
| Keybinding | Description |
|---|---|
| `p` | Put after cursor (from yank ring) |
| `P` | Put before cursor (from yank ring) |
| `[y` | Cycle to previous yank (after paste) |
| `]y` | Cycle to next yank (after paste) |

**How to use:**
1. Yank multiple pieces of text throughout your session
2. Press `p` to paste the most recent yank
3. Press `[y` to replace with the previous yank from history
4. Press `]y` to go forward in yank history
5. Yank ring holds up to 50 entries

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
| `<leader>ug` | Toggle nvim-tree git status | ON |
| `<leader>uD` | Toggle inline diagnostics mode | OFF |
| `<leader>ut` | Toggle Treesitter context header | ON |
| `<leader>uz` | Toggle zen mode | — |
| `<leader>uC` | Toggle smear cursor animation | ON |
| `<leader>ud` | Toggle dim mode | — |
| `<leader>up` | Toggle profiler overlay | — |

**Prose Override:** Markdown, text, TeX, and Typst files automatically enable word wrap regardless of session state.

---

## Scratch Buffers (`<leader>.`)

| Keybinding | Description |
|---|---|
| `<leader>.` | Open new scratch buffer |
| `<leader>fS` | Select from existing scratch buffers |

**Features:**
- Auto-save on hide (scratch buffers persist)
- Organized by directory/branch
- Lua buffers can execute code (press Enter in Lua scratch)
- Useful for testing code snippets, taking notes, or temporary work

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
| `<leader>l*` | "L" for LSP - all language server operations including Mason; workspace folders nest under `<leader>lw*` |
| `<leader>f*` | "F" for Files - includes Snacks picker discovery + file explorer |
| `<leader>g*` | "G" for Git - hunk operations + lazygit; Diffview nests under `<leader>gv*` |
| `<leader>m*` | "M" for Markdown - markdown file operations |
| `<leader>i*` | "I" for Image - image/PDF buffer operations |
| `<leader>o*` | "O" for Overseer - task runner operations |
| `<leader>x*` | "X" for eXtensions - diagnostics, trouble, quickfix management |
| `<leader>d*` | "D" for Debug - DAP operations for all supported languages |
| `<leader>t*` | "T" for Testing - test runner operations across all languages |
| `<leader>T*` | Capital "T" for Terminal - toggleterm layouts, avoids collision with Testing (`<leader>t*`) |
| `<leader>u*` | "U" for UI - display toggle operations (wrap, spell, numbers, conceal) |
| `<leader>n*` | "N" for Notifications - Noice message/notification management |
| `<leader>r*` | "r" for Remote - distant.nvim remote development operations |
| `<leader>R*` | Capital "R" for Rust - language-specific, avoids collision with Remote (`<leader>r*`) |
| `<leader>C*` | Capital "C" for Crates - Cargo.toml crate management |
| `<leader>L*` | Capital "L" for Language support panel - avoids collision with LSP (`<leader>l*`) |

---

## Recent Keymap Changes

Changes made to resolve real conflicts. Everything else is unchanged.

| Old | New | Reason |
|---|---|---|
| `<leader>gd{o,c,f,s,b}` (Diffview) | `<leader>gv{o,c,f,s,b}` | `<leader>gd` (gitsigns "diff this") was a prefix of these, so it could only fire after `timeoutlen` (400ms). Separate prefixes make both immediate. `<leader>gvh` (repo history) is now documented too. |
| `<leader>w{a,r,l}` (LSP workspace folders) | `<leader>lw{a,r,l}` | `<leader>w` is registered with which-key as the Windows group; three LSP mappings hidden in it were mislabelled and undiscoverable. |

Removed, because the plugins behind them are no longer in the config:

| Removed | Plugin |
|---|---|
| `<leader>M*` (minimap) | neominimap.nvim |
| `<leader>m{a,n,p,l,i,d,C}` (bookmarks) | bookmarks.nvim |

`<leader>m*` is now Markdown-only (`<leader>mo`).

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
