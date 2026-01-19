local health = vim.health
local conf = require("lang.python").config
local parser = require("lang.python.parser")

local M = {}

local function check_parsers()
  health.start("Parser/s:")
  health.ok("`parser` file found at: `" .. parser.get_file() .. "`")
end

local function check_lsp()
  local lspconf
  local cmd
  local cmd_exec

  health.start("Check enabled LSP:")
  if not (conf.enable and #conf.enable > 0) then
    health.warn("No LSP enabled for `lang.python`!")
  end

  for i, name in pairs(conf.enable) do
    lspconf = vim.lsp.config[name]
    if lspconf then
      cmd = lspconf.cmd
      if cmd then
        cmd_exec = vim.fn.executable(cmd[1])
        if cmd then
          health.ok("LSP `" .. name .. "` executable found! @ `" .. cmd_exec .. "`")
        else
          health.error("LSP `" .. name .. "` executable not found, expected to find `" .. cmd[0] .. "`!")
        end
      else
        health.error("LSP `" .. name .. "` has no command assigned!")
      end
    else
      health.error("Failed to find LSP config entry for `" .. name .. "`")
    end
  end
end

local function check_features()
  health.start("Features:")
  
end

M.check = function()
  local version = require("lang.python").version
  if version then
    health.start("Plugin version: `" .. version .. "`\n")
  end

  check_parsers()
  check_lsp()
  check_features()
end

return M
