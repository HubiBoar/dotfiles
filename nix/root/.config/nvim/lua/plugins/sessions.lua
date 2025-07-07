return
{
    "rmagatti/auto-session",
    commit = "00334ee24b9a05001ad50221c8daffbeedaa0842",
    opts = {
        auto_save = true,
    },
    config = function()
        require("auto-session").setup({})
    end
}
