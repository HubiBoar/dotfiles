local M = {}

M.name = "bicep";

M.bicep = function()
    local lspconfig = require("lspconfig")
    lspconfig.bicep.setup{}
end;

return M
