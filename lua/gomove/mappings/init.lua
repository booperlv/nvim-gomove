local M = {}

--Just a small helper
function M.map(allkeys)
  for index, value in ipairs(allkeys) do
    if type(value) == "table" then
      -- mode, key, value, opts
      if #value == 4 then
        vim.api.nvim_set_keymap(value[1], value[2], value[3], value[4])
      else
        vim.api.nvim_set_keymap(value[1], value[2], value[3], {silent=true, noremap=true})
      end
    else
      print("mapping has invalid values at index "..index)
      return false
    end
  end
  return true
end


function M.SetMaps()
  M.map {
    {'n', '<Plug>GoNMLineLeft',  ":<C-u>lua require('gomove.mappings.base').MoveLineHorizontal(-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNMLineDown',  ":<C-u>lua require('gomove.mappings.base').MoveLineVertical  ( vim.v.count1)<CR>"},
    {'n', '<Plug>GoNMLineUp',    ":<C-u>lua require('gomove.mappings.base').MoveLineVertical  (-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNMLineRight', ":<C-u>lua require('gomove.mappings.base').MoveLineHorizontal( vim.v.count1)<CR>"},

    {'x', '<Plug>GoVMLineLeft',  ":<C-u>lua require('gomove.mappings.base').VisualMoveLineHorizontal(-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVMLineDown',  ":<C-u>lua require('gomove.mappings.base').VisualMoveLineVertical  ( vim.v.count1)<CR>"},
    {'x', '<Plug>GoVMLineUp',    ":<C-u>lua require('gomove.mappings.base').VisualMoveLineVertical  (-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVMLineRight', ":<C-u>lua require('gomove.mappings.base').VisualMoveLineHorizontal( vim.v.count1)<CR>"},

    {'n', '<Plug>GoNDLineLeft',  ":<C-u>lua require('gomove.mappings.base').DuplicateLineHorizontal(-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNDLineDown',  ":<C-u>lua require('gomove.mappings.base').DuplicateLineVertical  ( vim.v.count1)<CR>"},
    {'n', '<Plug>GoNDLineUp',    ":<C-u>lua require('gomove.mappings.base').DuplicateLineVertical  (-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNDLineRight', ":<C-u>lua require('gomove.mappings.base').DuplicateLineHorizontal( vim.v.count1)<CR>"},

    {'x', '<Plug>GoVDLineLeft',  ":<C-u>lua require('gomove.mappings.base').VisualDuplicateLineHorizontal(-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVDLineDown',  ":<C-u>lua require('gomove.mappings.base').VisualDuplicateLineVertical  ( vim.v.count1)<CR>"},
    {'x', '<Plug>GoVDLineUp',    ":<C-u>lua require('gomove.mappings.base').VisualDuplicateLineVertical  (-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVDLineRight', ":<C-u>lua require('gomove.mappings.base').VisualDuplicateLineHorizontal( vim.v.count1)<CR>"},


    {'n', '<Plug>GoNMBlockLeft',  ":<C-u>lua require('gomove.mappings.base').MoveBlockHorizontal(-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNMBlockDown',  ":<C-u>lua require('gomove.mappings.base').MoveBlockVertical  ( vim.v.count1)<CR>"},
    {'n', '<Plug>GoNMBlockUp',    ":<C-u>lua require('gomove.mappings.base').MoveBlockVertical  (-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNMBlockRight', ":<C-u>lua require('gomove.mappings.base').MoveBlockHorizontal( vim.v.count1)<CR>"},

    {'x', '<Plug>GoVMBlockLeft',  ":<C-u>lua require('gomove.mappings.base').VisualMoveBlockHorizontal(-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVMBlockDown',  ":<C-u>lua require('gomove.mappings.base').VisualMoveBlockVertical  ( vim.v.count1)<CR>"},
    {'x', '<Plug>GoVMBlockUp',    ":<C-u>lua require('gomove.mappings.base').VisualMoveBlockVertical  (-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVMBlockRight', ":<C-u>lua require('gomove.mappings.base').VisualMoveBlockHorizontal( vim.v.count1)<CR>"},

    {'n', '<Plug>GoNDBlockLeft',  ":<C-u>lua require('gomove.mappings.base').DuplicateBlockHorizontal(-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNDBlockDown',  ":<C-u>lua require('gomove.mappings.base').DuplicateBlockVertical  ( vim.v.count1)<CR>"},
    {'n', '<Plug>GoNDBlockUp',    ":<C-u>lua require('gomove.mappings.base').DuplicateBlockVertical  (-vim.v.count1)<CR>"},
    {'n', '<Plug>GoNDBlockRight', ":<C-u>lua require('gomove.mappings.base').DuplicateBlockHorizontal( vim.v.count1)<CR>"},

    {'x', '<Plug>GoVDBlockLeft',  ":<C-u>lua require('gomove.mappings.base').VisualDuplicateBlockHorizontal(-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVDBlockDown',  ":<C-u>lua require('gomove.mappings.base').VisualDuplicateBlockVertical  ( vim.v.count1)<CR>"},
    {'x', '<Plug>GoVDBlockUp',    ":<C-u>lua require('gomove.mappings.base').VisualDuplicateBlockVertical  (-vim.v.count1)<CR>"},
    {'x', '<Plug>GoVDBlockRight', ":<C-u>lua require('gomove.mappings.base').VisualDuplicateBlockHorizontal( vim.v.count1)<CR>"},




    {'n', '<Plug>GoNSMLeft',  ":<C-u>lua require('gomove.mappings.smart').NormalLeft (false, vim.v.count1)<CR>"},
    {'n', '<Plug>GoNSMDown',  ":<C-u>lua require('gomove.mappings.smart').NormalDown (false, vim.v.count1)<CR>"},
    {'n', '<Plug>GoNSMUp',    ":<C-u>lua require('gomove.mappings.smart').NormalUp   (false, vim.v.count1)<CR>"},
    {'n', '<Plug>GoNSMRight', ":<C-u>lua require('gomove.mappings.smart').NormalRight(false, vim.v.count1)<CR>"},

    {'x', '<Plug>GoVSMLeft',  ":<C-u>lua require('gomove.mappings.smart').VisualLeft (false, vim.v.count1)<CR>"},
    {'x', '<Plug>GoVSMDown',  ":<C-u>lua require('gomove.mappings.smart').VisualDown (false, vim.v.count1)<CR>"},
    {'x', '<Plug>GoVSMUp',    ":<C-u>lua require('gomove.mappings.smart').VisualUp   (false, vim.v.count1)<CR>"},
    {'x', '<Plug>GoVSMRight', ":<C-u>lua require('gomove.mappings.smart').VisualRight(false, vim.v.count1)<CR>"},

    {'n', '<Plug>GoNSDLeft',  ":<C-u>lua require('gomove.mappings.smart').NormalLeft (true, vim.v.count1)<CR>"},
    {'n', '<Plug>GoNSDDown',  ":<C-u>lua require('gomove.mappings.smart').NormalDown (true, vim.v.count1)<CR>"},
    {'n', '<Plug>GoNSDUp',    ":<C-u>lua require('gomove.mappings.smart').NormalUp   (true, vim.v.count1)<CR>"},
    {'n', '<Plug>GoNSDRight', ":<C-u>lua require('gomove.mappings.smart').NormalRight(true, vim.v.count1)<CR>"},

    {'x', '<Plug>GoVSDLeft',  ":<C-u>lua require('gomove.mappings.smart').VisualLeft (true, vim.v.count1)<CR>"},
    {'x', '<Plug>GoVSDDown',  ":<C-u>lua require('gomove.mappings.smart').VisualDown (true, vim.v.count1)<CR>"},
    {'x', '<Plug>GoVSDUp',    ":<C-u>lua require('gomove.mappings.smart').VisualUp   (true, vim.v.count1)<CR>"},
    {'x', '<Plug>GoVSDRight', ":<C-u>lua require('gomove.mappings.smart').VisualRight(true, vim.v.count1)<CR>"},
  }
end

return M
