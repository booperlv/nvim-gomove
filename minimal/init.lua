vim.opt.runtimepath = vim.opt.runtimepath + "~/Projects/nvim-gomove"
vim.opt.foldmethod = "marker"

require("gomove").setup()

--Just a small helper
local function map(allkeys)
  for index, value in ipairs(allkeys) do
    if type(value) == "table" then
      -- mode, key, value, opts
      if #value >= 4 then
        vim.api.nvim_set_keymap(value[1], value[2], value[3], value[4])
      else
        vim.api.nvim_set_keymap(value[1], value[2], value[3], {silent=true})
      end
    else
      print("mapping has invalid values at index "..index)
      return false
    end
  end
  return true
end

map {
  {'n', '<A-m>', '<Plug>GoNSMLeft'},
  {'n', '<A-,>', '<Plug>GoNSMDown'},
  {'n', '<A-.>', '<Plug>GoNSMUp'},
  {'n', '<A-/>', '<Plug>GoNSMRight'},

  {'n', '<A-M>', '<Plug>GoNSDLeft'},
  {'n', '<A-<>', '<Plug>GoNSDDown'},
  {'n', '<A->>', '<Plug>GoNSDUp'},
  {'n', '<A-?>', '<Plug>GoNSDRight'},

  {'x', '<A-m>', '<Plug>GoVSMLeft'},
  {'x', '<A-,>', '<Plug>GoVSMDown'},
  {'x', '<A-.>', '<Plug>GoVSMUp'},
  {'x', '<A-/>', '<Plug>GoVSMRight'},

  {'x', '<A-M>', '<Plug>GoVSDLeft'},
  {'x', '<A-<>', '<Plug>GoVSDDown'},
  {'x', '<A->>', '<Plug>GoVSDUp'},
  {'x', '<A-?>', '<Plug>GoVSDRight'},
}
