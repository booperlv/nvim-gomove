local fold = {}

-- "I need to go move (distance), from (start), (end).
-- Where do you think I should go knowing what you know?"
-- :: int:destination_low, int:destination_high, bool:did_find_a_fold
function fold.Handle(start_low, start_high, distance)
  local going_down = (distance > 0)
  local height = start_high - start_low

  --Normally, You would simply go to these locations
  local destn_base_low = start_low + distance
  local destn_base_high = start_high + distance

  local utils = require("gomove.utils")
  local lines_between = utils.range(destn_base_low, destn_base_high)

  --But, we need to check first if there are any lines that have folds on them.
  local line_of_contact
  if going_down then
    -- We will sort lines_between to be ascending (loop from top to bottom)
    -- Already ascending
  else
    -- We will sort lines_between to be descending (loop from bottom to top)
    table.sort(lines_between, function(a,b) return a > b end)
  end
  --Get the first "line of contact" that is inside a fold
  for _, line in ipairs(lines_between) do
    local fold_exists = (vim.fn.foldclosedend(line) ~= -1)
    if fold_exists then
      line_of_contact = line
      break
    end
  end

  --If there aren't any lines of contact then just return the base destination
  if not line_of_contact then
    return destn_base_low, destn_base_high, false
  end

  --If there are lines_of_contact,
  --"normal! j" or "normal! k" past them.
  local destn_low
  local line_offset = distance - 1
  if going_down then
    vim.fn.cursor(line_of_contact, 1)
    while (vim.fn.foldclosed(".") ~= -1) do
      vim.cmd("normal! j")
    end
    destn_low = vim.fn.line(".") + line_offset
  else
    vim.fn.cursor(line_of_contact, 1)
    while (vim.fn.foldclosed(".") ~= -1) do
      vim.cmd("normal! k")
    end
    destn_low = vim.fn.line(".") - height - line_offset
  end
  local destn_high = destn_low+height

  return destn_low, destn_high,
  --Return true if did find a fold, false if otherwise
  (line_of_contact and true or false)
end

return fold
