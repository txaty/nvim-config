return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    -- KNOWN LIMITATION: Loads on InsertEnter (after LSP starts on BufReadPre)
    --
    -- Impact: LSP capabilities don't include blink.cmp enhancements initially.
    -- LSP servers start with base capabilities, completion falls back to omnifunc.
    --
    -- Why: Loading blink on BufReadPre would add ~50ms to startup time, even for
    -- users who never enter insert mode (reading code, navigating, etc.).
    --
    -- Acceptable: Completion still works via omnifunc fallback. Blink features
    -- (fuzzy matching, snippets, etc.) become available after first InsertEnter.
    --
    -- Alternative: Change event to { "BufReadPre", "BufNewFile" } for immediate
    -- capability enhancement at cost of slower startup.
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "none",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = { preselect = false, auto_insert = false } },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
            fallbacks = { "lsp" },
          },
        },
      },
      signature = { enabled = false }, -- let noice.nvim handle signature help
    },
  },
}
