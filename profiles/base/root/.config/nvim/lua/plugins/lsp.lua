local overloads = require("plugins.lspoverloads");

return
{
    {
        overloads.install
    },
    {
        "neovim/nvim-lspconfig",
        commit = "a182334ba933e58240c2c45e6ae2d9c7ae313e00",
        config = function ()

            require("../keys").lsp()
            vim.diagnostic.config(
            {
                virtual_text = false
            })
        end,
    }
}
