require("plugins/lazy")

require("lazy").setup(
{
    require("plugins.colorschema"),
    require("plugins.telescope"),
    require("plugins.treesitter"),
    require("plugins.lsp"),
    require("plugins.lsp_config"),
    require("plugins.oil"),
    require("plugins.completions"),
    require("plugins.harpoon"),
    require("plugins.sessions"),
    require("plugins.hardtime"),
    require("plugins.camelCaseMotion"),
    require("plugins.tmux"),
})
