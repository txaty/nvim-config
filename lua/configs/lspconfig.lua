local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { enable = false },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gotmpl", "gowork" },
    root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        completeUnimported = true,
        usePlaceholders = true,
        staticcheck = true,
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "strict",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          typeHints = true,
          autoImportCompletions = true,
        },
      },
    },
  },
  texlab = {
    settings = {
      texlab = {
        build = { executable = "", args = {}, onSave = false },
        latexFormatter = "none",
        bibtexFormatter = "none",
        chktex = { onEdit = false, onOpenAndSave = false },
      },
    },
  },
  tinymist = {
    settings = { exportPdf = "onSave" },
  },
  ts_ls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", ".git"),
    settings = { completions = { completeFunctionCalls = true } },
  },
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = require("lspconfig").util.root_pattern("compile_commands.json", ".git"),
  },
}

-- Import NVChad’s default LSP functions
local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

local function on_attach(client, bufnr)
  -- Call NVChad’s default on_attach
  if nvlsp.on_attach then
    nvlsp.on_attach(client, bufnr)
  end

  -- Attach vim-illuminate
  if client.server_capabilities.documentHighlightProvider then
    require("illuminate").on_attach(client)
  end
end

for server, config in pairs(servers) do
  local ok, _ = pcall(function()
    lspconfig[server].setup(vim.tbl_extend("force", {
      on_attach = on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }, config))
  end)
  if not ok then
    vim.notify("Failed to load LSP: " .. server, vim.log.levels.WARN)
  end
end

lspconfig.servers = {}
for server, _ in pairs(servers) do
  table.insert(lspconfig.servers, server)
end
