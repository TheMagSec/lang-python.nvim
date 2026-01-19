local utils = require("lang.python.utils")
local M = {}

local parsers_dir = utils.plugin_dir .. "/parser"
local ext = (utils.os_name == "win32" and ".dll") or ".so"

local function arch_parser_file(name)
  return parsers_dir .. "/." .. name .. "." .. utils.os_name .. "." .. utils.arch .. ext
end

function M.get_file(name)
  local parser_file = parsers_dir .. "/" .. name .. ext
  if vim.uv.fs_stat(parser_file) then
    return parser_file
  end

  local opts = { dir = false }

  if utils.os_name == "win32" then
    opts.junction = true
  end

  local ok, err = vim.uv.fs_symlink(arch_parser_file(name), parser_file, opts)
  if not ok then
    vim.notify("Failed to symlink parser file '" .. name .. ext .. "'!\n" .. err, "ERROR")
    return nil
  end

  return parser_file
end

function M.get_files()
  local names = { "rst", "python" }
  local path
  local parsers = {}
  for _, name in pairs(names) do
    path = M.get_file(name)
    table.insert(parsers, path)
  end
  return parsers
end

return M
