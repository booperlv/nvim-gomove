local utils = {}

-- merges tables
function utils.merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      utils.merge(t1[k], t2[k])
    else t1[k] = v end
  end
  return t1
end

-- checks the index of value in table
function utils.index_of(table, value)
  for k, v in ipairs(table) do
    if v == value then
      return k
    end
  end
  return nil
end

-- creates a number range
function utils.range(from, to)
  local result = {}
  local counter = from
  while (counter <= to) do
    table.insert(result, counter)
    counter = counter+1
  end
  return result
end

-- checks if selection contains fold
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

-- returns foldclosed() if there is a fold
function utils.fold_start(num)
  return (vim.fn.foldclosed(num) ~= -1
    and vim.fn.foldclosed(num) or num)
end

-- returns foldclosedend() if there is a fold
function utils.fold_end(num)
  return (vim.fn.foldclosedend(num) ~= -1
    and vim.fn.foldclosedend(num) or num)
end

-- checks the height of a range based on what user sees
function utils.user_height(start_range, end_range)
  local counter = 0
  local state = start_range
  while (state <= end_range) do
    counter = counter+1
    if vim.fn.foldclosedend(state) ~= -1 then
      state = vim.fn.foldclosedend(state)+1
    else
      state = state + 1
    end
  end
  return counter
end

function utils.reindent(new_line_start, new_line_end)
  local contains_fold = utils.contains_fold(new_line_start, new_line_end)
  if not contains_fold then
    local opts = require("gomove.config").opts
    if opts.reindent_mode == 'vim-move' then
      vim.fn.cursor(new_line_start, 1)

      local old_indent = vim.fn.indent('.')
      vim.cmd("silent! normal! ==")
      local new_indent = vim.fn.indent('.')

      if new_line_start < new_line_end and old_indent ~= new_indent then
        local op = (old_indent < new_indent
          and string.rep(">", new_indent - old_indent)
          or string.rep("<", old_indent - new_indent))
        local old_sw = vim.fn.shiftwidth()
        vim.o.shiftwidth = 1
        vim.cmd('silent! '..new_line_start+1 ..','..new_line_end..op)
        vim.o.shiftwidth = old_sw
      end
    elseif opts.reindent_mode == 'simple' then
      vim.cmd('silent!'..new_line_start..','..new_line_end.."normal!==")
    elseif opts.reindent_mode == 'none' or opts.reindent_mode == nil then
    end
  end
  return new_line_start, new_line_end
end

-- Create a line if it does not exist
function utils.create_line(num)
  local old_pos = vim.fn.winsaveview()
  if vim.fn.line('$') <= num then
    vim.cmd('normal!G'..num-vim.fn.line('$')..'o')
  end
  vim.fn.winrestview(old_pos)
end

--If there is a fold in the destination, open it
function utils.open_fold(line_start, line_end)
  local destn_has_fold, destn_folds = utils.contains_fold(
    line_start, line_end
  )
  if destn_has_fold then
    for _, position in ipairs(destn_folds) do
      vim.cmd(position[1]..","..position[2].."foldopen")
    end
  end
  return destn_has_fold, destn_folds
end

return utils
