local M = {}

M.pack_lspconfig = {
  src = "https://github.com/neovim/nvim-lspconfig",
  version = "f6738ef65dabade340b473d4ff2a1ad3352c10e7",
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
