return {
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {
      open_cmd = "vnew",
      live_update = true, -- Auto-update when typing
      line_sep_start = "┌-----------------------------------------",
      result_padding = "¦  ",
      line_sep = "└-----------------------------------------",
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffAdd",
      },
      mapping = {
        ["toggle_line"] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').actions.run_current_replace_line()<CR>",
          desc = "toggle line",
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "open file",
        },
        ["send_to_qf"] = {
          map = "tq",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix",
        },
        ["replace_cmd"] = {
          map = "tc",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "input replace command",
        },
        ["show_option_menu"] = {
          map = "to",
          cmd = "<cmd>lua require('spectre.actions').show_options()<CR>",
          desc = "show options",
        },
        ["run_current_replace"] = {
          map = "tr",
          cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          desc = "replace current line",
        },
        ["run_replace"] = {
          map = "tR",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "replace all",
        },
        ["change_view_mode"] = {
          map = "tv",
          cmd = "<cmd>lua require('spectre.actions').change_view()<CR>",
          desc = "change result view mode",
        },
        ["change_replace_sed"] = {
          map = "trs",
          cmd = "<cmd>lua require('spectre.actions').toggle_engine()<CR>",
          desc = "toggle engine (sed)",
        },
        ["toggle_live_update"] = {
          map = "tu",
          cmd = "<cmd>lua require('spectre').actions.toggle_live_update()<CR>",
          desc = "update when type",
        },
        ["toggle_ignore_case"] = {
          map = "ti",
          cmd = "<cmd>lua require('spectre').actions.toggle_ignore_case()<CR>",
          desc = "toggle ignore case",
        },
        ["toggle_ignore_hidden"] = {
          map = "th",
          cmd = "<cmd>lua require('spectre.actions').toggle_ignore_hidden()<CR>",
          desc = "toggle ignore hidden",
        },
      },
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = nil,
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case",
            },
          },
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "ignore-case" },
        },
        replace = {
          cmd = "sed",
        },
      },
      replace_vim_cmd = "cdo",
      is_open_target_win = true, -- open file in other window if possible
      is_insert_mode = false, -- start open panel on visual mode
    },
    keys = {
      {
        "<leader>S",
        function()
          require("spectre").toggle()
        end,
        desc = "Spectre: toggle search & replace",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual { select_word = true }
        end,
        desc = "Spectre: search current word",
      },
    },
  },
}
