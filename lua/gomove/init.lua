local gomove = {}

function gomove.setup(opts)
  require("gomove.config").setup(opts)
  return true
end

return gomove
