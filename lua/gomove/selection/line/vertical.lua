local line_vertical = {}

function line_vertical.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)

  local going_down = (distance > 0)

  local utils = require("gomove.utils")
  local selection_has_fold, folds = utils.contains_fold(line_start, line_end)

  local fold = require('gomove.fold')
  local destn_start, destn_end, encountered_fold = fold.Handle(
    line_start, line_end, distance
  )

  if line_start == destn_start and line_end == destn_end then
    return false
  end

  --Now that the calculation is finished, Since before is always based on
  --the first cursor position, we can just set state_before to linebefore
  --and it will not mess up recognizing continuous actions.
  local state_destn_start = destn_start
  --This allows oldState.after + distance == newState.after in the undojoin
  --to remain true, only in the correct times.
  local state_distance = destn_start - line_start

  local register = 'z'
  local old_register_value = vim.fn.getreg(register)

  local undo = require('gomove.undo')
  undo.Handle(
    undo.LineState(
      vim_start, vim_end, state_destn_start
    ), state_distance
  )

  if encountered_fold then
    -- take into account the odd(?) behavior of :move with folds
    if going_down then
      destn_start = destn_start - (1)
      destn_end = destn_end - (1)
    else
      destn_start = destn_start + (1)
      destn_end = destn_end + (1)
    end
  end

  vim.cmd(line_start..','..line_end..'move'..destn_start)

  vim.fn.setreg(register, old_register_value)

  --Reindenting

  line_start = vim.fn.line("'[")
  line_end = vim.fn.line("']")

  local opts = require("gomove.config").opts
  if opts.reindent_mode == 'vim-move' then
    vim.fn.cursor(line_start, 1)

    local old_indent = vim.fn.indent('.')
    vim.cmd("silent! normal! ==")
    local new_indent = vim.fn.indent('.')

    if line_start < line_end and old_indent ~= new_indent then
      local op = (old_indent < new_indent
                  and string.rep(">", new_indent - old_indent)
                  or string.rep("<", old_indent - new_indent))
      local old_sw = vim.fn.shiftwidth()
      vim.o.shiftwidth = 1
      vim.cmd('silent! '..line_start+1 ..','..line_end..op)
      vim.o.shiftwidth = old_sw
    end
  elseif opts.reindent_mode == 'simple' then
    vim.cmd('silent!'..line_start..','..line_end.."normal!==")
  elseif opts.reindent_mode == 'none' or opts.reindent_mode == nil then
  end

  if selection_has_fold then
    for _, position in ipairs(folds) do
      vim.cmd(position[1]..','..position[2]..'foldclose')
    end
  end

  vim.fn.cursor(line_start, 1)
  vim.cmd("normal! 0m[")
  vim.fn.cursor(line_end, 1)
  vim.cmd("normal! $m]")

  return true
end

return line_vertical
