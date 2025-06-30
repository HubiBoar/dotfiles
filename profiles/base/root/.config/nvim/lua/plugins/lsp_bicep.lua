local M = {}

M.name = "bicep";
M.install = "bicep@v0.36.1";

M.setup = function()
    local lspconfig = require("lspconfig")
    lspconfig.bicep.setup{}
end;

return M
