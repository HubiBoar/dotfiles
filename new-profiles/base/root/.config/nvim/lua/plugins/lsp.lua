local M = {}

M.pack_lspconfig = {
  src = "https://github.com/neovim/nvim-lspconfig",
  version = "a4ed4e761c400849e8c9f8bda33e5083f890268c",
}

M.pack_overloads = {
  src = "https://github.com/Issafalcon/lsp-overloads.nvim",
  version = "7d766bfccbff2ab0be8089ea4d1493089f67a408",
}

M.setup = function()

    require("../keys").lsp()
    vim.diagnostic.config(
    {
        virtual_text = false
    })
end

return M
