require("plugins/lazy")

require("lazy").setup(
{
    require("plugins.colorschema"),
    require("plugins.telescope"),
    require("plugins.treesitter"),
    require("plugins.lsp-go"),
    require("plugins.completions"),
    require("plugins.dap"),
    require("plugins.harpoon"),
    require("plugins.sessions"),
    require("plugins.hardtime"),
    require("plugins.hop"),
    require("plugins.camelCaseMotion"),
    require("plugins.tmux"),
})
