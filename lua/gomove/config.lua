local config = {}

config.opts = {}

local function map_defaults()
  local map = require("gomove.mappings").map
  map ({
    {"n", "<A-h>", "<Plug>GoNSMLeft"},
    {"n", "<A-j>", "<Plug>GoNSMDown"},
    {"n", "<A-k>", "<Plug>GoNSMUp"},
    {"n", "<A-l>", "<Plug>GoNSMRight"},

    {"x", "<A-h>", "<Plug>GoVSMLeft"},
    {"x", "<A-j>", "<Plug>GoVSMDown"},
    {"x", "<A-k>", "<Plug>GoVSMUp"},
    {"x", "<A-l>", "<Plug>GoVSMRight"},

    {"n", "<A-H>", "<Plug>GoNSDLeft"},
    {"n", "<A-J>", "<Plug>GoNSDDown"},
    {"n", "<A-K>", "<Plug>GoNSDUp"},
    {"n", "<A-L>", "<Plug>GoNSDRight"},

    {"x", "<A-H>", "<Plug>GoVSDLeft"},
    {"x", "<A-J>", "<Plug>GoVSDDown"},
    {"x", "<A-K>", "<Plug>GoVSDUp"},
    {"x", "<A-L>", "<Plug>GoVSDRight"},
  })
end

function config.setup(opts)
  local default_opts = {
    map_defaults = true,
    reindent_mode = "vim-move",
    move_past_line = false,
    ignore_indent_lh_dup = true,
  }
  local utils = require("gomove.utils")
  config.opts = (
    opts == nil and default_opts
    or utils.merge(default_opts, opts)
  )
  if config.opts.map_defaults == true then
    map_defaults()
  end
  return config.opts
end

return config
