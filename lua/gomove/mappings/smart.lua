local M = {}

function M.NormalLeft(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>GoNDBlockLeft]] or [[\<Plug>GoNMBlockLeft]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualLeft(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    --Visual Line mode uses lines
    local plugToUse = (duplicate and [[\<Plug>GoVDLineLeft]] or [[\<Plug>GoVMLineLeft]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    --Normal visual, or blockwise all do block movements
    local plugToUse = (duplicate and [[\<Plug>GoVDBlockLeft]] or [[\<Plug>GoVMBlockLeft]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

function M.NormalRight(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>GoNDBlockRight]] or [[\<Plug>GoNMBlockRight]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualRight(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    --Visual Line mode uses lines
    local plugToUse = (duplicate and [[\<Plug>GoVDLineRight]] or [[\<Plug>GoVMLineRight]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    --Normal visual, or blockwise all do block movements
    local plugToUse = (duplicate and [[\<Plug>GoVDBlockRight]] or [[\<Plug>GoVMBlockRight]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

function M.NormalUp(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>GoNDLineUp]] or [[\<Plug>GoNMLineUp]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualUp(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    local plugToUse = (duplicate and [[\<Plug>GoVDLineUp]] or [[\<Plug>GoVMLineUp]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    local plugToUse = (duplicate and [[\<Plug>GoVDBlockUp]] or [[\<Plug>GoVMBlockUp]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

function M.NormalDown(duplicate, distance)
  local plugToUse = (duplicate and [[\<Plug>GoNDLineDown]] or [[\<Plug>GoNMLineDown]])
  vim.cmd('execute "normal'..distance..plugToUse..'"')
end
function M.VisualDown(duplicate, distance)
  local mode = vim.fn.visualmode()
  vim.cmd('normal! gv')
  if mode == 'V' then
    local plugToUse = (duplicate and [[\<Plug>GoVDLineDown]] or [[\<Plug>GoVMLineDown]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  else
    local plugToUse = (duplicate and [[\<Plug>GoVDBlockDown]] or [[\<Plug>GoVMBlockDown]])
    vim.cmd('execute "normal'..distance..plugToUse..'"')
  end
end

return M
