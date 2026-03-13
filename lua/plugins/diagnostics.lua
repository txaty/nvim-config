-- tiny-inline-diagnostic.nvim: Styled inline diagnostics
-- Replaces default virtual_text with prettier rendering

return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000, -- Ensure it loads before other diagnostic plugins
    config = function()
      -- Only activate when diagnostic_lines toggle is off
      local ui_toggle_ok, ui_toggle = pcall(require, "core.ui_toggle")
      if ui_toggle_ok and ui_toggle.get "diagnostic_lines" then
        -- diagnostic_lines mode is active, don't override
        return
      end

      -- Disable default virtual_text since tiny-inline-diagnostic renders its own
      vim.diagnostic.config { virtual_text = false }

      require("tiny-inline-diagnostic").setup {
        preset = "modern",
        options = {
          show_source = true,
          multilines = true,
          throttle = 100,
        },
      }
    end,
  },
}
