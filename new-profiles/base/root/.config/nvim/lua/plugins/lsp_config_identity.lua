local M = {}

local lua = require("plugins.lsp_lua")
local yaml = require("plugins.lsp_yaml")
local roslyn = require("plugins.lsp_roslyn")
local bicep = require("plugins.lsp_bicep")
local ts = require("plugins.lsp_ts")

M.setup = function()
    lua.setup()
    yaml.setup()
    roslyn.setup()
    bicep.setup()
    ts.setup()
end

return M
