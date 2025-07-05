local M = {}

M.name="gopls"
M.dapname="delve"
M.version="gopls@v0.19.1"

M.setup = function()

    local lspconfig = require("lspconfig")

    lspconfig.gopls.setup({})

end;

return M
