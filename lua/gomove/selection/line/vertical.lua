local line_vertical = {}

function line_vertical.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  -- initial values{{{
  local old_pos = vim.fn.winsaveview()

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)

  local going_down = (distance > 0)

  local utils = require("gomove.utils")
--}}}
  -- Compute Destination Line{{{
  local fold = require('gomove.selection')
  local destn_start, destn_end, encountered_fold = fold.Handle(
    "l", line_start, line_end, distance
  )

  if line_start == destn_start and line_end == destn_end then
    return false
  end

  local undo = require('gomove.undo')
  undo.Handle(
    (going_down and "down" or "up")
  )
--}}}
  --Make up for the oddness of :move{{{

  local move_translated_destn = destn_start
  if not (destn_start <= 0) then
    local height = utils.user_height(line_start, line_end)
    if encountered_fold then
      print(height)
      if going_down then
        destn_start = utils.fold_end(destn_start)-(height)
      else
        destn_start = utils.fold_start(destn_start)+(height)
      end
    end
    destn_end = destn_start + (height-1)

    print('encountered fold is', destn_start, destn_end)

    if going_down then
      move_translated_destn = destn_end
    else
      move_translated_destn = destn_start-1
    end

    print('translated is', move_translated_destn)
  end
--}}}
  -- Move{{{
  vim.fn.winrestview(old_pos)
  -- print(line_start, line_end, move_translated_destn)
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

  return true
end

return line_vertical
