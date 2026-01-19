local config = require("lang.python").config

if config.notify then
  vim.notify("Starting LSP: pylsp")
end

---@type vim.lsp.Config
return config.lsp.pylsp