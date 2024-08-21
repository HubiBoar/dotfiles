return
{
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("hardtime").setup(
        {
            restricted_keys =
            {
                ["<Up>"]    = { "", "i" },
                ["<Down>"]  = { "", "i" },
                ["<Left>"]  = { "", "i" },
                ["<Right>"] = { "", "i" },
            },
            disabled_keys =
            {
                ["<Up>"]    = {},
                ["<Down>"]  = {},
                ["<Left>"]  = {},
                ["<Right>"] = {},
            }
        })
    end,
}
