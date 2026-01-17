-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "aylin",
  transparency = false,
  theme_toggle = { "aylin", "flexoki-light" },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

-- Conditionally disable nvdash when starting with a directory
-- This prevents window conflicts when opening nvim-tree
local function should_load_nvdash()
  -- Check if we're starting with a directory argument
  local args = vim.fn.argv()
  if #args > 0 then
    return vim.fn.isdirectory(args[1]) ~= 1
  end
  return true
end

M.nvdash = { load_on_startup = should_load_nvdash() }

M.ui = {
  tabufline = {
    lazyload = false,
  },

  telescope = {
    style = "borderless",
  },
}

return M
