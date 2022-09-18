local lspconfig = require('lspconfig')
local util = require('util')
local linters = require('lsp.linters')
local configuration = require('lsp.configuration')
local keybinds = require('lsp.keybinds')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- Server Configuration
local servers = {
  { 'pyright',
    config = {
      root_dir = function(fname)
        local root_files = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
        }
        return lspconfig.util.root_pattern(unpack(root_files))(fname) or lspconfig.util.find_git_ancestor(fname) or lspconfig.util.path.dirname(fname)
      end
    }
  },
  'clangd',
  { 'bashls',
    config = {
      single_file_support = true
    }
  },
  'vimls',
  'html',
  'yamlls',
  { 'cssls',
    config = {
      single_file_support = true
    }
  },
  { 'stylelint_lsp',
    config = {
      filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss" }
    }
  },
  { 'tsserver',
    config = {
      on_attach = function(client)
        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end
        client.resolved_capabilities.document_formatting = true
        keybinds.set_keybinds()
      end,
    }
  },
  { 'efm',
    override = true,
    config = {
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.goto_definition = false
      end,
      root_dir = function()
        if not linters.eslint_config_exists() then
          return nil
        end
        return vim.fn.getcwd()
      end,
      settings = {
        languages = {
          javascript = {linters.eslint},
          javascriptreact = {linters.eslint},
          ["javascript.jsx"] ={linters.eslint},
          typescript ={linters.eslint},
          ["typescript.tsx"] ={linters.eslint},
          typescriptreact ={linters.eslint},
          json = {linters.prettier},
          html = {linters.prettier}
        }
      },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
        "json"
      },
      single_file_support = false
    }
  },
  { "sumneko_lua",
    config = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path
          },
          diagnostics = {
            globals = {"vim"}
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true)
          },
          telemetry = {
            enable = false
          }
        }
      }
    }
  }
}

-- Run the setup for each server
for _, lsp in ipairs(servers) do
  if type(lsp) == "string" then
    lspconfig[lsp].setup(configuration)
---@diagnostic disable-next-line: undefined-field
  elseif lsp.override then
---@diagnostic disable-next-line: undefined-field
    lspconfig[lsp[1]].setup(lsp.config)
  else
---@diagnostic disable-next-line: undefined-field
    lspconfig[lsp[1]].setup(util.spread(configuration)(lsp.config))
  end
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
 vim.lsp.handlers.hover, {
   -- Use a sharp border with `FloatBorder` highlights
   border = "single"
 }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   -- Enable underline, use default values
   underline = true,
   -- Enable virtual text, override spacing to 4
   virtual_text = {
     spacing = 1,
   },
   -- Use a function to dynamically turn signs off
   -- and on, using buffer local variables
   signs = function() end,
   -- Disable a feature
   update_in_insert = false,
 }
)

require('lsp.diagnostics')
