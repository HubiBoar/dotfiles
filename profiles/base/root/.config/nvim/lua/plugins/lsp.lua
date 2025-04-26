local overloads = require("plugins.lspoverloads");

return
{
    {
        overloads.install
    },
    {
        "neovim/nvim-lspconfig",
        config = function ()

            require("../keys").lsp()
            vim.diagnostic.config(
            {
                virtual_text = false
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end,
    }
}
