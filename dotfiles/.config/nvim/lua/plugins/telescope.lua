return
{
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.6",
        config = function()

            local builtin = require("telescope.builtin")
            require("../keys").telescope(builtin)
        end,
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
