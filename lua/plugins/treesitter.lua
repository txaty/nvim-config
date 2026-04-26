return {
  {
    -- branch = "main" (not "master"): the master branch is archived and its
    -- query_predicates.lua is incompatible with Neovim 0.12+, which changed
    -- match tables from single TSNodes to arrays of TSNodes. This caused the
    -- "attempt to call method 'range' (a nil value)" conceal_line error on
    -- every markdown open. The main branch removes query_predicates.lua
    -- entirely (directives upstreamed to Neovim core) and requires Neovim 0.11+.
    -- API change: require("nvim-treesitter").setup(opts) replaces the old
    -- require("nvim-treesitter.configs").setup(opts) pattern. ensure_installed
    -- is passed directly to setup(); the .install() method no longer exists.
    -- lazy = false: the main branch README explicitly states it does not support
    -- lazy-loading.
    "nvim-treesitter/nvim-treesitter",
    version = false,
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
    config = function(_, opts)
      -- setup() accepts ensure_installed directly in the main branch API
      require("nvim-treesitter").setup(opts)

      -- Enable treesitter highlighting and indentation for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Set folding after treesitter loads (deferred from options.lua for faster startup)
      -- Use native Neovim 0.11+ foldexpr (faster than vimscript nvim_treesitter#foldexpr)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  },

  -- Treesitter textobjects.
  -- branch = "main": the main branch is a full rewrite. Config is no longer
  -- nested under nvim-treesitter.configs — it is a standalone plugin with an
  -- explicit setup() call and direct vim.keymap.set() calls per operation,
  -- replacing the old declarative opts.textobjects table.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local select = require "nvim-treesitter-textobjects.select"
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"

      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
      }

      -- Select textobjects
      for _, map in ipairs {
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
        { "aa", "@parameter.outer" },
        { "ia", "@parameter.inner" },
      } do
        vim.keymap.set({ "x", "o" }, map[1], function()
          select.select_textobject(map[2], "textobjects")
        end, { desc = "Select " .. map[2] })
      end

      -- Move: goto next start
      for _, map in ipairs {
        { "]f", "@function.outer" },
        { "]c", "@class.outer" },
        { "]a", "@parameter.inner" },
      } do
        vim.keymap.set({ "n", "x", "o" }, map[1], function()
          move.goto_next_start(map[2], "textobjects")
        end, { desc = "Next " .. map[2] .. " start" })
      end

      -- Move: goto next end
      for _, map in ipairs {
        { "]F", "@function.outer" },
        { "]C", "@class.outer" },
      } do
        vim.keymap.set({ "n", "x", "o" }, map[1], function()
          move.goto_next_end(map[2], "textobjects")
        end, { desc = "Next " .. map[2] .. " end" })
      end

      -- Move: goto previous start
      for _, map in ipairs {
        { "[f", "@function.outer" },
        { "[c", "@class.outer" },
        { "[a", "@parameter.inner" },
      } do
        vim.keymap.set({ "n", "x", "o" }, map[1], function()
          move.goto_previous_start(map[2], "textobjects")
        end, { desc = "Prev " .. map[2] .. " start" })
      end

      -- Move: goto previous end
      for _, map in ipairs {
        { "[F", "@function.outer" },
        { "[C", "@class.outer" },
      } do
        vim.keymap.set({ "n", "x", "o" }, map[1], function()
          move.goto_previous_end(map[2], "textobjects")
        end, { desc = "Prev " .. map[2] .. " end" })
      end

      -- Swap parameters
      vim.keymap.set("n", "<leader>sa", function()
        swap.swap_next "@parameter.inner"
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>sA", function()
        swap.swap_previous "@parameter.inner"
      end, { desc = "Swap prev parameter" })
    end,
  },

  -- Sticky context header (shows function/class scope at top)
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- VeryLazy: context header appears after first paint, not blocking initial render
    -- Still available for all editing; keys also trigger loading
    event = "VeryLazy",
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 20,
      mode = "cursor",
    },
    keys = {
      {
        "<leader>ut",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "UI: Toggle context",
      },
      {
        "gC",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Go to context",
      },
    },
  },
}
