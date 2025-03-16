local lua = require("plugins.lsp_lua")
local dotnet = require("plugins.lsp_omnisharp")
local ts = require("plugins.lsp_ts")
local razor = require("plugins.lsp_razor")

return
{
    razor.install,
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
                    razor.name,
                    ts.name,
                    ts.eslint,
                    ts.html,
                    "bashls",
                }
            })

            require("mason-lspconfig").setup_handlers(
            {
                [lua.name] = lua.setup,
                [dotnet.name] = dotnet.setup,
                [ts.name] = ts.setup,
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
