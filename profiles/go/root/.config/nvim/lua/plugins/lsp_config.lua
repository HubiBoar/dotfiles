local lua = require("plugins.lsp_lua")
local go = require("plugins.lsp_go")
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
                go.version,
            }
        })

        require("mason-lspconfig").setup_handlers(
        {
            [lua.name] = lua.setup,
            [go.name] = go.setup,
        })
    end),

    dap.install({
        ensure_installed = { go.dapname },
        handlers =
        {
            function(config)
                require('mason-nvim-dap').default_setup(config)
            end,
        },
    })
}
