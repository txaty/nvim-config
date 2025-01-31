local options = {
  ensure_installed = {
    "bash",
    "fish",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "lua",
    "luadoc",
    "markdown",
    "printf",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
    "python",
    "rust",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
