local M = {}

M.pack_plenary = {
  src = "https://github.com/nvim-lua/plenary.nvim",
  version = "74b06c6c75e4eeb3108ec01852001636d85a932b",
}

M.pack_telescope = {
  src = "https://github.com/nvim-telescope/telescope.nvim",
  version = "7d324792b7943e4aa16ad007212e6acc6f9fe335",
}

M.find_files = function()
    local builtin = require("telescope.builtin")
    builtin.find_files ({
        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    })
end

M.live_grep = function()
    local builtin = require("telescope.builtin")
    builtin.live_grep({
        additional_args = { '--iglob', '!.git', '--hidden' },
    })
end

M.file_browser = function()
    local builtin = require("telescope.builtin")
    builtin.file_browser({
        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    })
end

M.buffers = function()
    local builtin = require("telescope.builtin")
    builtin.buffers()
end

M.registers = function()
    local builtin = require("telescope.builtin")
    builtin.registers()
end

M.resume = function()
    local builtin = require("telescope.builtin")
    builtin.resume()
end

M.setup = function()
    require("../keys").telescope(M)
end

return M
