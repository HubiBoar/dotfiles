require("plugins/lazy")

require("lazy").setup(
{
  require("plugins.colorschema"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
  require("plugins.completions"),
  require("plugins.dap"),
  require("plugins.harpoon"),
})

