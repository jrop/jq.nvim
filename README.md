# jq.nvim

> Interact with `jq` in Vim, using interactive buffers

## Installation

```lua
use 'jrop/jq.nvim'
```

## Use

Navigate to a JSON file, and execute the command `:Jq`. Two vertical buffers
will be opened: the first is the JQ-filter, and the third is for displaying
results. Simply press `<CR>` (enter) in the filter window to refresh the results
buffer. If you like horizontal splits instead of vertical ones, the use
`:Jqhorizontal`.

**Tips**: The `:Jq` command sets up its own buffer that houses the JQ filter
additionally setting up the keymap necessary to refresh the results buffer. If
you have a saved filter that you want to load into the filter window, then run:

```
:r /path/to/some/query.jq
```

## Dependencies

- `jq` Must be installed and in your `$PATH`

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
