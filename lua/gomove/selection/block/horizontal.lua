local bh = {}

function bh.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  local going_right = (distance > 0)

  local temp_cols = {vim.fn.col(vim_start), vim.fn.col(vim_end)}
  local col_start = math.min(unpack(temp_cols))
  local col_end = math.max(unpack(temp_cols))
  local width = col_end - col_start + 1

  local destn_start = math.max(1, col_start+distance)

  local opts = require("gomove.config").opts
  if going_right and not opts.move_past_line then
    local temp_lines = vim.fn.getline(vim_start, vim_end)
    local shortest = math.min(unpack(vim.fn.map(temp_lines, "strwidth(v:val)")))
    if col_end < shortest then
      destn_start = math.min(destn_start, shortest-width+1)
    else
      destn_start = col_start
    end
  end
  if col_start == destn_start then
    return false
  end

  local register = "z"
  local old_register_value = vim.fn.getreg("register")

  local undo = require("gomove.undo")
  undo.Handle(
    (going_right and "right" or "left")
  )
  vim.cmd("silent! normal! \""..register.."x")

  local old_virtualedit = vim.o.virtualedit
  if destn_start >= vim.fn.col("$") then
    vim.o.virtualedit = "all"
  else
    vim.o.virtualedit = ""
  end
  vim.fn.cursor(vim.fn.line("."), destn_start)
  vim.cmd("silent! normal! \""..register.."P")

  vim.o.virtualedit = old_virtualedit
  vim.fn.setreg(register, old_register_value)

  undo.Save(
    (going_right and "right" or "left")
  )

  return true
end


function bh.duplicate(vim_start, vim_end, count)
  if vim.o.modifiable == 0 or count == 0 then
    return false
  end

  local temp_cols = {vim.fn.col(vim_start), vim.fn.col(vim_end)}
  local col_start = math.min(unpack(temp_cols))
  local col_end = math.max(unpack(temp_cols))
  local width = col_end - col_start

  local going_right = (count > 0)

  --The distance will always be 1 or -1, count is just the amount of times we
  --do it. This is automatically the destination.
  local destn_start = col_start + (going_right and 1 or -1)
  local destn_end = destn_start + width

  local register = 'z'
  local old_register_value = vim.fn.getreg('register')
  vim.cmd('silent! normal! "'..register..'x')

  local old_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = 'all'
  local line = vim.fn.line(".")
  vim.cmd('silent! normal! "'..register..'P')

  if going_right then
    vim.fn.cursor(line, destn_end)
    vim.cmd('silent! normal!'..math.abs(count)..'"'..register..'P')
  else
    vim.fn.cursor(line, destn_start)
    vim.cmd('silent! normal!'..math.abs(count)..'"'..register..'p')
  end

  vim.fn.setreg(register, old_register_value)
  vim.o.virtualedit = old_virtualedit

  return true
end

return bh
