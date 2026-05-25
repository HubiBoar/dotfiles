return
{
    {
        "hrsh7th/cmp-nvim-lsp",
        commit = "a8912b88ce488f411177fc8aed358b04dc246d7b"
    },
    {
        "L3MON4D3/LuaSnip",
        commit = "5271933f7cea9f6b1c7de953379469010ed4553a",
        dependencies =
        {
            {
                "saadparwaiz1/cmp_luasnip",
                commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90",
            },
            {
                "rafamadriz/friendly-snippets",
                commit = "572f5660cf05f8cd8834e096d7b4c921ba18e175",
            }
        },
    },
    {
        "hrsh7th/nvim-cmp",
        commit = "b5311ab3ed9c846b585c0c15b7559be131ec4be9",
        config = function()

            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()
            local keys = require("../keys").completions(cmp)
            cmp.setup(
            {
                snippet =
                {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                completion =
                {
                    autocomplete = false
                },
                window =
                {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert(keys),
                sources = cmp.config.sources(
                {
                    { name = "nvim_lsp" },
                    { name = "luasnip" }
                },
                {
                    { name = "buffer" }
                }),
            })
        end,
    },
}
