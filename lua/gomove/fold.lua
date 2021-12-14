local M = {}

function M.Handle(line_or_block, start_low, start_high, distance)
  local going_down = (distance > 0)

  local utils = require('gomove.utils')
  start_low = utils.fold_start(start_low)
  start_high = utils.fold_start(start_high)

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
    local function move()
      prev_value = next_position
      if going_down then
        vim.cmd("normal! j")
        next_position = vim.fn.line(".") + height
      else
        vim.cmd("normal! k")
        next_position = vim.fn.line(".") - height
      end
    end

    move()

    if vim.fn.foldclosed(".") ~= -1 then
      did_find_a_fold = true
      while (vim.fn.foldclosed(".") ~= -1) do
        move()
        -- error catcher and start of file is fold handling
        if prev_value == next_position then
          if line_or_block == "block" then
            if next_position <= 1 then
              next_position = 1
            end
          elseif line_or_block == "line" then
            if next_position == 1 then
              next_position = 0
            end
          end
          break;
        end
      end
    end
  end
  vim.fn.winrestview(old_pos)

  --Actually get the destn_start/low instead of the line_to_first_contact_fold
  local destn_low
  if going_down then
    destn_low = next_position - height
  else
    destn_low = next_position
  end

  --Invalid values
  if destn_low <= 0 then
    destn_low = 0
  elseif destn_low >= vim.fn.line("$") then
    destn_low = vim.fn.line("$") - height
  end

  local destn_high = destn_low + height

  return destn_low, destn_high,
  --Return true if did find a fold, false if otherwise
  (did_find_a_fold and true or false)
end

return M
