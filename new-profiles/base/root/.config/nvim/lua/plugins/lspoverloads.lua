local M = {}

M.pack = {
  src = "https://github.com/Issafalcon/lsp-overloads.nvim",
  version = "4a9277c52455785096ddc4df13208c67fd696343",
}

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

return M
