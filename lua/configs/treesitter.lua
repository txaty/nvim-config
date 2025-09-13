local options = {
  ensure_installed = {
    "bash",
    "fish",
    "go",
    "gomod",
    "gowork",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "regex",
    "json",
    "typescript",
    "tsx",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
    "python",
    "rust",
    "c",
    "cpp",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
  auto_install = true,
}

require("nvim-treesitter.configs").setup(options)
