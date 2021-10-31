local block_vertical = {}

function block_vertical.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)
  local height = line_end - line_start

  local utils = require('gomove.utils')
  if utils.contains_fold(line_start, line_end) then
    print('Go-Move-Block does not support moving folds!')
    return
  end

  local col_start = vim.fn.col(vim_start)
  local col_end = vim.fn.col(vim_end)
  local width = col_end - col_start

  local lines_selected = vim.fn.getbufline(
    vim.fn.bufnr('%'), line_start, line_end
  )
  --If all the lines selected are empty, stop moving
  if table.concat(lines_selected) == '' then
    return false
  end

  local old_pos = vim.fn.winsaveview()

  --Compute destination line

  local destn_col_start = col_start

  local fold = require('gomove.fold')
  local destn_line_start, destn_line_end = fold.Handle(
    line_start, line_start, distance
  )

  local opts = require('gomove.config').opts

  --If there is no actual movement, stop right here and don't do anything else.
  if line_start == destn_line_start and line_end == destn_line_end then
    return false
  end

  --Add cases to handle invalid values
  if destn_line_start < 0 then
    destn_line_start = 1
  elseif destn_line_start + height > vim.fn.line('$') then
    if opts.move_past_end_of_file then
      destn_line_start = destn_line_start
    else
      destn_line_start = vim.fn.line('$') - height
    end
  end
  destn_line_end = destn_line_start + height

  --State saving for undojoin

  --Now that the calculation is finished, Since before is always based on
  --the first cursor position, we can just set state_before to linebefore
  --and it will not mess up recognizing continuous actions.
  local state_destn_line_start = destn_line_start
  --This allows oldState.after + distance == newState.after in the undojoin
  --to remain true, only in the correct times.
  local state_distance = destn_line_start - line_start

  --Prepping for trailing whitespace delete

  --Get all lines between linebefore and after, and their corresponding lengths.
  --We are keeping the lengths from BEFORE the actual move.
  local all_pos_between = {}
  local low_end = destn_line_start
  local high_end = destn_line_end
  while (low_end <= high_end) do
    vim.fn.cursor(low_end, 1)
    local curpos = {low_end, vim.fn.col('$')}
    table.insert(all_pos_between, curpos)
    low_end = low_end + 1
  end

  --Extract the lines where length is less than destination column/before.
  --This will be the basis for the vim buffer trailing whitespace variable
  local lines_length_prior = {}
  for _, pos in ipairs(all_pos_between) do
    vim.fn.cursor(pos)
    if vim.fn.col('$') < destn_col_start then
      table.insert(lines_length_prior, pos)
    end
  end

  local new_lines_with_trailing_whitespace = vim.b.gomove_lines_with_trailing_whitespace or {}
  local function line_exists_between(val)
    for _, pos in ipairs(all_pos_between) do
      if pos[1] == val[1] then
        return true
      end
    end
    return false
  end

  --Remove the lines where the content is not the same as the plugin remembers
  --basically, "dead positions" or the lines that have already changed.
  --This is done to prevent any instance where the line has already been
  --changed, but is then normal!dw'ed at it's previous last column prior to
  --changing.
  if next(new_lines_with_trailing_whitespace) ~= nil then
    for index, value in ipairs(new_lines_with_trailing_whitespace) do
      local content = value.content or ''
      if not line_exists_between(content) then
        local pos = value.pos
        --If the value of the line at the current pos is not the same as it
        --remembers, delete it
        if content ~= vim.fn.getline(pos[1]) then
          table.remove(new_lines_with_trailing_whitespace, index)
        end
      end
    end
  end

  --Deleting and Pasting

  vim.fn.winrestview(old_pos)

  local old_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = "all"

  local register = 'z'
  local old_register_value = vim.fn.getreg(register)

  local undo = require('gomove.undo')
  undo.Handle(
    undo.BlockState(
      vim.fn.getpos(vim_start), vim.fn.getpos(vim_end), state_destn_line_start
    ), state_distance
  )
  vim.cmd('silent! normal! "'..register..'x')

  utils.go_to(destn_line_start, destn_col_start)

  vim.cmd('silent! normal! "'..register..'P')

  vim.o.virtualedit = old_virtualedit
  vim.fn.setreg(register, old_register_value)

  --Trailing whitespace deletion/adding new values

  --Delete trailing whitespace from previous move
  if next(new_lines_with_trailing_whitespace) ~= nil then
    for index, value in ipairs(new_lines_with_trailing_whitespace) do
      --We check here if it doesn't exist inside lines, to get rid of the trailing
      --whitespace and the item on the array ONLY ONCE we have moved past it.
      --Also, check if it is not blank, to make sure that we do not remove lines.
      local pos = value.pos
      if not line_exists_between(pos) then
        if vim.fn.getline(pos[1]) ~= '' then
          vim.fn.cursor(pos)
          vim.cmd('normal! dw')
          table.remove(new_lines_with_trailing_whitespace, index)
        end
      end
    end
  end

  --Insert all of the new positions to the table without deleting the others
  --that should stay for after we move past those positions
  for _, pos in ipairs(lines_length_prior) do
    local function has_pos (tab, val)
      for _,v in ipairs(tab) do
        if v == val then return true end
      end
      return false
    end
    if not has_pos(new_lines_with_trailing_whitespace, pos) then
      table.insert(new_lines_with_trailing_whitespace, {
        pos = pos,
        content = vim.fn.getline(pos[1])
      })
    end
  end

  vim.b.gomove_lines_with_trailing_whitespace = new_lines_with_trailing_whitespace
  -- print(
  --   low_end, high_end,
  --   (did_undojoin and 'did undojoin' or 'did not undojoin'),
  --   -- vim.inspect(all_pos_between),
  --   vim.inspect(lines_length_prior)
  --   -- vim.inspect(vim.b.gomove_lines_with_trailing_whitespace)
  -- )

  --Set new position
  vim.fn.cursor(destn_line_start, destn_col_start)
  vim.cmd('normal! m[')
  vim.fn.cursor(destn_line_start+height, destn_col_start+width)
  vim.cmd('normal! m]')

  return true
end

return block_vertical