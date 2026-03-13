local M = {}

function M.enabled(flag)
  return vim.g[flag] == true
end

function M.confirm(prompt)
  return vim.fn.confirm(prompt, "&Proceed\n&Cancel", 2) == 1
end

function M.confirm_external(action, target)
  local prompt = target and string.format("%s\n\nTarget: %s", action, target) or action
  return M.confirm(prompt)
end

return M
