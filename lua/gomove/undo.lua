local undo = {}

function undo.LineState(start_line, end_line, state)
  local content = vim.fn.getbufline(
    vim.fn.bufnr("%"), start_line, end_line
  )
  for index, value in ipairs(content) do
    --Remove any whitespace at the start of the character
    --A little hacky, but allows reindenting and horizontal-line movement
    content[index] = value:gsub("^%s+", "")
  end
  return {content = content, state = state}
end

function undo.BlockState(start_pos, end_pos, state)
  --We are assuming here that the state"s being fed are getpos() positions.
  --What we are basically doing are harvesting the columns and lines from
  --the table returned from vim cursor functions.
  local lines = {start_pos[2], end_pos[2]}
  local columns = {start_pos[3], end_pos[3]}
    local selection_content = vim.fn.getbufline(
      vim.fn.bufnr("%"),
      math.min(unpack(lines)),
      math.max(unpack(lines))
    )
    -- Substitute each line to their corresponding selection, by cutting off
    -- other characters that are not within the first and last selection.
    for index, value in ipairs(selection_content) do
      selection_content[index] = value:sub(
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
  if utils.tables_identical(new_state.content) then
    if (old_state.state+distance) == new_state.state then
      vim.cmd("silent! undojoin")
      return true
    elseif old_state.state == new_state.state then
      --We will return true here, even though we will not undojoin. This helps
      --with the trailing whitespace removal in block move vertical.
      return true
    end
  end

  return false
end


return undo
