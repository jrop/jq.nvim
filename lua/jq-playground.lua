local M = {}

local function user_preferred_indent(json_bufnr)
  local prefer_tabs = not vim.bo[json_bufnr].expandtab
  if prefer_tabs then
    return { "--tab" }
  else
    local indent_width = vim.bo[json_bufnr].softtabstop
    return { "--indent", indent_width }
  end
end

local function run_query(input, query_bufnr, output_bufnr)
  local filter_lines = vim.api.nvim_buf_get_lines(query_bufnr, 0, -1, false)
  local filter = table.concat(filter_lines, "\n")
  local cmd = { "jq", filter }
  vim.list_extend(cmd, user_preferred_indent(output_bufnr))
  local stdin = nil

  if type(input) == "number" and vim.api.nvim_buf_is_valid(input) then
    local modified = vim.bo[input].modified
    local fname = vim.api.nvim_buf_get_name(input)

    -- TODO: check if file actually exists?
    if (not modified) and fname ~= "" then
      -- the following should be faster as it lets jq read the file contents
      table.insert(cmd, fname)
    else
      stdin = vim.api.nvim_buf_get_lines(input, 0, -1, false)
    end
  elseif type(input) == "string" and vim.fn.filereadable(input) == 1 then
    table.insert(cmd, input)
  else
    error("invalid input: " .. input)
  end
  local ok, process = pcall(vim.system, cmd, { stdin = stdin })

  if not ok then
    error("jq is not installed or not on your $PATH")
  end

  local result = process:wait()
  local output = result.code == 0 and result.stdout or result.stderr

  local lines = vim.split(output, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, lines)
end

local function create_split(bufnr, winopts)
  local width = winopts.width
  local height = winopts.height

  if height ~= nil and height < 1 then
    height = math.floor(height * vim.api.nvim_win_get_height(0))
  end

  if width ~= nil and width < 1 then
    width = math.floor(width * vim.api.nvim_win_get_width(0))
  end

  local winid = vim.api.nvim_open_win(bufnr, true, {
    split = winopts.split_direction,
    width = width,
    height = height,
  })

  return winid
end

local function create_query_buffer(winopts)
  -- creates scratch (:h scratch-buffer) buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  local winid = create_split(bufnr, winopts)

  vim.bo[bufnr].filetype = "jq"
  vim.api.nvim_buf_set_name(bufnr, "jq query editor")
  vim.cmd.startinsert()

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    "# JQ filter: press <CR> in normal mode to execute.",
    "",
    "",
  })
  vim.api.nvim_win_set_cursor(winid, { 3, 0 })

  return bufnr
end

local function create_output_buffer(winopts)
  -- creates scratch (:h scratch-buffer) buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  create_split(bufnr, winopts)

  vim.bo[bufnr].filetype = "json"
  vim.api.nvim_buf_set_name(bufnr, "jq output")

  return bufnr
end

local function start_jq_buffers(opts)
  local input_json_bufnr = vim.api.nvim_get_current_buf()

  local output_json_bufnr = create_output_buffer(opts.output_window)
  local query_bufnr = create_query_buffer(opts.query_window)

  vim.keymap.set("n", "<CR>", function()
    run_query(opts.filename or input_json_bufnr, query_bufnr, output_json_bufnr)
  end, {
    buffer = query_bufnr,
    silent = true,
    desc = "Run current jq query",
  })
end

function M.setup(opts)
  local defaults = {
    output_window = {
      split_direction = "right",
      width = nil,
      height = nil,
    },
    query_window = {
      split_direction = "below",
      width = nil,
      height = 0.3,
    },
  }

  -- overwrite default options
  local options = vim.tbl_extend("force", defaults, opts)

  vim.api.nvim_create_user_command("JqPlayground", function(params)
    -- also possible to use jq-playground without a source buffer
    options["filename"] = params.fargs[1]
    start_jq_buffers(options)
  end, {
    desc = "Start jq query editor and live preview",
    nargs = "?",
    complete = "file",
  })
end

return M
