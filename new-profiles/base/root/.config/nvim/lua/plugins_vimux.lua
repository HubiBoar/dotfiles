vim.pack.add({
    require("plugins.colorschema").pack,
    require("plugins.telescope").pack_plenary,
    require("plugins.telescope").pack_telescope,
    require("plugins.treesitter").pack_text_objects,
    require("plugins.treesitter").pack_treesitter,
})

require("plugins.colorschema").setup()
require("plugins.telescope").setup()
require("plugins.treesitter").setup()
