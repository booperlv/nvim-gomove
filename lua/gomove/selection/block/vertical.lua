local bv = {}

function bv.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  -- initial variables{{{
  local utils = require('gomove.utils')
  local going_down = (distance > 0)
  local old_pos = vim.fn.winsaveview()

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)
  local height = utils.user_height(line_start, line_end)

  local temp_cols = {vim.fn.col(vim_start), vim.fn.col(vim_end)}
  local col_start = math.min(unpack(temp_cols))
  local col_end = math.max(unpack(temp_cols))
  local width = col_end - col_start

  if utils.contains_fold(line_start, line_end) then
    print('Go-Move-Block does not support moving folds!')
    return false
  end

  local lines_selected = vim.fn.getbufline(
    vim.fn.bufnr('%'), line_start, line_end
  )
  --If all the lines selected are empty, stop moving
  if table.concat(lines_selected) == '' then
    return false
  end

  local destn_col_start = col_start
--}}}
  --Compute destination line{{{
  local destn = require('gomove.selection')
  local destn_line_start, destn_line_end = destn.Handle(
    "b", line_start, line_end, distance
  )

  --If there is no actual movement, stop right here and don't do anything else.
  if line_start == destn_line_start and line_end == destn_line_end then
    return false
  end

  utils.open_fold(destn_line_start, destn_line_end)
--}}}
  --Prepping for trailing whitespace delete{{{

  --Get all lines between linebefore and after, and their corresponding lengths.
  --We are getting the lengths BEFORE we actually move.
  local all_pos_between = {}
  local low_end = destn_line_start
  local high_end = destn_line_end
  while (low_end <= high_end) do
    vim.fn.cursor(low_end, 1)
    local curpos = {low_end, vim.fn.col('$')}
    table.insert(all_pos_between, curpos)
    low_end = low_end + 1
  end

  --Extract the lines where length is less than destination column/before. As
  --that would be the only instance where a trailing whitespace would be left.
  local lines_to_insert = {}
  for _, pos in ipairs(all_pos_between) do
    vim.fn.cursor(pos)
    if vim.fn.col('$') < destn_col_start then
      table.insert(lines_to_insert, pos)
    end
  end

  local new_lines_with_trailing_whitespace = vim.b.gomove_lines_with_trailing_whitespace or {}

  local undo = require('gomove.undo')
  local did_undojoin = undo.Handle(
    (going_down and "down" or "up")
  )

  -- To prevent instances where the content of the line is already changed, but
  -- we assume that the previous "end column" is still the same and accidentally
  -- delete there, we completely clear the previous
  -- "lines_with_trailing_whitespace" when the move is not undojoined.
  if not did_undojoin then
    for index, _ in ipairs(new_lines_with_trailing_whitespace) do
      table.remove(new_lines_with_trailing_whitespace, index)
    end
  end

  --Insert all of the new positions to the table without deleting the others
  --that should stay for after we move past those positions
  for _, pos in ipairs(lines_to_insert) do
    local function has_line (tab, val)
      for _,v in ipairs(tab) do
        if v[1] == val[1] then return true end
      end
      return false
    end
    --Prevent duplicates
    if not has_line(new_lines_with_trailing_whitespace, pos) then
      table.insert(new_lines_with_trailing_whitespace, pos)
    end
  end

--}}}
  --Deleting and Pasting{{{
  vim.fn.winrestview(old_pos)

  local register = 'z'
  local old_register_value = vim.fn.getreg(register)

  local old_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = "all"

  vim.cmd('silent! normal! "'..register..'x')
  vim.fn.cursor(destn_line_start, destn_col_start)
  vim.cmd('silent! normal! "'..register..'P')

  vim.o.virtualedit = old_virtualedit
  vim.fn.setreg(register, old_register_value)
--}}}
  --Trailing whitespace deletion/adding new values{{{

  local function line_exists_between_destination(val)
    for _, pos in ipairs(all_pos_between) do
      if pos[1] == val[1] then
        return true
      end
    end
    return false
  end

  --Delete trailing whitespace from previous move
  local indexes_to_remove = {}
  if next(new_lines_with_trailing_whitespace) ~= nil then
    for index, pos in ipairs(new_lines_with_trailing_whitespace) do
      --We check here if it doesn't exist inside lines, to get rid of the trailing
      --whitespace and the item on the array ONLY ONCE we have moved past it.
      --Also, check if it is not blank, to make sure that we do not remove lines.
      if not line_exists_between_destination(pos) then
        if vim.fn.getline(pos[1]) ~= '' then
          vim.fn.cursor(pos)
          vim.cmd('normal!dw')
          table.insert(indexes_to_remove, index)
        end
      end
    end
  end
  for _, value in ipairs(indexes_to_remove) do
    table.remove(new_lines_with_trailing_whitespace, value)
  end

  vim.b.gomove_lines_with_trailing_whitespace = new_lines_with_trailing_whitespace
--}}}
  --Set new position{{{
  vim.fn.cursor(destn_line_start, destn_col_start)
  vim.cmd('normal! m[')
  vim.fn.cursor(destn_line_start+(height-1), destn_col_start+width)
  vim.cmd('normal! m]')--}}}

  undo.Save(
    (going_down and "down" or "up")
  )

  return true
end


function bv.duplicate(vim_start, vim_end, count)
  if vim.o.modifiable == 0 or count == 0 then
    return false
  end

  -- initial variables{{{
  local utils = require('gomove.utils')
  local going_down = (count > 0)

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)
  local height = utils.user_height(line_start, line_end)

  local temp_cols = {vim.fn.col(vim_start), vim.fn.col(vim_end)}
  local col_start = math.min(unpack(temp_cols))
  local col_end = math.max(unpack(temp_cols))
  local width = col_end - col_start

  if utils.contains_fold(line_start, line_end) then
    print('Go-Dup-Block does not support moving folds!')
    return false
  end

  local destn_line_start = line_start
  local destn_line_end = line_start + height
  local destn_col_start = col_start
--}}}
  --Deleting and Pasting{{{
  local register = 'z'
  local old_register_value = vim.fn.getreg(register)

  local old_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = "all"

  vim.cmd('silent! normal! "'..register..'x')
  vim.cmd('silent! normal! "'..register..'P')

  local amount_of_times_done = 1

  local destn = require('gomove.selection')
  while (amount_of_times_done <= math.abs(count)) do
    destn_line_start, destn_line_end = destn.Handle(
      "b", destn_line_start, destn_line_end,
      (going_down and 1 or -1)
    )
    utils.open_fold(destn_line_start, destn_line_end)

    vim.fn.cursor(destn_line_start, destn_col_start)
    vim.cmd('silent! normal! "'..register..'P')

    amount_of_times_done = amount_of_times_done + 1
  end

  vim.o.virtualedit = old_virtualedit
  vim.fn.setreg(register, old_register_value)
--}}}
  --Set new position{{{
  vim.fn.cursor(destn_line_start, destn_col_start)
  vim.cmd('normal! m[')
  vim.fn.cursor(destn_line_start+height, destn_col_start+width)
  vim.cmd('normal! m]')--}}}

  return true
end

return bv
