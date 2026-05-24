local M = {}

M.setup = function(name, client, bufnr)
    print("LSP: " .. name)
    if client.server_capabilities.signatureHelpProvider then
        local keys = require("../keys")
        require("lsp-overloads").setup(client, {
            keymaps = keys.overloads_keymaps(),
            display_automatically = false,
        })
        keys.overloads(bufnr)
    end
end

M.install = {
    "Issafalcon/lsp-overloads.nvim",
    commit = "7d766bfccbff2ab0be8089ea4d1493089f67a408"
}

return M
