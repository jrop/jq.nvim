local M = {}

M.check = function()
  vim.health.start("Configuration")
  if vim.g.jq_playground == nil then
    vim.health.info("no user configuration found: vim.g.jq_playground does not exist")
  else
    -- TODO: validate config
    vim.health.ok("user configuration found: vim.g.jq_playground exists")
  end
  -- TODO: check if lazy loaded
end

return M
