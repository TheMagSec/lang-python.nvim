---@brief
---
--- https://github.com/microsoft/pyright
---
--- `pyright`, a static type checker and language server for python
---
--- Config and helper functions are from: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/pyright.lua

local config = require("lang.python").config

if config.notify then
  vim.notify("Starting LSP: pylsp")
end

local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python =
        vim.tbl_deep_extend('force', client.settings.python --[[@as table]], { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client:notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

config.lsp.pyright.on_attach = config.lsp.pyright.on_attach or function(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
    local params = {
      command = 'pyright.organizeimports',
      arguments = { vim.uri_from_bufnr(bufnr) },
    }

    -- Using client.request() directly because "pyright.organizeimports" is private
    -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
    -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
    ---@diagnostic disable-next-line: param-type-mismatch
    client.request('workspace/executeCommand', params, nil, bufnr)
  end, {
    desc = 'Organize Imports',
  })

  vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
    desc = 'Reconfigure pyright with the provided python path',
    nargs = 1,
    complete = 'file',
  })
end


---@type vim.lsp.Config
return config.lsp.pyright
