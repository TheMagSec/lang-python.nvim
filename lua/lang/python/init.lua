local M = {
  version = "0.5.0",
  config = require("lang.python.config") ---@type lang.python.Config
}

vim.lang = vim.lang or { config = {} }
vim.lang.config["python"] = M.config

-- init cache
vim.g.lang = vim.g.lang or { python = {} }


---@param key string
---@param toggle boolean?
local function is_cached(key, toggle)
  local lang = vim.g.lang

  if lang.python and lang.python[key] then
    return true
  end

  if toggle then
    lang.python = lang.python or {}
    lang.python[key] = true
    vim.g.lang = lang
  end

  return false
end

local function setup_features()
  if is_cached("features_loaded", true) then
    return
  end

  for feature, feat_conf in pairs(M.config.feature) do
    if (type(feat_conf) == "table") then
      -- print("Configure Python feature: " .. feature)
      feat_conf.setup(feat_conf)
    end
  end
end

local function setup_parsers()
  if is_cached("parsers_loaded", true) then
    return
  end

  require("lang.python.parser").get_files()
end

function M.enable()
  if is_cached("enabled", true) then
    return
  end

  setup_parsers()
  setup_features()

  vim.lsp.enable(M.config.enable)
end

--- Configure Python LSP/s, DAP and Neotest.
--- Default setup uses 'pylsp', 'ruff' and 'ty' as LSP's.
--- If 'nvim-dap' is installed, DAP will be configured like 'nvim-dap-python'
--- If 'neotest' is installed, 
---@param opts lang.python.Config
function M.setup(opts)
  setup_parsers()
  setup_features()
end

return M
