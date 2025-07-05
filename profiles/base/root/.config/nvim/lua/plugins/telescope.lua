local M = {}

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

return
{
    {
        "nvim-lua/plenary.nvim",
        commit = "857c5ac632080dba10aae49dba902ce3abf91b35",
    },
    {
        "nvim-telescope/telescope.nvim",
        commit = "6312868392331c9c0f22725041f1ec2bef57c751",
        config = function()

            require("../keys").telescope(M)
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        commit = "6e51d7da30bd139a6950adf2a47fda6df9fa06d2",
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
    }
}
