local lua = require("plugins.lsp_lua")
local dotnet = require("plugins.lsp_omnisharp")
local bicep = require("plugins.lsp_bicep")

require("mason-lspconfig").setup(
{
    automatic_installation = true,
    ensure_installed = {
        lua.name,
        dotnet.name,
        bicep.name,
    }
})

require("mason-lspconfig").setup_handlers(
{
    [lua.name] = lua.setup,
    [dotnet.name] = dotnet.setup,
    [bicep.name] = bicep.setup,
})
