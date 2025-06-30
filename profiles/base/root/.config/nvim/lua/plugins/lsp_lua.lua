local M = {}

M.name = "lua_ls";
M.install = "lua_ls@3.14.0";

M.setup = function()
    local overloads = require("plugins.lspoverloads")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup(
    {
        diagnostics = { disable = { 'missing-fields' } },
        capabilities = capabilities,
        settings =
        {
            Lua =
            {
                runtime =
                {
                    version = "LuaJIT",
                },
                diagnostics =
                {
                    globals = { "vim" },
                },
                workspace =
                {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry =
                {
                    enable = false,
                },
            }
        },
        on_attach = function(client, bufnr)
            overloads.setup("lua", client, bufnr);
        end,
    })
end

return M
