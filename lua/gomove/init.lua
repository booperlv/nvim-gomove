local gomove = {}

gomove.opts = {
  map_defaults = true,
  reindent_mode = "vim-move",
  move_past_end_col = false,
  ignore_indent_lh_dup = true,
}

local function map_defaults()
  local map = require("gomove.mappings").map
  map ({
    {"n", "<A-h>", "<Plug>GoNSMLeft", {}},
    {"n", "<A-j>", "<Plug>GoNSMDown", {}},
    {"n", "<A-k>", "<Plug>GoNSMUp", {}},
    {"n", "<A-l>", "<Plug>GoNSMRight", {}},

    {"x", "<A-h>", "<Plug>GoVSMLeft", {}},
    {"x", "<A-j>", "<Plug>GoVSMDown", {}},
    {"x", "<A-k>", "<Plug>GoVSMUp", {}},
    {"x", "<A-l>", "<Plug>GoVSMRight", {}},

    {"n", "<A-H>", "<Plug>GoNSDLeft", {}},
    {"n", "<A-J>", "<Plug>GoNSDDown", {}},
    {"n", "<A-K>", "<Plug>GoNSDUp", {}},
    {"n", "<A-L>", "<Plug>GoNSDRight", {}},

    {"x", "<A-H>", "<Plug>GoVSDLeft", {}},
    {"x", "<A-J>", "<Plug>GoVSDDown", {}},
    {"x", "<A-K>", "<Plug>GoVSDUp", {}},
    {"x", "<A-L>", "<Plug>GoVSDRight", {}},
  })
end

function gomove.setup(opts)
  gomove.opts = vim.tbl_extend("force", gomove.opts, opts or {})
  if gomove.opts.map_defaults == true then
    map_defaults()
  end
end

return gomove
