return {
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_view_method = "zathura" -- or 'skim', 'okular', etc.
      vim.g.vimtex_compiler_progname = "nvr"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = {
        ["_"] = "-xelatex",
      }
      vim.g.vimtex_quickfix_mode = 2
      vim.diagnostic.config({
        virtual_text = true, -- Show inline warnings/errors
        signs = true, -- Show signs in the gutter
        underline = true, -- Underline problematic text
        severity_sort = true, -- Sort diagnostics by severity
        update_in_insert = false,
      })
      vim.g.vimtex_quickfix_open_on_warning = 1
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "out",
        aux_dir = "out",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-xelatex",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-file-line-error",
          "-aux-directory=out",
          "-output-directory=out",
          "main.tex",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              diagnostics = {
                ignoredPatterns = { "Unused label", "Undefined reference" },
              },
              build = {
                executable = "latexmk",
                args = {
                  "-xelatex",
                  "-synctex=1",
                  "-interaction=nonstopmode",
                  "-file-line-error",
                  "-aux-directory=out",
                  "-output-directory=out",
                  "main.tex",
                },
                -- onSave = true,
              },
              forwardSearch = {
                executable = "sioyek",
                args = {
                  "--reuse-instance",
                  "--forward-search",
                  "%f:%l",
                  "%p",
                  "--inverse-search",
                  "nvim --headless -c 'e %f' -c 'call cursor(%l, 1)'",
                },
              },
            },
          },
        },
      },
    },
  },
}
