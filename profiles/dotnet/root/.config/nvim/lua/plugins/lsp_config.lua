local lua = require("plugins.lsp_lua")
local dotnet = require("plugins.lsp_omnisharp")
local mason = require("plugins.mason")
local dap = require("plugins.dap")

return
{
    mason.install(function()
        require("mason-lspconfig").setup(
        {
            automatic_installation = true,
            ensure_installed = {
                lua.version,
                dotnet.version,
            }
        })

        require("mason-lspconfig").setup_handlers(
        {
            [lua.name] = lua.setup,
            [dotnet.name] = dotnet.setup,
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
