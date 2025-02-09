local obsidian_base = "/Users/tommytian/Library/Mobile Documents/iCloud~md~obsidian/Documents"

return {
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },

    init = function()
      local vaults = { "tommy", "financial-accounting", "learn-rust" }
      local events = {}

      for _, vault in ipairs(vaults) do
        table.insert(events, obsidian_base .. "/" .. vault .. "/**.md")
      end

      vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = events,
        callback = function()
          require("lazy").load { plugins = { "obsidian.nvim" } }
        end,
      })
    end,

    opts = {
      workspaces = {
        { name = "tommy", path = obsidian_base .. "/tommy" },
        { name = "financial-accounting", path = obsidian_base .. "/financial-accounting" },
        { name = "learn-rust", path = obsidian_base .. "/learn-rust" },
      },
      daily_notes = { folder = "diary" },
      completion = { nvim_cmp = true },
    },

    config = function(_, opts)
      require("obsidian").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.schedule(function()
            require("cmp").setup.buffer { sources = { { name = "obsidian" } } }
          end)
        end,
      })
      vim.o.conceallevel = 2
    end,
  },
}
