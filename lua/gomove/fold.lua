local fold = {}

-- I want to move (start_low, start_high) (distance) on the screen.
-- Can you check each line one by one so we can go down?
-- :: int:destination_low, int:destination_high, bool:did_find_a_fold
function fold.Handle(start_low, start_high, distance)
  local going_down = (distance > 0)
  local height = start_high - start_low

  local utils = require("gomove.utils")
  local lines_between = utils.range(start_low, start_high)
  if going_down then
    -- We will sort lines_between to be descending (loop from bottom to top)
    table.sort(lines_between, function(a,b) return a > b end)
  else
    -- We will sort lines_between to be ascending (loop from top to bottom)
    -- Already ascending
  end
  local did_find_a_fold
  local line_to_first_contact_fold = lines_between[1]

  --Increment each line one by one, and use normal! j or k when finding a fold
  local destn_low = line_to_first_contact_fold
  for _=1, math.abs(distance) do
    if going_down then
      destn_low = destn_low + 1
    else
      destn_low = destn_low - 1
    end
    vim.fn.cursor(destn_low, 1)

    if vim.fn.foldclosed(".") ~= -1 then
      did_find_a_fold = true
      while (vim.fn.foldclosed(".") ~= -1) do
        if going_down then
          vim.cmd("normal! j")
          destn_low = vim.fn.line(".")
        else
          vim.cmd("normal! k")
          destn_low = vim.fn.line(".") - height
        end
      end
    end
  end

  --Add cases to handle invalid values
  local opts = require('gomove.config').opts
  if destn_low < 0 then
    destn_low = 1
  elseif destn_low + height > vim.fn.line('$') then
    if opts.move_past_end_of_file then
      destn_low = destn_low
    else
      destn_low = vim.fn.line('$') - height
    end
  end
  local destn_high = destn_low + height

  return destn_low, destn_high,
  --Return true if did find a fold, false if otherwise
  (did_find_a_fold and true or false)
end

return fold
