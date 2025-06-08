require("plugins.harpoon")
require("plugins.telescope")
require("plugins/lazy")

require("lazy").setup(
{
    require("plugins.colorschema"),
    require("plugins.treesitter"),
    require("plugins.dap"),
    require("plugins.lsp"),
    require("plugins.lsp_config"),
    require("plugins.oil"),
    require("plugins.completions"),
    require("plugins.sessions"),
    require("plugins.hardtime"),
    require("plugins.hop"),
    require("plugins.camelCaseMotion"),
    require("plugins.tmux"),
})

vim.opt.runtimepath:append("~/.config/nvim/pack/plugins/start/*")
