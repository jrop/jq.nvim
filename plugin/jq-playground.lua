if not vim.g.loaded_jq_playground then
  local defaults = require("jq-playground.config")

  local options = vim.tbl_deep_extend("force", defaults, vim.g.jq_playground or {})

  vim.api.nvim_create_user_command("JqPlayground", function(params)
    options["filename"] = params.fargs[1]
    require("jq-playground").init_playground(options)
  end, {
    desc = "Start jq query editor and live preview",
    nargs = "?",
    complete = "file",
  })
end
vim.g.loaded_jq_playground = true
