local options = {
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    mode = "exact",
  },
  jump = {
    autojump = false,
  },
  label = {
    uppercase = false,
    rainbow = {
      enabled = true,
      shade = 5,
    },
  },
  modes = {
    char = {
      enabled = true,
      -- dynamic configuration for ftFT motions
      config = function(opts)
        -- autohide flash when in operator-pending mode
        opts.autohide = vim.fn.mode(true):find "no" and vim.v.operator == "y"
        -- show jump labels only for the operator-pending mode
        -- opts.jump_labels = vim.fn.mode(true):find "o"
      end,
    },
  },
}

return options
