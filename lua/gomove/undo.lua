local undo = {}

--Check two things,
--if there were any other changes (b:changedtick),
--and if the direction is the same
function undo.Handle(direction)
  local prev_state = vim.b.gomove_state or {ct = -1, direction = nil}
  vim.b.gomove_state = {ct = vim.b.changedtick, direction = direction}
  local current_state = vim.b.gomove_state

  local utils = require("gomove.utils")
  if utils.tables_identical(prev_state, current_state) then
    vim.cmd('silent! undojoin')
  end
end

return undo
