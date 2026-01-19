local M = {
  plugin_dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h:h:h:h"),
}
M.os_info = vim.uv.os_uname()
M.os_name = string.gsub(string.lower(M.os_info.sysname), "_nt", "")
M.arch = M.os_info.machine
M.is_windows = M.os_name == "windows" and true or false

local function roots()
  return coroutine.wrap(function()
    local cwd = vim.fn.getcwd()
    coroutine.yield(cwd)

    local wincwd = vim.fn.getcwd(0)
    if wincwd ~= cwd then
      coroutine.yield(wincwd)
    end

    ---@diagnostic disable-next-line: deprecated
    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    for _, client in ipairs(get_clients()) do
      if client.config.root_dir then
        coroutine.yield(client.config.root_dir)
      end
    end
  end)
end

---@param venv string
---@return string
function M.get_venv_exec(venv)
  if M.is_windows then
    return venv .. '\\Scripts\\python.exe'
  end
  return venv .. '/bin/python'
end

---@return string|nil
function M.get_python_exec()
  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    return M.get_venv_exec(venv_path)
  end

  venv_path = os.getenv("CONDA_PREFIX")
  if venv_path then
    if M.is_windows then
      return venv_path .. '\\python.exe'
    end
    return venv_path .. '/bin/python'
  end

  for root in roots() do
    for _, folder in ipairs({ "venv", ".venv", "env", ".env" }) do
      local path = root .. "/" .. folder
      local stat = vim.uv.fs_stat(path)
      if stat and stat.type == "directory" then
        return M.get_venv_exec(path)
      end
    end
  end

  if vim.fn.executable("python") then
    return "python"
  elseif vim.fn.executable("python3") then
    return "python3"
  end

  return nil
end

return M
