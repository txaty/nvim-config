-- Document preparation systems: LaTeX (vimtex) and Typst
return {
  -- LaTeX support with vimtex
  {
    "lervag/vimtex",
    ft = "tex",
    lazy = true,
    config = function()
      -- Set Zathura as the PDF viewer
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = "zathura"
      vim.g.vimtex_view_general_options = "--synctex-forward @line:@col:@file build/@pdf"

      -- Disable concealment for better readability
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Configure the compiler method to use latexmk with pdflatex
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build", -- Use 'build' directory for output files
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf", -- Compile to PDF using pdflatex
          "-synctex=1", -- Enable SyncTeX for forward and inverse search
          "-interaction=nonstopmode", -- Continue compiling even if errors occur
          "-file-line-error", -- Display errors with file and line number
          "-aux-directory=build",
          "-output-directory=build",
        },
      }

      -- Configure diagnostic display settings
      vim.diagnostic.config {
        virtual_text = true, -- Show inline warnings/errors
        signs = true, -- Show signs in the gutter
        underline = true, -- Underline problematic text
        severity_sort = true, -- Sort diagnostics by severity
        update_in_insert = false,
      }

      -- Automatically open the quickfix window on warnings
      vim.g.vimtex_quickfix_open_on_warning = 1
    end,
  },

  -- Typst support with live preview
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function()
      require("typst-preview").update()
    end,
  },
}
