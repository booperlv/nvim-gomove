local undo = {}

function undo.LineState(line_start, line_end, state)
  local content = vim.fn.getbufline(
    vim.fn.bufnr("%"), line_start, line_end
  )
  for index, value in ipairs(content) do
    --Remove any whitespace at the start of the character
    --A little hacky, but allows reindenting and horizontal-line movement
    content[index] = value:gsub("^%s+", "")
  end
  return {content = content, state = state}
end

function undo.BlockState(pos_start, pos_end, state)
  --We are assuming here that the state"s being fed are getpos() positions.
  --What we are basically doing are harvesting the columns and lines from
  --the table returned from vim cursor functions.
  local lines = {pos_start[2], pos_end[2]}
  local columns = {pos_start[3], pos_end[3]}
    local selection_content = vim.fn.getbufline(
      vim.fn.bufnr("%"),
      math.min(unpack(lines)),
      math.max(unpack(lines))
    )
    -- Substitute each line to their corresponding selection, by cutting off
    -- other characters that are not within the first and last selection.
    for index, line in ipairs(selection_content) do
      selection_content[index] = line:sub(
        math.min(unpack(columns)),
        math.max(unpack(columns))
      )
    end
  return {content = selection_content, state = state}
end


--Check two things,
--if content is the same,
--and if the old_state"s destination + distance is the new_state"s destination.
function undo.Handle(new_state, distance)
  local old_state = (vim.b.gomove_state and vim.b.gomove_state or new_state)
  vim.b.gomove_state = new_state

  local utils = require("gomove.utils")
  print(vim.inspect(old_state), vim.inspect(new_state))
  if utils.tables_identical(new_state.content, old_state.content) then
    if (old_state.state+distance) == new_state.state then
      -- print('state+distance')
      vim.cmd("silent! undojoin")
      return true
    elseif old_state.state == new_state.state then
      -- print('state=state')
      vim.cmd("silent! undojoin")
      return true
    end
  end

  return false
end


return undo
