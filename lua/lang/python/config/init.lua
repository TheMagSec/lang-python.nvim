---@class lang.python.config.LSP
---@field cmd table[string]
---@field fieltypes table[string|table[string]]

---@class lang.python.config.Feature
---@field executable string
---@field setup function
---@field settings table<string, any>

--- @class lang.python.Config
--- @field notify boolean
--- @field enable string[]
--- @field parsers table[string]
--- @field lsp lang.python.config.lsp.Configs>
--- @field feature table<string, lang.python.config.feature.Feature>
local M = {
  notify = false,
  enable = { "ruff", "ty" },
  lsp = require("lang.python.config.lsp"),
  feature = require("lang.python.config.feature"),
}

function M.is_enabled(lang)
  for _, name in pairs(M.enable) do
    if name == lang then
      return true
    end
  end
  return false
end

return M
