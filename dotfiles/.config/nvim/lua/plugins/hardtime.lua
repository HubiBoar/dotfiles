return
{
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("hardtime").setup(
        {
            disabled_keys =
            {
                ["<Up>"]    = {},
                ["<Down>"]  = {},
                ["<Left>"]  = {},
                ["<Right>"] = {},
            },

            restricted_keys =
            {
                ["<Up>"]    = { "", "i", "c", "t", "l" },
                ["<Down>"]  = { "", "i", "c", "t", "l" },
                ["<Left>"]  = { "", "i", "c", "t", "l" },
                ["<Right>"] = { "", "i", "c", "t", "l" },
            },
        })
    end,
}
