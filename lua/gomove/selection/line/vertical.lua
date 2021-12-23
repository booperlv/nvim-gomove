local lv = {}

function lv.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  -- initial values{{{
  local utils = require("gomove.utils")
  local going_down = (distance > 0)
  local old_pos = vim.fn.winsaveview()

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)
  local height = utils.user_height(line_start, line_end)
--}}}
  -- Compute Destination Line{{{
  local destn = require('gomove.selection')
  local destn_start, destn_end = destn.Handle(
    "l", line_start, line_end, distance
  )

  --If there is no actual movement, stop right here and don't do anything else.
  if line_start == destn_start and line_end == destn_end then
    return false
  end
--}}}
  --Make up for the oddness of :move{{{
  local move_translated_destn = destn_start
  if going_down then
    move_translated_destn = destn_end
  else
    move_translated_destn = destn_start-1
  end
--}}}
  -- Move{{{
  local undo = require('gomove.undo')
  undo.Handle(
    (going_down and "down" or "up")
  )

  vim.fn.winrestview(old_pos)
  vim.cmd(line_start..','..line_end..'move'..move_translated_destn)
--}}}
  -- Reindenting Setting New Position{{{
  local new_line_start = vim.fn.line("'[")
  local new_line_end = vim.fn.line("']")
  utils.reindent(new_line_start, new_line_end)

  vim.fn.cursor(new_line_start, 1)
  vim.cmd("normal! 0m[")
  vim.fn.cursor(new_line_end, 1)
  vim.cmd("normal! $m]")--}}}

  undo.Save(
    (going_down and "down" or "up")
  )

  return true
end

function lv.duplicate(vim_start, vim_end, count)
  if vim.o.modifiable == 0 or count == 0 then
    return false
  end

  -- initial variables
  local utils = require('gomove.utils')
  local going_down = (count > 0)

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)
  local height = utils.user_height(line_start, line_end)

  -- copy
  local times_done = 0
  if going_down then
    for _=1, math.abs(count) do
      vim.cmd(line_start..','..line_end..'copy'..line_end)
      times_done = times_done + 1
    end
  else
    for _=1, math.abs(count) do
      vim.cmd(line_start..','..line_end..'copy'..line_start-1)
      times_done = times_done + 1
    end
  end

  --Set new position
  local offset=times_done+(height-1)
  if going_down then
    vim.fn.cursor(line_start+offset, 1)
    vim.cmd('normal! 0m[')
    vim.fn.cursor(line_end+offset, 1)
    vim.cmd('normal! $m]')
  else
    vim.fn.cursor(line_start, 1)
    vim.cmd('normal! 0m[')
    vim.fn.cursor(line_end, 1)
    vim.cmd('normal! $m]')
  end

  return true
end

return lv
