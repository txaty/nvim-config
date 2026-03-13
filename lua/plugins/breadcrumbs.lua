-- dropbar.nvim: Clickable breadcrumb navigation in winbar
-- Replaces nvim-navic with interactive breadcrumbs (VS Code-style)

return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>lb",
        function()
          require("dropbar.api").pick()
        end,
        desc = "LSP: Breadcrumb pick",
      },
    },
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require "dropbar.sources"
          local utils = require "dropbar.utils"
          if vim.bo[buf].ft == "markdown" then
            return { sources.path, sources.markdown }
          end
          if vim.bo[buf].buftype == "terminal" then
            return { sources.terminal }
          end
          return {
            sources.path,
            utils.source.fallback {
              sources.lsp,
              sources.treesitter,
            },
          }
        end,
      },
    },
  },
}
