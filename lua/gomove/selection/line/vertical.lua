local line_vertical = {}

function line_vertical.move(vim_start, vim_end, distance)
  if vim.o.modifiable == 0 or distance == 0 then
    return false
  end

  local old_pos = vim.fn.winsaveview()

  local line_start = vim.fn.line(vim_start)
  local line_end = vim.fn.line(vim_end)

  local going_down = (distance > 0)

  local utils = require("gomove.utils")
  local selection_has_fold = utils.contains_fold(line_start, line_end)

  local fold = require('gomove.fold')
  local destn_start, destn_end, encountered_fold = fold.Handle(
    "line", line_start, line_end, distance
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

  local undo = require('gomove.undo')
  undo.Handle(
    undo.LineState(
      line_start, line_end, state_destn_start
    ), state_distance
  )

  print('before is', destn_start, destn_end)

  --Make up for the oddness of :move

  local move_translated_destn = destn_start
  if not (destn_start <= 0) then
    local height = line_end - line_start
    if encountered_fold then
      if going_down then
        destn_start = (utils.fold_end(destn_start) == destn_start
          and destn_start - 1 or utils.fold_end(destn_start))
      else
        destn_start = destn_start + (height+1)
      end
    end
    destn_end = destn_start + height

    print('encountered fold is', destn_start, destn_end)

    if going_down then
      --if within selection
      if destn_start >= line_start and destn_start <= line_end then
        move_translated_destn = destn_end
      else
        move_translated_destn = destn_start
      end
    else
      move_translated_destn = destn_start-1
    end

    print('translated is', move_translated_destn)
  end

  -- Move

  vim.fn.winrestview(old_pos)
  -- print(line_start, line_end, move_translated_destn)
  vim.cmd(line_start..','..line_end..'move'..move_translated_destn)

  --Reindenting

  local new_line_start = vim.fn.line("'[")
  local new_line_end = vim.fn.line("']")

  if not selection_has_fold then
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

  vim.fn.cursor(new_line_start, 1)
  vim.cmd("normal! 0m[")
  vim.fn.cursor(new_line_end, 1)
  vim.cmd("normal! $m]")

  return true
end

return line_vertical
