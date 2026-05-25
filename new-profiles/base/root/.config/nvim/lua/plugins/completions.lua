local M = {}

M.setup = function()

    local cmp = require("cmp")
    local keys = require("../keys").completions(cmp)
    cmp.setup(
    {
        completion =
        {
            autocomplete = false
        },
        window =
        {
            completion    = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert(keys),
        sources = cmp.config.sources(
        {
            { name = "nvim_lsp" },
        }),
    })
end

return M
