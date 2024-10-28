local M = {}

M.find_files = function()
    local builtin = require("telescope.builtin")
    builtin.find_files ({
        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    })
end

M.live_grep = function()
    local builtin = require("telescope.builtin")
    builtin.live_grep()
end

M.file_browser = function()
    local builtin = require("telescope.builtin")
    builtin.file_browser()
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

return
{
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.6",
        config = function()

            require("../keys").telescope(M)
        end,

        defaults = {
            vimgrep_arguments = {
                'rg',
                '--files',
                '--iglob',
                '!.git',
                '--hidden',
                '--line-number'
            }
        },

        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup(
            {
                extensions =
                {
                    ["ui-select"] =
                    {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
