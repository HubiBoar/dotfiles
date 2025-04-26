local M = {}

M.name = "ts_ls"
M.html = "html"
M.eslint = "eslint"

M.setup = function()

    local overloads = require("plugins.lspoverloads")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.ts_ls.setup(
    {
        capabilities = capabilities,
        settings = {
            completions = {
                completeFunctionCalls = true
            }
        },
        on_attach = function(client, bufnr)
            overloads.setup("ts", client, bufnr);
        end,
    })
end

return M
