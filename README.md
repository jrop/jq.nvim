# jq-playground.nvim

> Interact with `jq` in Vim, using interactive buffers

![Example screenshot](example/screenshot.png)

Like Neovims builtin Treesitter playground
([`:InspectTree`](https://neovim.io/doc/user/treesitter.html#%3AInspectTree)).

## Installation

With lazy.nvim:

```lua
{
  "yochem/jq-playground.nvim",
  config = true, -- use default configuration
}
```

If you use another package manager than lazy.nvim, make sure to run the setup
function to register the `:JqPlayground` command:

```lua
-- use default configuration
require("jq-playground").setup()
```

## Configuration

There are options available for positioning the different windows. These are
the defaults:

```lua
require("jq-playground").setup({
  output_window = {
    split_direction = "right",
    width = nil,
    height = nil,
  },
  query_window = {
    split_direction = "bottom",
    width = nil,
    height = 0.3,
  },
})
```

The `split_direction` can be `"left"`, `"right"`, `"above"` or `"below"`. The
split direction of the output window is relative to the input window, and the
query window is relative to the output window.

The `width` and `height` values can be nil, meaning half of the current
width/height, a decimal number under 1, being the percentage of the current
width/height or a number above 1, being the absolute width/height in characters
or lines.


## Use

Navigate to a JSON file, and execute the command `:JqPlayground`. Two scratch
buffers will be opened: a buffer for the JQ-filter and one for displaying the
results. Simply press `<CR>` (enter) in the filter window to refresh the
results buffer.

## Tips

If you have a saved filter that you want to load into the filter window, then
run:

```
:r /path/to/some/query.jq
```

If you want to save the current query or output json, navigate to that buffer
and run:

```
:w /path/to/save/{query.jq,output.json}
```

If you want to use a keymap instead of the `:JqPlayground` command, use this:

```lua
vim.keymap.set('n', '<leader>jq', vim.cmd.JqPlayground)
```

## Dependencies

- `jq` Must be installed and in your `$PATH`.

## License (MIT)

The MIT License (MIT)
Copyright © 2022 Jonathan Apodaca <jrapodaca@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the “Software”), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
