local lua = require("plugins.lsp_lua")
local go = require("plugins.lsp_go")

return
{
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim", "lsp-overloads.nvim" },
        config = function()

            require("mason-lspconfig").setup(
            {
                automatic_installation = true,
                ensure_installed = {
                    lua.name,
                    go.name,
                    go.delve,
                }
            })

            require("mason-lspconfig").setup_handlers(
            {
                [lua.name] = lua.setup,
            })
        end,
    },
}
