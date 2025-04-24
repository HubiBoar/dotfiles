local M = {}

M.name = "bicep";

M.setup = function()
    local lspconfig = require("lspconfig")
    lspconfig.bicep.setup{}
end;

return M
