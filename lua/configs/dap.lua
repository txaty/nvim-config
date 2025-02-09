local M = {}

M.load_dap_for_language = function(lang)
  local dap_config_file = string.format("dap/%s", lang)
  local ok, _ = pcall(require, dap_config_file)
  if not ok then
    vim.notify(string.format("[DAP] No DAP config found for %s", lang), vim.log.levels.WARN)
  end
end

return M
