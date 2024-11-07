local M = {}

-- TODO: fix code duplication
local function show_error(msg)
  vim.notify("jq-playground: " .. msg, vim.log.levels.ERROR, {})
end

function M.setup(opts)
  local defaults = require("jq-playground.config")

  local global_config = vim.g.jq_playground or {}
  local setup_config = opts or {}

  if not vim.tbl_isempty(global_config) and not vim.tbl_isempty(setup_config) then
    show_error("Two configs detected: vim.g.jq_playground and setup(). Use only one.")
  end

  -- vim.g.jq_playground, then opts, then defaults
  vim.g.jq_playground = vim.tbl_deep_extend(
    "force",
    defaults,
    setup_config,
    global_config
  )

  vim.api.nvim_create_user_command("JqPlayground", function(params)
    require("jq-playground.playground").init_playground(params.fargs[1])
  end, {
    desc = "Start jq query editor and live preview",
    nargs = "?",
    complete = "file",
  })
end

return M
