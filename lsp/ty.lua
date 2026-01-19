local config = require("lang.python").config

if config.notify then
  vim.notify("Starting LSP: ty")
end

---@type vim.lsp.Config
return config.lsp.ty