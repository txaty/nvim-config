local web_ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }

return {
  {
    "windwp/nvim-ts-autotag",
    ft = web_ft,
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    ft = web_ft,
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = web_ft,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require "dap.web"
    end,
  },
}
