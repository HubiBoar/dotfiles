local M = {}

M.pack_cmp = {
  src = "https://github.com/hrsh7th/nvim-cmp",
  version = "b5311ab3ed9c846b585c0c15b7559be131ec4be9",
}

M.pack_lsp = {
  src = "https://github.com/hrsh7th/cmp-nvim-lsp",
  version = "a8912b88ce488f411177fc8aed358b04dc246d7b",
}

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
