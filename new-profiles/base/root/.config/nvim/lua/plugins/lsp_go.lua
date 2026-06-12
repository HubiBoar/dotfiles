local M = {}

M.setup = function()
  local overloads = require("plugins.lspoverloads")

  vim.lsp.config("gopls", {
    cmd = { "gopls" },

    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          nilness = true,
          unusedwrite = true,
          useany = true,
        },

        staticcheck = true,

        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },

    on_attach = function(client, bufnr)
      overloads.setup("go", client, bufnr)
    end,
  })

  vim.lsp.enable("gopls")
end

return M
