local M = {}

M.install = function (config)
    return {
        {
            "williamboman/mason.nvim",
            commit = "fc98833b6da5de5a9c5b1446ac541577059555be",
            config = function()
                require("mason").setup({})
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            commit = "1a31f824b9cd5bc6f342fc29e9a53b60d74af245",
            config = config,
        }
    }
end

return M;
