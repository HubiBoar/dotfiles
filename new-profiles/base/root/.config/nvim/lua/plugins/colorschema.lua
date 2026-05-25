local M = {}

M.pack = {
  src = "https://github.com/folke/tokyonight.nvim",
  version = "057ef5d260c1931f1dffd0f052c685dcd14100a3",
}

M.setup = function()
    vim.cmd.colorscheme("tokyonight-night")
end

return M
