local undo = {}

--Check two things,
--if there were any other changes (b:changedtick),
--and if the direction is the same
function undo.Handle(direction)
  local prev_state = vim.b.gomove_prev or {ct = -1, direction = nil}
  vim.b.gomove_state = {ct = vim.b.changedtick, direction = direction}
  local current_state = vim.b.gomove_state

  if prev_state.ct == current_state.ct then
    if prev_state.direction == current_state.direction then
      vim.cmd('silent! undojoin')
      return true
    end
  end

  return false
end

function undo.NoDirection()
  local prev_state = vim.b.gomove_prev or {ct = -1, direction = nil}
  local current_state = vim.b.gomove_state or {ct = -2, direction = nil}

  if prev_state.ct == current_state.ct then
    return true
  end

  return false
end

function undo.Save(direction)
  vim.b.gomove_prev = {ct = vim.b.changedtick, direction = direction}
end

return undo
