local lua = require("plugins.lsp_lua")
local mason = require("plugins.mason")

return
{
    mason.install(function()
        require("mason-lspconfig").setup(
        {
            automatic_installation = true,
            ensure_installed = {
                lua.version,
            }
        })

        require("mason-lspconfig").setup_handlers(
        {
            [lua.name] = lua.setup,
        })
    end),
}
