local lua = require("plugins.lsp_lua")
local dotnet = require("plugins.lsp_omnisharp")
local ts = require("plugins.lsp_ts")
local razor = require("plugins.lsp_razor")
local mason = require("plugins.mason")
local dap = require("plugins.dap")

return
{
    razor.install,
    mason.install(function()
        require("mason-lspconfig").setup(
        {
            automatic_installation = true,
            ensure_installed = {
                lua.version,
                dotnet.version,
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
    end),

    dap.install({
        ensure_installed = { dotnet.dapname },
        handlers =
        {
            function(config)
                require('mason-nvim-dap').default_setup(config)
            end,
            coreclr = dotnet.dap
        },
    })
}
