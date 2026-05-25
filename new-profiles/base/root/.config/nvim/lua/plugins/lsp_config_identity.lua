local M = {}

local lua = require("plugins.lsp_lua")
local roslyn = require("plugins.lsp_roslyn")

M.setup = function()
    lua.setup()
    roslyn.setup()
end

return M
