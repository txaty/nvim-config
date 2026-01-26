-- Theme switcher with custom floating window picker
-- Insert-mode prompt with virtual cursor, debounced preview, no Telescope dependency.
-- Fixes: highlight leaks, ColorScheme autocmd corruption, no monkey-patching.
return {
  {
    dir = vim.fn.stdpath "config",
    name = "theme-switcher",
    cmd = { "ThemeSwitch", "ThemeDark", "ThemeLight", "ThemeTxaty", "ThemeNext", "ThemePrev" },
    keys = {
      { "<leader>cc", "<cmd>ThemeSwitch<cr>", desc = "Color: choose colorscheme" },
      { "<leader>cd", "<cmd>ThemeDark<cr>", desc = "Color: switch to dark" },
      { "<leader>cl", "<cmd>ThemeLight<cr>", desc = "Color: switch to light" },
      { "<leader>cp", "<cmd>ThemeTxaty<cr>", desc = "Color: switch to txaty" },
      { "<leader>cn", "<cmd>ThemeNext<cr>", desc = "Color: next theme" },
      { "<leader>cN", "<cmd>ThemePrev<cr>", desc = "Color: previous theme" },
    },
    config = function()
      local theme = require "core.theme"

      local ns = vim.api.nvim_create_namespace "theme_picker"
      local DEBOUNCE_MS = 120
      local WIN_WIDTH = 48
      local FILTERS = { "all", "dark", "light" }
      local FILTER_LABELS = { all = "All", dark = "Dark", light = "Light" }

      -- ==================================================================
      -- Build filtered theme list
      -- ==================================================================
      local function build_entries(variant_filter, query)
        local all = theme.get_all_themes()
        local out = {}
        local q = (query or ""):lower()
        for _, name in ipairs(all) do
          local info = theme.registry[name]
          if info then
            local var_ok = variant_filter == "all" or info.variant == variant_filter
            local q_ok = q == "" or name:lower():find(q, 1, true)
            if var_ok and q_ok then
              table.insert(out, name)
            end
          end
        end
        return out
      end

      -- ==================================================================
      -- Picker
      -- ==================================================================
      local active_picker = nil -- guard against double-open

      local function open_picker()
        if active_picker then
          return
        end

        local original = theme.load_saved_theme() or "catppuccin"
        local win_height = math.min(22, vim.o.lines - 4)
        local visible_count = win_height - 2 -- prompt line + separator

        -- Picker state (local to this invocation)
        local st = {
          query = "",
          filter_idx = 1,
          sel = 1,
          scroll = 0,
          entries = {},
          closed = false,
        }

        -- Single timer, created once and reused
        local timer = vim.uv.new_timer()

        -- Create buffer (stays modifiable so insert mode works on prompt)
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].swapfile = false
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " > " })

        -- Create floating window
        local row = math.floor((vim.o.lines - win_height) / 2)
        local col = math.floor((vim.o.columns - WIN_WIDTH) / 2)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = WIN_WIDTH,
          height = win_height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = " Theme [All] ",
          title_pos = "center",
        })

        vim.wo[win].cursorline = false
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].wrap = false

        theme._previewing = true
        active_picker = true

        -- ============================================================
        -- Render: rewrite lines 1+ (separator + entries) + highlights
        -- Prompt on line 0 is managed by insert mode, never touched.
        -- ============================================================
        local rendering = false

        local function render()
          if st.closed or not vim.api.nvim_buf_is_valid(buf) then
            return
          end

          rendering = true

          local filter = FILTERS[st.filter_idx]
          st.entries = build_entries(filter, st.query)

          -- Clamp selection
          if st.sel > #st.entries then
            st.sel = math.max(1, #st.entries)
          end
          if st.sel < 1 then
            st.sel = 1
          end

          -- Scroll to keep selection visible
          if st.sel > st.scroll + visible_count then
            st.scroll = st.sel - visible_count
          end
          if st.sel <= st.scroll then
            st.scroll = math.max(0, st.sel - 1)
          end

          -- Build result lines
          local sep = " " .. string.rep("\u{2500}", WIN_WIDTH - 2)
          local lines = { sep }

          local vis_start = st.scroll + 1
          local vis_end = math.min(st.scroll + visible_count, #st.entries)

          for i = vis_start, vis_end do
            local name = st.entries[i]
            local info = theme.registry[name] or {}
            local variant = info.variant or "custom"
            local marker = name == original and "*" or " "
            table.insert(lines, string.format(" %s %-28s %s", marker, name, variant))
          end

          if #st.entries == 0 then
            table.insert(lines, "   No matching themes")
          end

          -- Pad to fill visible area (avoids flicker from changing buffer height)
          while #lines < visible_count + 1 do
            table.insert(lines, "")
          end

          -- Write lines 1+ (leave line 0 = prompt untouched)
          vim.api.nvim_buf_set_lines(buf, 1, -1, false, lines)

          -- Highlights
          vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

          -- Prompt: highlight " > " prefix
          vim.api.nvim_buf_add_highlight(buf, ns, "Question", 0, 0, 3)

          -- Separator
          vim.api.nvim_buf_add_highlight(buf, ns, "FloatBorder", 1, 0, -1)

          -- Entry highlights
          for i = vis_start, vis_end do
            local buf_line = i - st.scroll + 1 -- +1 for separator
            local name = st.entries[i]
            local info = theme.registry[name] or {}

            -- Virtual cursor (selected row)
            if i == st.sel then
              vim.api.nvim_buf_add_highlight(buf, ns, "CursorLine", buf_line, 0, -1)
            end

            -- Star marker for saved theme
            if name == original then
              vim.api.nvim_buf_add_highlight(buf, ns, "String", buf_line, 1, 2)
            end

            -- Variant label color
            local variant = info.variant or "custom"
            local entry_line = lines[i - st.scroll + 1]
            if entry_line then
              local vstart, vend = entry_line:find(variant .. "%s*$")
              if vstart then
                local hl = variant == "light" and "WarningMsg" or "Comment"
                vim.api.nvim_buf_add_highlight(buf, ns, hl, buf_line, vstart - 1, vend)
              end
            end
          end

          -- Update window title with current filter
          pcall(vim.api.nvim_win_set_config, win, {
            title = " Theme [" .. FILTER_LABELS[filter] .. "] ",
            title_pos = "center",
          })

          rendering = false
        end

        -- ============================================================
        -- Debounced preview
        -- ============================================================
        local function schedule_preview()
          timer:stop()
          if #st.entries == 0 or st.sel < 1 then
            return
          end
          timer:start(
            DEBOUNCE_MS,
            0,
            vim.schedule_wrap(function()
              if st.closed then
                return
              end
              if st.sel >= 1 and st.sel <= #st.entries then
                theme.apply(st.entries[st.sel], { save = false, notify = false })
                render()
              end
            end)
          )
        end

        -- ============================================================
        -- Close picker
        -- ============================================================
        local function close(selected_name)
          if st.closed then
            return
          end
          st.closed = true
          active_picker = nil

          timer:stop()
          timer:close()

          theme._previewing = false

          vim.cmd "stopinsert"
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end

          if selected_name then
            theme.apply(selected_name)
          else
            theme.apply(original, { save = false, notify = false })
          end
        end

        -- ============================================================
        -- Initial render and enter insert mode
        -- ============================================================
        render()
        vim.cmd "startinsert!"

        -- ============================================================
        -- Keymaps (insert + normal mode)
        -- ============================================================
        local kopts = { buffer = buf, noremap = true, silent = true }

        -- Cancel
        vim.keymap.set({ "i", "n" }, "<Esc>", function()
          close(nil)
        end, kopts)

        -- Confirm selection
        vim.keymap.set({ "i", "n" }, "<CR>", function()
          close(st.entries[st.sel])
        end, kopts)

        -- Move virtual cursor down
        local function move_down()
          if st.sel < #st.entries then
            st.sel = st.sel + 1
            render()
            schedule_preview()
          end
        end
        vim.keymap.set("i", "<Down>", move_down, kopts)
        vim.keymap.set("i", "<C-n>", move_down, kopts)
        vim.keymap.set("n", "j", move_down, kopts)
        vim.keymap.set("n", "<Down>", move_down, kopts)
        vim.keymap.set("n", "<C-n>", move_down, kopts)

        -- Move virtual cursor up
        local function move_up()
          if st.sel > 1 then
            st.sel = st.sel - 1
            render()
            schedule_preview()
          end
        end
        vim.keymap.set("i", "<Up>", move_up, kopts)
        vim.keymap.set("i", "<C-p>", move_up, kopts)
        vim.keymap.set("n", "k", move_up, kopts)
        vim.keymap.set("n", "<Up>", move_up, kopts)
        vim.keymap.set("n", "<C-p>", move_up, kopts)

        -- Cycle variant filter
        local function cycle_filter(dir)
          st.filter_idx = st.filter_idx + dir
          if st.filter_idx < 1 then
            st.filter_idx = #FILTERS
          end
          if st.filter_idx > #FILTERS then
            st.filter_idx = 1
          end
          st.sel = 1
          st.scroll = 0
          render()
          schedule_preview()
        end
        vim.keymap.set("i", "<Tab>", function()
          cycle_filter(1)
        end, kopts)
        vim.keymap.set("i", "<S-Tab>", function()
          cycle_filter(-1)
        end, kopts)
        vim.keymap.set("n", "<Tab>", function()
          cycle_filter(1)
        end, kopts)
        vim.keymap.set("n", "<S-Tab>", function()
          cycle_filter(-1)
        end, kopts)

        -- Clear filter (Ctrl-U)
        vim.keymap.set("i", "<C-u>", function()
          if st.closed then
            return
          end
          vim.api.nvim_buf_set_lines(buf, 0, 1, false, { " > " })
          pcall(vim.api.nvim_win_set_cursor, win, { 1, 3 })
          st.query = ""
          st.sel = 1
          st.scroll = 0
          render()
          schedule_preview()
        end, kopts)

        -- ============================================================
        -- Track query changes from insert-mode typing
        -- ============================================================
        vim.api.nvim_create_autocmd("TextChangedI", {
          buffer = buf,
          callback = function()
            if st.closed or rendering then
              return
            end
            local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
            local query = line:match "^%s*>%s*(.*)$" or line:gsub("^%s+", "")
            if query ~= st.query then
              st.query = query
              st.sel = 1
              st.scroll = 0
              render()
              schedule_preview()
            end
          end,
        })

        -- Keep cursor on prompt line
        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = buf,
          callback = function()
            if st.closed then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(win)
            if cursor[1] ~= 1 then
              pcall(vim.api.nvim_win_set_cursor, win, { 1, math.max(3, 3 + #st.query) })
            end
          end,
        })

        -- Handle unexpected window close
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(win),
          once = true,
          callback = function()
            close(nil)
          end,
        })
      end

      -- ==================================================================
      -- Theme cycling (next/prev)
      -- ==================================================================
      local function cycle_theme(direction)
        local all_themes = theme.get_all_themes()
        local saved = theme.load_saved_theme() or "catppuccin"
        local idx = 1
        for i, t in ipairs(all_themes) do
          if t == saved then
            idx = i
            break
          end
        end
        if direction > 0 then
          idx = idx % #all_themes + 1
        else
          idx = idx - 1
          if idx < 1 then
            idx = #all_themes
          end
        end
        theme.apply(all_themes[idx])
      end

      -- ==================================================================
      -- Commands
      -- ==================================================================
      vim.api.nvim_create_user_command("ThemeSwitch", open_picker, {})

      vim.api.nvim_create_user_command("ThemeDark", function()
        theme.switch_to_dark()
      end, {})

      vim.api.nvim_create_user_command("ThemeLight", function()
        theme.switch_to_light()
      end, {})

      vim.api.nvim_create_user_command("ThemeTxaty", function()
        theme.apply "txaty"
      end, {})

      vim.api.nvim_create_user_command("ThemeNext", function()
        cycle_theme(1)
      end, {})

      vim.api.nvim_create_user_command("ThemePrev", function()
        cycle_theme(-1)
      end, {})
    end,
  },
}
