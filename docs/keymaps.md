# Neovim Keybindings Cheatsheet

`<leader>` is space. All mappings aim to keep common workflows on the home row and grouped by intent (files, buffers, git, debug, etc.).

## Essentials

| Keybinding | Description |
| :--------- | :---------- |
| `jk` (insert) | leave insert mode |
| `<C-a>` | select entire buffer |
| `<leader>sc` | clear search highlights |
| `<leader>fs` | save file |
| `<leader>qq` / `<leader>qQ` | quit window / quit all |

## Files (`<leader>f`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>ff` | Telescope find files |
| `<leader>fg` | Telescope live grep |
| `<leader>fb` | Telescope buffers |
| `<leader>fr` | Telescope recent files |
| `<leader>fe` | Toggle NvimTree |

## Buffers (`<leader>b`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>bn` | next buffer |
| `<leader>bp` | previous buffer |
| `<leader>bd` | delete buffer |

## Windows (`<leader>w`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>ws` / `<leader>wv` | horizontal / vertical split |
| `<leader>wh` / `<leader>wj` / `<leader>wk` / `<leader>wl` | move to window |
| `<leader>wq` | close window |

## LSP & Diagnostics (`<leader>l`)

| Keybinding | Description |
| :--------- | :---------- |
| `gd`, `gD`, `gi`, `gr` | definition, declaration, implementation, references |
| `<leader>lh` | signature help |
| `<leader>lr` | rename symbol |
| `<leader>la` | code action |
| `<leader>lf` | format via conform |
| `<leader>ld` | floating diagnostics |
| `[d` / `]d` | prev / next diagnostic |

## Git (`<leader>g`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>gs` | stage hunk |
| `<leader>gr` | reset hunk |
| `<leader>gp` | preview hunk |
| `<leader>gb` | toggle blame |
| `<leader>gdo` / `<leader>gdc` | Diffview open / close |
| `<leader>gdf` | Diffview file history |

## Debug (`<leader>d`) — powered by `nvim-dap`

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>db` / `<leader>dB` | toggle / conditional breakpoint |
| `<leader>dc` | continue / start |
| `<leader>dl` | run last |
| `<leader>di` / `<leader>do` / `<leader>dO` | step into / over / out |
| `<leader>dr` | toggle REPL |
| `<leader>du` | toggle UI panels |
| `<leader>dx` | terminate session |

## Testing (`<leader>t`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>tn` | run nearest test |
| `<leader>tf` | run current file |
| `<leader>ts` | run suite |
| `<leader>to` | show test output |
| `<leader>tt` | toggle test summary |

## Python & Virtualenvs (`<leader>p`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>pv` | launch `venv-selector` |

## Bookmarks & Navigation (`<leader>m`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>ma` | toggle bookmark |
| `<leader>mn` / `<leader>mp` | next / previous bookmark |
| `<leader>ml` | list bookmarks |
| `<leader>mi` | annotate bookmark |
| `<leader>mc` | clean buffer bookmarks |
| `<leader>mC` | clear all bookmarks |

## Minimap (`<leader>m*`)

| Keybinding | Description |
| :--------- | :---------- |
| `<leader>mm` | toggle Neominimap |
| `<leader>mo` / `<leader>mc` | enable / disable minimap |
| `<leader>mr` | refresh minimap |

## Misc

- `<leader>mm` group also used by bookmarks; which-key shows both namespaces clearly.
- `<leader>pv` pairs with `venv-selector` and `nvim-dap-python`.
- Debugger, testing, git, and file groups are visible via `which-key` for quick discovery. 
