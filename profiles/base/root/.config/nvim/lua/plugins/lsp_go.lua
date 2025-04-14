local M = {}

M.name="gopls"
M.dapname="delve"

M.setup = function()

    local lspconfig = require("lspconfig")

    lspconfig.gopls.setup({})

end;

return M
