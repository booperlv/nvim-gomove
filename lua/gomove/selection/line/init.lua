local M = {}

local function normal_move(going_down, next_position)
  vim.fn.cursor(next_position, 1)
  if going_down then
    vim.cmd("normal! j")
    next_position = vim.fn.line(".")
  else
    vim.cmd("normal! k")
    next_position = vim.fn.line(".")
  end
  return next_position
end

-- move along folds as if they were lines
local function fold_move(going_down, next_position)
  local utils = require("gomove.utils")
  local prev_position = next_position
  vim.fn.cursor(prev_position, 1)
  if going_down then
    next_position = utils.fold_end(vim.fn.line("."))
  else
    next_position = utils.fold_start(vim.fn.line("."))
  end
  if vim.fn.foldclosed(next_position) ~= -1 then
    return next_position, true
  end
  return next_position, false
end

function M.Handle(start_low, start_high, distance)
  local going_down = (distance > 0)

  local utils = require('gomove.utils')
  start_low = utils.fold_start(start_low)
  start_high = utils.fold_end(start_high)

  local height = utils.user_height(start_low, start_high)

  local line_to_first_contact_fold
  if going_down then
    --last line
    line_to_first_contact_fold = start_high
  else
    --first line
    line_to_first_contact_fold = start_low
  end

  --Increment each line one by one, and use normal! j or k when finding a fold
  local old_pos = vim.fn.winsaveview()
  local did_find_a_fold
  local next_position = line_to_first_contact_fold

  local prev_value
  vim.fn.cursor(next_position, 1)

  for _=1, math.abs(distance) do
    next_position = normal_move(going_down, next_position)
    if vim.fn.foldclosed(".") ~= -1 then
      did_find_a_fold = true
      while (vim.fn.foldclosed(".") ~= -1) do
        prev_value = next_position
        local stop_loop
        next_position, stop_loop = fold_move(
          going_down, next_position
        )
        if stop_loop == true then break end
        -- infinite loop catcher {{{
        if prev_value == next_position then
          -- print("infinite loop stopped at", next_position)
          break;
        end--}}}
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

  return destn_low, destn_high,
  --Return true if did find a fold, false if otherwise
  (did_find_a_fold and true or false)
end

return M
