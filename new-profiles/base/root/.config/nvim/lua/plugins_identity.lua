vim.pack.add({
    require("plugins.camelCaseMotion").pack,
    require("plugins.colorschema").pack,
    require("plugins.telescope").pack_plenary,
    require("plugins.telescope").pack_telescope,
    require("plugins.treesitter").pack_text_objects,
    require("plugins.treesitter").pack_treesitter,
    require("plugins.lsp").pack,
    require("plugins.lsp").pack,
    require("plugins.oil").pack_devicons,
    require("plugins.oil").pack_oil,
    require("plugins.lspoverloads").pack,
    require("plugins.99").pack,
})

require("plugins.camelCaseMotion").setup()
require("plugins.colorschema").setup()
require("plugins.completions").setup()
require("plugins.telescope").setup()
require("plugins.treesitter").setup()
require("plugins.lsp").setup()
require("plugins.lsp_config_identity").setup()
require("plugins.oil").setup()
require("plugins.99").setup()
require("plugins.simple_agent")

