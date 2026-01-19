---@brief
---
--- https://docs.astral.sh/ruff/editors/settings/
---

local config = require("lang.python").config

if config.notify then
  vim.notify("Starting LSP: ruff")
end

---@type vim.lsp.Config
return config.lsp.ruff