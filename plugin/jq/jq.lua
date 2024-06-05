local function user_preferred_indent(json_bufnr)
  local prefer_tabs = not vim.bo[json_bufnr].expandtab
  if prefer_tabs then
    return '--tab'
  else
    local indent_width = vim.bo[json_bufnr].softtabstop
    return '--indent' .. indent_width
  end
end

local function run_query(input_bufnr, query_bufnr, output_bufnr)
  local filter_lines = vim.api.nvim_buf_get_lines(query_bufnr, 0, -1, false)
  local filter = table.concat(filter_lines, '\n')

  local cmd = { 'jq', filter, user_preferred_indent(output_bufnr) }
  local stdin = nil

  local modified = vim.bo[input_bufnr].modified
  local fname = vim.api.nvim_buf_get_name(input_bufnr)

  -- TODO: check if file actually exists?
  if (not modified) and fname ~= '' then
    -- the following should be faster as it lets jq read the file contents
    table.insert(cmd, fname)
  else
    stdin = vim.api.nvim_buf_get_lines(input_bufnr, 0, -1, false)
  end

  local result = vim.system(cmd, { stdin = stdin }):wait()

  -- TODO work with wrong output
  local lines = vim.split(result.stdout, '\n', { plain = true })
  vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, lines)
end

local function setup_query_buffer()
  -- creates scratch (:h scratch-buffer) buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  local winid = vim.api.nvim_open_win(bufnr, true, {
    split = 'below',
    height = math.floor(0.3 * vim.api.nvim_win_get_height(0)),
  })

  vim.bo[bufnr].filetype = 'jq'
  vim.api.nvim_buf_set_name(bufnr, 'jq query editor')
  vim.cmd.startinsert()

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    '# JQ filter: press <CR> in normal mode to execute.',
    '',
    '',
  })
  vim.api.nvim_win_set_cursor(winid, { 3, 0 })

  return bufnr
end

local function setup_output_buffer()
  -- creates scratch (:h scratch-buffer) buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(bufnr, true, {
    split = 'right',
  })

  vim.bo[bufnr].filetype = 'json'
  vim.api.nvim_buf_set_name(bufnr, 'jq output')

  return bufnr
end

local function setup_jq_buffers(opts)
  local input_json_bufnr = vim.api.nvim_get_current_buf()

  local output_json_bufnr = setup_output_buffer()
  local query_bufnr = setup_query_buffer()

  vim.keymap.set('n', '<CR>', function()
    run_query(input_json_bufnr, query_bufnr, output_json_bufnr)
  end, {
    buffer = query_bufnr,
    silent = true,
    desc = 'jq.nvim: run current jq query'
  })
end

vim.api.nvim_create_user_command('Jq', function()
  setup_jq_buffers({})
end, {})

vim.api.nvim_create_user_command('Jqhorizontal', function()
  setup_jq_buffers({})
end, {})
