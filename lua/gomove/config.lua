local config = {}

config.opts = {}

function config.setup(opts)
  local default_opts = {
    reindent_mode = "vim-move",
    move_past_line = false,
    ignore_indent_in_line_horizontal_duplicate = true,
  }
  local utils = require("gomove.utils")
  config.opts = (
    opts == nil and default_opts
    or utils.merge(default_opts, opts)
  )
  return config.opts
end

return config
