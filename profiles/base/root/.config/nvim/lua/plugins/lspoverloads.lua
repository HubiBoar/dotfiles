local M = {}

M.setup = function(name, client, bufnr)
    print("LSP: " .. name)
    if client.server_capabilities.signatureHelpProvider then
        local keys = require("../keys")
        require("lsp_overloads").setup(client, {
            keymaps = keys.overloads_keymaps(),
            display_automatically = false,
        })
        keys.overloads(bufnr)
    end
end

M.install = {
    "Issafalcon/lsp-overloads.nvim",
}

return M
