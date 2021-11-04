
--This is a basis for the mappings, which finalizes the positions of the cursor
--after the move, and handles reselecting. Users of the plugin can also create
--their own kind of "Smart" Mappings as demonstrated in gomove.mappings.smart

local M = {}

-------------LINES-------------

local line_vertical = require('gomove.selection.line.vertical')
local line_horizontal = require('gomove.selection.line.horizontal')

function M.MoveLineVertical(distance)
  local prev_col = vim.fn.col(".")
  local prev_indent = vim.fn.indent(".")
    line_vertical.move('.', '.', distance)
  local new_indent = vim.fn.indent(".")
  vim.fn.cursor(
    vim.fn.line('.'),
    math.max(1, prev_col - prev_indent + new_indent)
  )
end

function M.MoveLineHorizontal(distance)
  local prev_col = vim.f.col(".")
  local prev_indent = vim.fn.indent(".")
    line_horizontal.move('.', '.', distance)
  local new_indent = vim.fn.indent(".")
  vim.fn.cursor(
    vim.fn.line('.'),
    math.max(1, prev_col - prev_indent + new_indent)
  )
end

function M.DuplicateLineVertical(distance)
  local prev_col = vim.fn.col(".")
  local prev_indent = vim.fn.indent(".")
    line_vertical.duplicate('.', '.', distance)
  local new_indent = vim.fn.indent(".")
  vim.fn.cursor(
    vim.fn.line('.'),
    math.max(1, prev_col - prev_indent + new_indent)
  )
end

function M.DuplicateLineHorizontal(distance)
  local prev_col = vim.fn.col(".")
  local prev_length = vim.fn.col("$")
    line_horizontal.duplicate('.', '.', distance)
  local new_length = vim.fn.col("$")
  vim.fn.cursor(
    vim.fn.line('.'),
    math.max(1, prev_col - prev_length + new_length)
  )
end

-------------VISUAL LINES-------------

function M.VisualMoveLineVertical(distance)
  vim.cmd('normal! gv')
  if line_vertical.move("'<", "'>", distance) then
    vim.cmd('normal! g`[Vg`]')
  end
end

function M.VisualMoveLineHorizontal(distance)
  line_horizontal.move("'<", "'>", distance)
  vim.cmd("normal! gv")
end

function M.VisualDuplicateLineVertical(distance)
  vim.cmd('normal! gv')
  if line_vertical.duplicate("'<", "'>", distance) then
    vim.cmd('normal! g`[Vg`]')
  end
end

function M.VisualDuplicateLineHorizontal(distance)
  line_horizontal.duplicate("'<", "'>", distance)
  vim.cmd("normal! gv")
end



-------------BLOCKS-------------

local block_vertical = require('gomove.selection.block.vertical')
local block_horizontal = require('gomove.selection.block.horizontal')

function M.MoveBlockVertical(distance)
  block_vertical.move('.', '.', distance)
end

function M.MoveBlockHorizontal(distance)
  block_horizontal.move('.', '.', distance)
end

function M.DuplicateBlockVertical(distance)
  block_vertical.duplicate('.', '.', distance)
end

function M.DuplicateBlockHorizontal(distance)
  block_horizontal.duplicate('.', '.', distance)
end

-------------VISUAL BLOCKS-------------

function M.VisualMoveBlockVertical(distance)
  vim.cmd('execute "normal! g`<\\<C-v>g`>"')
  if block_vertical.move("'<", "'>", distance) then
    vim.cmd('execute "normal! g`[\\<C-v>g`]"')
  end
end

function M.VisualMoveBlockHorizontal(distance)
  vim.cmd('execute "normal! g`<\\<C-v>g`>"')
  if block_horizontal.move("'<", "'>", distance) then
    vim.cmd('execute "normal! g`[\\<C-v>g`]"')
  end
end

function M.VisualDuplicateBlockVertical(distance)
  vim.cmd('execute "normal! g`<\\<C-v>g`>"')
  if block_vertical.duplicate("'<", "'>", distance) then
    vim.cmd('execute "normal! g`[\\<C-v>g`]"')
  end
end

function M.VisualDuplicateBlockHorizontal(distance)
  vim.cmd('execute "normal! g`<\\<C-v>g`>"')
  if block_horizontal.duplicate("'<", "'>", distance) then
    vim.cmd('execute "normal! g`[\\<C-v>g`]"')
  end
end


return M
