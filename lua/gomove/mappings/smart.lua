local M = {}

function M.NormalLeft(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>NormalDuplicateBlockLeft]] or [[\<Plug>NormalMoveBlockLeft]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualLeft(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    --Visual Line mode uses lines
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateLineLeft]] or [[\<Plug>VisualMoveLineLeft]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    --Normal visual, or blockwise all do block movements
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateBlockLeft]] or [[\<Plug>VisualMoveBlockLeft]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

function M.NormalRight(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>NormalDuplicateBlockRight]] or [[\<Plug>NormalMoveBlockRight]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualRight(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    --Visual Line mode uses lines
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateLineRight]] or [[\<Plug>VisualMoveLineRight]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    --Normal visual, or blockwise all do block movements
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateBlockRight]] or [[\<Plug>VisualMoveBlockRight]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

function M.NormalUp(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>NormalDuplicateLineUp]] or [[\<Plug>NormalMoveLineUp]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualUp(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateLineUp]] or [[\<Plug>VisualMoveLineUp]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateBlockUp]] or [[\<Plug>VisualMoveBlockUp]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

function M.NormalDown(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>NormalDuplicateLineDown]] or [[\<Plug>NormalMoveLineDown]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualDown(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateLineDown]] or [[\<Plug>VisualMoveLineDown]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    local plugToUse = (duplicate and [[\<Plug>VisualDuplicateBlockDown]] or [[\<Plug>VisualMoveBlockDown]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

return M
