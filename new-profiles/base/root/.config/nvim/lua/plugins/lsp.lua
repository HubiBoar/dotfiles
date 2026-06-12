local M = {}

M.pack = {
  src = "https://github.com/neovim/nvim-lspconfig",
  version = "a4ed4e761c400849e8c9f8bda33e5083f890268c",
}

M.setup = function()

    require("../keys").lsp()
    vim.diagnostic.config(
    {
        virtual_text = false
    })
end

return M
