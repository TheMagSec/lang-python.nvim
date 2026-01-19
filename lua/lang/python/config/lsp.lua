local default = require("lang.python.config.defaults")

---@class enabled
---@field enabled boolean

---@class lsp.settings.pylsp.plugins
---@field autopep8? enabled
---@field black? enabled
---@field flake8? enabled
---@field isort? enabled 
---@field mccabe? enabled
---@field mypy? enabled
---@field pylsp_mypy? enabled
---@field pycodestyle? enabled
---@field pydocstyle? enabled
---@field pyflakes? enabled
---@field pylint? enabled
---@field rope? enabled
---@field ruff? enabled
---@field yapf? enabled
---@field jedi? enabled            
---@field jedi_completion? enabled
---@field jedi_definition? enabled
---@field jedi_hover? enabled
---@field jedi_references? enabled
---@field jedi_symbols? enabled
---@field preload? enabled

---@class lsp.settings.pylsp.signature
---@field formatter enabled

---@class lsp.settings.pylsp
---@field configurationSources? ("pycodestyle" | "flake8")[]
---@field signature? lsp.settings.pylsp.signature
---@field plugins? lsp.settings.pylsp.plugins


---@class lsp.settings.pyright
---@field disableLanguageServices boolean
---@field disableOrganizeImports boolean
---@field disableTaggedHints boolean
---@field openFilesOnly boolean
---@field useLibraryCodeForTypes boolean

---@class lsp.settings.pyright.settings
---@field diagnosticMode? "openFilesOnly" | "workspace"
---@field pythonPath? string
---@field useLibraryCodeForTypes? boolean
---@field typeCheckingMode? "off" | "basic" | "strict"
---@field autoSearchPaths? boolean
---@field reportMissingImports? "none" | "information" | "warning" | "error"
---@field analysys { autoSearchPaths?: boolean, useLibraryCodeForTypes?: boolean, diagnosticMode?: 'openFilesOnly', ignore: table}
---@field venvPath? string


---@class lsp.settings.ruff
---@field loglevel? "debug" | "info" | "warning"
---@field configuration { lint?: { enable: boolean, run: "onType" | "onSave" } , format?: { enable: boolean } }
---@field organizeImports? boolean


---@class lsp.settings.ty
---@field diagnosticMode? "openFilesOnly" | "workspace"


---@class lang.python.config.lsp.settings
---@field pylsp? lsp.settings.pylsp
---@field ty? lsp.settings.ty
---@field python? lsp.settings.pyright.settings
---@field pyright? lsp.settings.pyright


---@class lang.python.config.lsp.Config : vim.lsp.Config
---@field settings? lang.python.config.lsp.settings


---@alias lang.python.config.lsp.Configs table<string, lang.python.config.lsp.Config>

---@type lang.python.config.lsp.Configs
return {
  -- Python-LSP-Server {{{
  pylsp = {
    cmd = { "pylsp" },
    filetypes = default.filetypes,
    root_markers = { default.root_markers, ".git" },
    settings = {
      ---@type lsp.settings.pylsp
      pylsp = {
        signature = { formatter = { enabled = true } },
        plugins = {
          autopep8 = { enabled = false },
          pycodestyle = { enabled = false },
          pydocstyle = { enabled = false },
          flake8 = { enabled = false },
          mccabe = { enabled = false },
          pylint = { enabled = false },
          pyflakes = { enabled = false },
          yapf = { enabled = false },
          black = { enabled = false },
          mypy = { enabled = true },
          rope = { enabled = true },
          ruff = { enabled = true },
          pylsp_rope = { enabled = true },
          pylsp_mypy = { enabled = true },
        },
      },
    }
  },
  -- }}}

  -- Pyright (Microsoft) {{{
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = default.filetypes,
    root_markers = { default.root_markers, "pyrightconfig.json", ".git" },
    settings = {
      ---@type lsp.settings.pyright
      pyright = {},
      ---@type lsp.settings.pyright.settings
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        }
      }
    }
  },
  -- }}}

  -- Ruff (Astral) {{{
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = default.filetypes,
    root_markers = { default.root_markers, { "ruff.toml", ".ruff.toml" }, ".git" },
    init_options = {
      ---@type lsp.settings.ruff
      settings = { 
        configurationPreference = "filesystemFirst",
        loglevel = "info",
        configuration = {
          format = {},
          lint = {}
        }
      }
    }
  },
  -- }}}

  -- Ty (Astral) {{{
  ty = {
    cmd = { "ty", "server" },
    filetypes = default.filetypes,
    root_markers = { default.root_markers, { "ty.toml", ".ty.toml" }, ".git" },
    settings = {
      ty = {
        diagnosticMode = "openFilesOnly"
      }
    }
  },
  -- }}}
}