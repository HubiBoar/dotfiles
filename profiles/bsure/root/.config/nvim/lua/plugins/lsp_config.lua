local lua = require("plugins.lsp_lua")
local dotnet = require("plugins.lsp_omnisharp")
local bicep = require("plugins.lsp_bicep")

dotnet.setup()

require("mason-lspconfig").setup(
{
    automatic_installation = true,
    ensure_installed = {
        lua.install,
        bicep.install,
    }
})

require("mason-lspconfig").setup_handlers(
{
    [lua.name] = lua.setup,
    [bicep.name] = bicep.setup,
})
