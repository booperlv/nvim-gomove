local bh = {}

function bh.move(vim_start, vim_end, distance)
  if not vim.o.modifiable or distance == 0 then
    return false
  end

  local going_right = (distance > 0)
  local col_start = vim.fn.col(vim_start)
  local col_end = vim.fn.col(vim_end)
  local width = col_end - col_start
  local register = "z"
  local old_register_value = vim.fn.getreg("register")

  -- get lines status before deleting anything
  local lines = vim.fn.getline(vim_start, vim_end)
  table.sort(lines, function(a,b) return #a<#b end)

  -- start undojoin and delete
  local old_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = "all"

  local undo = require("gomove.undo")
  undo.Handle((going_right and "right" or "left"))
  vim.cmd("normal! \""..register.."x")

  -- go to new destination
  local destn_start
  for _=1, math.abs(distance) do
    local last_destn = destn_start
    if going_right then
      vim.cmd('normal!l')
    else
      vim.cmd('normal!h')
    end
    destn_start = vim.fn.col(".")
    if last_destn == destn_start then
      local single_distance = (going_right and 1 or -1)
      destn_start = destn_start + single_distance
    end
  end
  -- correct based on option to move past end column of shortest line
  local opts = require("gomove").opts
  if going_right and not opts.move_past_end_col then
    local shortest_line_width = #lines[1]
    if col_end < shortest_line_width then
      if destn_start < shortest_line_width then
        vim.fn.cursor(vim.fn.line("."), destn_start)
      else
        vim.fn.cursor(vim.fn.line("."), shortest_line_width)
        vim.cmd('normal!'..width..'h')
      end
    else
      -- don't move anymore
      vim.fn.cursor(vim.fn.line("."), col_start)
    end
  end

  -- paste
  vim.cmd("silent! normal! \""..register.."P")
  -- fix register and virtualedit
  vim.o.virtualedit = old_virtualedit
  vim.fn.setreg(register, old_register_value)
  -- complete undo
  undo.Save((going_right and "right" or "left"))

  return true
end


function bh.duplicate(vim_start, vim_end, count)
  if not vim.o.modifiable or count == 0 then
    return false
  end

  local going_right = (count > 0)
  local col_start = vim.fn.col(vim_start)
  local col_end = vim.fn.col(vim_end)
  local width = col_end - col_start

  --The distance will always be 1 or -1, count is just the amount of times we
  --do it. This is automatically the destination.
  local destn_start = col_start + (going_right and 1 or -1)
  local destn_end = destn_start + width

  local old_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = "all"

  local register = 'z'
  local old_register_value = vim.fn.getreg('register')
  vim.cmd('silent! normal! "'..register..'x')

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
