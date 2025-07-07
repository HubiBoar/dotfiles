return
{
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        commit = "0f051e9813a36481f48ca1f833897210dbcfffde"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        commit = "42fc28ba918343ebfd5565147a42a26580579482",
        config = function()

            require("nvim-treesitter.configs").setup(
            {
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "c_sharp", "go", "kotlin" },
                auto_install = true,

                highlight =
                {
                    enable  = true,
                },

                textobjects =
                {
                    select =
                    {
                        enable          = true,
                        lookagead       = true,
                        keymaps         = require("../keys").treesitter_keymaps(),
                        selection_modes = require("../keys").treesitter_selection_modes(),

                        include_surrounding_whitespace = true,
                    }
                }
            })
        end,
    },
}
