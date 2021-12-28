# nvim-gomove

A complete plugin for moving and duplicating blocks and lines, with complete fold handling, reindenting, and undoing in one go.

## Requirements

This plugin works with NeoVim v0.5 or later.

## Installation

- [packer.nvim](https://github.com/wbthoason/packer.nvim)

``` lua
use 'booperlv/nvim-gomove'
```

- [vim-plug](https://github.com/junegunn/vim-plug)

``` vim
Plug 'booperlv/nvim-gomove'
```

- [paq](https://github.com/savq/paq-nvim)

``` lua
'booperlv/nvim-gomove';
```


## Why nvim-gomove?

As many may know, mappings such as "ddp", and ":move" already exist as solutions to moving lines. What makes nvim-gomove any different, and what are it's goals?

nvim-gomove actually makes use of these same solutions, but just with a little more on top. It's a wrapper that polishes and tries to make these solutions as complete as possible, by dealing with folds, undoing, trailing whitespaces and reindenting for you.

It may not be for everyone, but it might be helpful for the few that would like it :)

## Features

### Moving and Duplicating (Vertically and Horizontally):
- Lines in Normal Mode
- Lines in Visual Mode
- Blocks in Normal Mode
- Blocks in Visual Mode

### With the following additional features:
- Full Fold Handling
- Undoing in one go
- Deleting Trailing Whitespaces (Block Vertical)
- Reindenting

## Usage

The default "smart" move mappings work this way:

| Mapping | Normal | Visual | Line-Visual | Block-Visual |
|---------|--------|--------|-------------|--------------|
| \<A-h\> | Block Left | Block Left | Line Left | Block Left |
| \<A-j\> | Line Down | Line Down | Line Down | Block Down |
| \<A-k\> | Line Up | Line Up | Line Up | Block Up |
| \<A-l\> | Block Right | Block Right | Line Right | Block Right |

#### \<A-S-(h/j/k/l)\> duplicates respectively

## Configuration

```lua
lua require("gomove").setup {
  -- whether or not to map default key bindings, (true/false)
  map_defaults = true,
  -- what method to use for reindenting, ("vim-move" / "simple" / ("none"/nil))
  reindent_mode = "vim-move",
  -- whether to not to move past line when moving blocks horizontally, (true/false)
  move_past_line = false,
  -- whether or not to ignore indent when duplicating lines horizontally, (true/false)
  ignore_indent_lh_dup = true,
}
```

## Special Mentions

- [matze/vim-move](https://github.com/matze/vim-move), much of the initial work was based on this plugin
- [t9md/vim-textmanip](https://github.com/t9md/vim-textmanip): many features were made possible using this plugin as a reference
