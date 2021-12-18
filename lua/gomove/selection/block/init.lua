local M = {}

local function normal_move(going_down, next_position)
  if going_down then
    vim.cmd("normal! j")
    next_position = vim.fn.line(".")
  else
    vim.cmd("normal! k")
    next_position = vim.fn.line(".")
  end
  return next_position
end

local function height_move(going_down, next_position, height)
  if going_down then
    vim.cmd("normal! j")
    next_position = vim.fn.line(".") + (height-1)
  else
    vim.cmd("normal! k")
    next_position = vim.fn.line(".") - (height-1)
  end
  return next_position
end

function M.Handle(start_low, start_high, distance)
  local going_down = (distance > 0)

  local utils = require('gomove.utils')
  start_low = utils.fold_start(start_low)
  start_high = utils.fold_end(start_high)

  print('so starting from', start_low, start_high)

  local height = utils.user_height(start_low, start_high)

  local line_to_first_contact_fold
  if going_down then
    --last line
    line_to_first_contact_fold = start_high
  else
    --first line
    line_to_first_contact_fold = start_low
  end

  print('andd using this line for first contact', line_to_first_contact_fold)
  print('OH AND I ALMOST FORGOT, the distance to go is', distance)

  --Increment each line one by one, and use normal! j or k when finding a fold
  local old_pos = vim.fn.winsaveview()
  local did_find_a_fold
  local next_position = line_to_first_contact_fold

  local prev_value
  vim.fn.cursor(next_position, 1)

  for _=1, math.abs(distance) do
    prev_value = next_position
    next_position = normal_move(going_down, next_position)

    print('ah so i just moved and im on', next_position)

    if vim.fn.foldclosed(".") ~= -1 then
      did_find_a_fold = true
      while (vim.fn.foldclosed(".") ~= -1) do
        prev_value = next_position
        next_position = height_move(going_down, next_position, height)

        print("going through folds rn ig its", next_position)
        -- error catcher and start of file is fold handling
        if prev_value == next_position then
          print("error caught")
          if next_position <= 1 then
            next_position = 0
          end
          break;
        end
      end
    end
  end
  vim.fn.winrestview(old_pos)

  local destn_low
  --Actually get the destn_start/low instead of the line_to_first_contact_fold
  if going_down then
    destn_low = next_position - (height-1)
  else
    destn_low = next_position
  end

  local destn_high = destn_low + (height-1)

  print('got what i think is the destn', destn_low, destn_high)

  --Invalid values
  if destn_low <= 0 then
    destn_low = 0
  elseif destn_high >= vim.fn.line("$") then
    destn_low = vim.fn.line("$")
  end
  destn_high = destn_low + (height-1)

  print(destn_low, destn_high)

  return destn_low, destn_high,
  --Return true if did find a fold, false if otherwise
  (did_find_a_fold and true or false)
end

return M
