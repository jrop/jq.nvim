local kmap = vim.keymap.set
local ucmd = vim.api.nvim_create_user_command

function buf_text(bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_win_get_buf(0)
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), true)
  local text = ''
  for i, line in ipairs(lines) do
    text = text .. line .. '\n'
  end
  return text
end

function set_buf_text(text, bufnr)
  if bufnr == nil then
    bufnr = vim.fn.bufnr('%')
  end

  if type(text) == 'string' then
    text = vim.fn.split(text, '\n')
  end

  vim.api.nvim_buf_set_lines(
    bufnr,
    0,
    -1,
    false,
    text
  )
end

function jq_filter(json_bufnr, jq_filter)
  -- spawn jq and pipe in json, returning the output text
  local modified = vim.bo[json_bufnr].modified
  local fname = vim.fn.bufname(json_bufnr)

  if (not modified) and fname ~= '' then
    -- the following should be faster as it lets jq read the file contents
    return vim.fn.system({ 'jq', jq_filter, fname })
  else
    local json = buf_text(json_bufnr)
    return vim.fn.system({ 'jq', jq_filter }, json)
  end
end

function Jq_command(horizontal)
  local splitcmd = 'vnew'
  if horizontal == true then
    splitcmd = 'new'
  end

  local json_bufnr = vim.fn.bufnr()

  vim.cmd(splitcmd)
  vim.cmd'set filetype=jq'
  set_buf_text('# JQ filter: press <CR> to execute it\n\n.')
  vim.cmd'normal!G'
  local jq_bufnr = vim.fn.bufnr()
  local jq_winnr = vim.fn.bufwinid(jq_bufnr)

  vim.cmd(splitcmd)
  vim.cmd'set filetype=json'
  local result_bufnr = vim.fn.bufnr()


  vim.fn.win_gotoid(jq_winnr)

  -- setup keybinding autocmd in the filter buffer:
  kmap(
    'n',
    '<CR>',
    function()
      local filter = buf_text(jq_bufnr)
      set_buf_text(jq_filter(json_bufnr, filter), result_bufnr)
    end,
    { buffer = jq_bufnr }
  )
end

ucmd('Jq', function()
  Jq_command(false)
end, {})

ucmd('Jqhorizontal', function()
  Jq_command(true)
end, {})
