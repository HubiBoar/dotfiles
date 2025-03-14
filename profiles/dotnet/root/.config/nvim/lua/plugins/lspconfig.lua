local lua = require("plugins.lsp_lua")
local dotnet = require("plugins.lsp_omnisharp")

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
                    dotnet.name,
                }
            })

            require("mason-lspconfig").setup_handlers(
            {
                [lua.name] = lua.setup,
                [dotnet.name] = dotnet.setup,
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
            ensure_installed = { dotnet.dapname },
            handlers =
            {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
                coreclr = dotnet.dap
            },
        }
    }
}
