# jq-playground.nvim

> Interact with jq in Neovim using interactive buffers

![Example screenshot](example/screenshot.png)

Like [jqplay.org](https://jqplay.org) or Neovims builtin Treesitter playground
([`:InspectTree`](https://neovim.io/doc/user/treesitter.html#%3AInspectTree)).

> [!NOTE] Using the `setup()` function is deprecated. To upgrade, set
> `vim.g.jq_playground` to your config. Read more about this in the
> [Configuration](#configuration) section.

## Installation

The GitHub repository is at `"yochem/jq-playground.nvim"`. Use that in your
package manager. No other configuration needed.

The plugin is lazy-loaded on `:JqPlayground` and does not require any
lazy-loading configuration by the user.

## Configuration

All possible configuration and the default values can be found in
[`jq-playground/config.lua`](./lua/jq-playground/config.lua), but this is it:

```lua
-- notice how the configuration is handled via vim.g
vim.g.jq_playground = {
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
  disable_default_keymap = false,
}
```

- `split_direction`: can be `"left"`, `"right"`, `"above"` or `"below"`. The
  split direction of the output window is relative to the input window, and the
  query window is relative to the output window (they open after each other).
- `width` and `height`:
  - `nil`: use the default (half of current width/height)
  - `0-1`: percentage of current width/height
  - `>1`: absolute width/height in number of characters or lines
- `disable_default_keymap`: disables default `<CR>` map in the query window

Their are two commands that can be remapped: the user-command `:JqPlayground`
that starts the playground, and `<Plug>(JqPlaygroundRunQuery)`, that runs the
current query when pressed with the cursor in the query window. Remap them the
following way:

```lua
vim.keymap.set("n", "<leader>jq", vim.cmd.JqPlayground)

vim.keymap.set("n", "R", "<Plug>(JqPlaygroundRunQuery)")
```

## Usage

Navigate to a JSON file, and execute the command `:JqPlayground`. Two scratch
buffers will be opened: a buffer for the JQ-filter and one for displaying the
results. Simply press `<CR>` (enter), or your keymap from setup, in the query
window to refresh the results buffer.

You can also provide a filename to the `:JqPlayground` command. This is useful
if the JSON file is very large and you don't want to open it in Neovim
directly:

```vim
:JqPlayground sample.json
```

## Tips

Some random tips of useful builtin Nvim functionality that could be useful.

If you have a saved filter that you want to load into the filter window, then
run:

```vim
:r /path/to/some/query.jq
```

If you want to save the current query or output json, navigate to that buffer
and run:

```vim
:w path/to/save/query.jq
" or:
:w path/to/save/output.json
```

Start the JQ editor from the command line without loading the input file:

```
$ nvim +'JqPlayground input.json'
```
