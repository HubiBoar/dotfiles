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
                }
            })

            require("mason-lspconfig").setup_handlers(
            {
                [lua.name] = lua.setup,
                [go.name] = go.setup,
            })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies =
        {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts =
        {
            ensure_installed = { go.dapname },
            handlers =
            {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
            },
        }
    }
}
