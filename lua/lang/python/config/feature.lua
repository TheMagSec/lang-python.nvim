local utils = require("lang.python.utils")

---@class lang.python.config.feature.Feature
---@field executable string|nil
---@field setup function
---@field settings table<string, any>

---@alias lang.python.config.feature.Features table<string, lang.python.config.feature.Feature>

---@type lang.python.config.feature.Features
return {
  dap = {
    executable = "debugpy-adapter", -- "uv", or python-exec which has debugpy installed
    setup = function(conf)
      local has_dap, dap = pcall(require, "dap")
      if has_dap then
        -- require("dap-python").setup(conf.executable)
        dap.configurations.python = conf.settings

        local python_path = conf.executable
        dap.adapters.python = function(cb, config)
          if config.request == 'attach' then
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or '127.0.0.1'

            ---@type dap.ServerAdapter
            local adapter = {
              type = 'server',
              port = assert(port, '`connect.port` is required for a python `attach` configuration'),
              host = host,
              enrich_config = enrich_config,
              options = {
                source_filetype = 'python',
              }
            }
            cb(adapter)
          else
            ---@type dap.ExecutableAdapter
            local adapter
            local basename = vim.fn.fnamemodify(python_path, ":t")
            if basename == "uv" then
              adapter = {
                type = "executable",
                command = python_path,
                args = { "run", "--with", "debugpy", "python", "-m", "debugpy.adapter" },
                enrich_config = enrich_config,
                options = {
                  source_filetype = "python"
                }
              }
            elseif basename == "debugpy-adapter" then
              adapter = {
                type = "executable",
                command = python_path,
                args = {},
                enrich_config = enrich_config,
                options = {
                  source_filetype = "python"
                }
              }
            else
              adapter = {
                type = "executable",
                command = python_path,
                args = { "-m", "debugpy.adapter" },
                enrich_config = enrich_config,
                options = {
                  source_filetype = "python"
                }
              }
            end
            cb(adapter)
          end
        end
      end
    end,
    settings = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        -- Options below are for debugpy,
        -- see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
        -- for supported options
        program = "${file}",
        console = "integratedTerminal",
      }
    }
  },

  neotest = {
    executable = nil,
    setup = function(conf)
      vim.g.neotest = vim.g.neotest or {}
      vim.g.neotest.adapters = vim.g.neotest.adapters or {}
      vim.g.neotest.adapters["python"] = require("neotest-python")({ conf.settings })
    end,
    settings = {
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
      dap = { justMyCode = false },
      args = { "--log-level", "DEBUG" },
      -- Runner to use. Will use pytest if available by default.
      -- Can be a function to return dynamic value.
      runner = "pytest",
      python = utils.get_python_exec,
      pytest_discover_instances = true,
    }
  }
}
