local undo = {}

local function check_changedtick_direction(prev, current)
  if prev.ct == current.ct then
    if prev.direction == current.direction then
      vim.cmd('silent! undojoin')
      return true
    end
  end
  return false
end

local function check_changedtick(prev, current)
  if prev.ct == current.ct then
    vim.cmd('silent! undojoin')
    return true
  end
  return false
end

--Check two things,
--if there were any other changes (b:changedtick),
--and if the direction is the same
function undo.Handle(direction)
  local opts = require("gomove").opts
  if opts.undojoin == true then
    local prev_state = vim.b.gomove_prev or {ct = -1, direction = nil}
    vim.b.gomove_state = {ct = vim.b.changedtick, direction = direction}
    local current_state = vim.b.gomove_state
    return check_changedtick_direction(prev_state, current_state)
  end
end

function undo.NoDirection()
  local prev_state = vim.b.gomove_prev or {ct = -1, direction = nil}
  local current_state = vim.b.gomove_state or {ct = -2, direction = nil}
  return check_changedtick(prev_state, current_state)
end

function undo.Save(direction)
  vim.b.gomove_prev = {ct = vim.b.changedtick, direction = direction}
end

return undo
