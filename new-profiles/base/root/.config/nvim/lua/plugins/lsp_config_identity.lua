local M = {}

local lua = require("plugins.lsp_lua")
local roslyn = require("plugins.lsp_roslyn")
local yaml = require("plugins.lsp_yaml")

M.setup = function()
    lua.setup()
    roslyn.setup()
    yaml.setup()
end

return M
