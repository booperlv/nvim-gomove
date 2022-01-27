# nvim-gomove

A complete plugin for moving and duplicating blocks and lines, with complete fold handling, reindenting, and undoing in one go.

https://user-images.githubusercontent.com/65604882/147652973-62e30299-946d-4924-8766-0366016f70de.mp4

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
require("gomove").setup {
  -- whether or not to map default key bindings, (true/false)
  map_defaults = true,
  -- whether or not to reindent lines moved vertically (true/false)
  reindent = true,
  -- whether or not to undojoin same direction moves (true/false)
  undojoin = true,
  -- whether to not to move past end column when moving blocks horizontally, (true/false)
  move_past_end_col = false,
}
```

## Mappings

While there are default mappings, called "smart mappings" that are designed to
be as intuitive as possible out of the box - that itself is built on "base"
mappings which can serve as a framework for creating your own mappings. Check
gomove/mappings/smart.lua as an example of the usage of the "base" mappings.

## Example for Changing Default (Smart) Keybinds:

Just a reminder to set the option `map_defaults = false` in the setup function

```vim
nmap <S-h> <Plug>GoNSMLeft
nmap <S-j> <Plug>GoNSMDown
nmap <S-k> <Plug>GoNSMUp
nmap <S-l> <Plug>GoNSMRight

xmap <S-h> <Plug>GoVSMLeft
xmap <S-j> <Plug>GoVSMDown
xmap <S-k> <Plug>GoVSMUp
xmap <S-l> <Plug>GoVSMRight

nmap <C-h> <Plug>GoNSDLeft
nmap <C-j> <Plug>GoNSDDown
nmap <C-k> <Plug>GoNSDUp
nmap <C-l> <Plug>GoNSDRight

xmap <C-h> <Plug>GoVSDLeft
xmap <C-j> <Plug>GoVSDDown
xmap <C-k> <Plug>GoVSDUp
xmap <C-l> <Plug>GoVSDRight
```

```lua
local map = vim.api.nvim_set_keymap

map( "n", "<S-h>", "<Plug>GoNSMLeft", {} )
map( "n", "<S-j>", "<Plug>GoNSMDown", {} )
map( "n", "<S-k>", "<Plug>GoNSMUp", {} )
map( "n", "<S-l>", "<Plug>GoNSMRight", {} )

map( "x", "<S-h>", "<Plug>GoVSMLeft", {} )
map( "x", "<S-j>", "<Plug>GoVSMDown", {} )
map( "x", "<S-k>", "<Plug>GoVSMUp", {} )
map( "x", "<S-l>", "<Plug>GoVSMRight", {} )

map( "n", "<C-h>", "<Plug>GoNSDLeft", {} )
map( "n", "<C-j>", "<Plug>GoNSDDown", {} )
map( "n", "<C-k>", "<Plug>GoNSDUp", {} )
map( "n", "<C-l>", "<Plug>GoNSDRight", {} )

map( "x", "<C-h>", "<Plug>GoVSDLeft", {} )
map( "x", "<C-j>", "<Plug>GoVSDDown", {} )
map( "x", "<C-k>", "<Plug>GoVSDUp", {} )
map( "x", "<C-l>", "<Plug>GoVSDRight", {} )
```


## Smart Mappings:

```
Naming Convention:
Go, Normal/Visual, Smart, Move/Duplicate, Direction
```

| Name | Function |
|------|----------|
| Vertical |
| \<Plug\>GoNSM(Up/Down) | Normal Smart Move Up/Down |
| \<Plug\>GoVSM(Up/Down) | Visual Smart Move Up/Down |
| \<Plug\>GoNSD(Up/Down) | Normal Smart Duplicate Up/Down |
| \<Plug\>GoVSD(Up/Down) | Visual Smart Duplicate Up/Down |
| Horizontal |
| \<Plug\>GoNSM(Left/Right) | Normal Smart Move Left/Right |
| \<Plug\>GoVSM(Left/Right) | Visual Smart Move Left/Right |
| \<Plug\>GoNSD(Left/Right) | Normal Smart Duplicate Left/Right |
| \<Plug\>GoVSD(Left/Right) | Visual Smart Duplicate Left/Right |

### Functionality is already explained in [Usage](#usage)

## Base Mappings:

```
Naming Convention:
Go, Normal/Visual, Move/Duplicate, Line/Block, Direction
```

### Lines:

| Name | Function |
|------|----------|
| Vertical |
| \<Plug\>GoNMLine(Down/Up) | In Normal Mode, Move current line down/up. Moves along folds. |
| \<Plug\>GoNVLine(Down/Up) | In Visual Mode, Move selected lines down/up. Moves along folds. |
| \<Plug\>GoNDLine(Down/Up) |  In Normal Mode, Duplicate current line down/up. |
| \<Plug\>GoVDLine(Down/Up) | In Visual Mode, Duplicate selected lines down/up. |
| Horizontal |
| \<Plug\>GoNMLine(Left/Right) | In Normal Mode, Move current line to the left/right by (indent level). |
| \<Plug\>GoVMLine(Left/Right) | In Visual Mode, Move selected lines to the left/right by (indent level). |
| \<Plug\>GoNDLine(Left/Right) | In Normal Mode, Duplicate current line to the left/right. Duplicating left ignores whitespace at the start of the text that it duplicates. |
| \<Plug\>GoVDLine(Left/Right) | In Visual Mode, Duplicate selected lines to the left/right. Duplicating left ignores whitespace at the start of the text that it duplicates. |

### Blocks: 

| Name | Function |
|------|----------|
| Vertical |
| \<Plug\>GoNMBlock(Down/Up) | In Normal Mode, Move current character down/up. Tries to avoid folds. |
| \<Plug\>GoVMBlock(Down/Up) | In Visual Mode, Move selected characters down/up. Tries to avoid folds. |
| \<Plug\>GoNDBlock(Down/Up) | In Normal Mode, Duplicate current character down/up. Tries to avoid folds. |
| \<Plug\>GoVDBlock(Down/Up) | In Visual Mode, Duplicate selected characters down/up. Tries to avoid folds. |
| Horizontal |
| <Plug>GoNMBlock(Left/Right) | In Normal Mode, Move current character left/right. |
| <Plug>GoVMBlock(Left/Right) | In Visual Mode, Move selected characters left/right. |
| <Plug>GoNDBlock(Left/Right) | In Normal Mode, Duplicate current character left/right. |
| <Plug>GoVDBlock(Left/Right) | In Visual Mode, Duplicate selected characters left/right. |


## Special Mentions

- [matze/vim-move](https://github.com/matze/vim-move), much of the initial work was based on this plugin
- [t9md/vim-textmanip](https://github.com/t9md/vim-textmanip): many features were made possible using this plugin as a reference
