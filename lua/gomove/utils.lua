local utils = {}

function utils.merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      utils.merge(t1[k], t2[k])
    else t1[k] = v end
  end
  return t1
end

function utils.tables_identical(t1, t2)
  if t1 == nil or t2 == nil then
    return false
  end
  for k, v in ipairs(t1) do if t2[k] ~= v then return false end; end
  for k, v in ipairs(t2) do if t1[k] ~= v then return false end; end
  return true
end

function utils.index_of(table, value)
  for k, v in ipairs(table) do
    if v == value then
      return k
    end
  end
  return nil
end

function utils.range(from, to)
  local result = {}
  local counter = from
  while (counter <= to) do
    table.insert(result, counter)
    counter = counter+1
  end
  return result
end

function utils.contains_fold(startnum, endnum)
  local result = {}
  local counter = startnum
  while (counter <= endnum) do
    if vim.fn.foldclosed(counter) ~= -1 then
      table.insert(result, {
        vim.fn.foldclosed(counter), vim.fn.foldclosedend(counter)
      })
      if vim.fn.foldclosedend(counter) > endnum then
        break
      else
        counter = vim.fn.foldclosedend(counter)
      end
    end
    counter = counter+1
  end
  return (next(result) and true or false), result
end

function utils.go_to(line, col, height)
  if line <= 0 then
    line = 1
  elseif line > vim.fn.line("$") then
    line = vim.fn.line("$") - height
  end
  vim.fn.cursor(line, col)
end

function utils.fold_start(num)
  return (vim.fn.foldclosed(num) ~= -1
    and vim.fn.foldclosed(num) or num)
end

function utils.fold_end(num)
  return (vim.fn.foldclosedend(num) ~= -1
    and vim.fn.foldclosedend(num) or num)
end

return utils
