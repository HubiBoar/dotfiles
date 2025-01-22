return
{
    "rmagatti/auto-session",
    opts = {
        auto_save = true,
    },
    config = function()
        require("auto-session").setup({})
    end
}
