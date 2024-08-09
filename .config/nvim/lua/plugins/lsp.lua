
return
{
    {
        "neovim/nvim-lspconfig",
        config = function ()
            require("../keys").lsp()
        end
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup(
            {
                automatic_installation = true,
                ensure_installed = { "lua_ls", "omnisharp" }
            })

            require("mason-lspconfig").setup_handlers(
            {

                function (server_name)
                    lspconfig[server_name].setup(
                    {
                        capabilities = capabilities
                    })
                end,

                ["lua_ls"] = function()

                    lspconfig.lua_ls.setup(
                    {
                        diagnostics = { disable = { 'missing-fields' } },
                        capabilities = capabilities,
                        settings =
                        {
                            Lua =
                            {
                                runtime =
                                {
                                    version = "LuaJIT",
                                },
                                diagnostics =
                                {
                                    globals = { "vim" },
                                },
                                workspace =
                                {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                telemetry =
                                {
                                    enable = false,
                                },
                            }
                        },
                    })
                end,

                ["omnisharp"] = function()

                    lspconfig.omnisharp.setup(
                    {
                        capabilities = capabilities,
                        cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },

                        settings =
                        {
                            FormattingOptions =
                            {
                                EnableEditorConfigSupport = true,
                                OrganizeImports           = false,
                            },
                            MsBuild =
                            {
                                LoadProjectsOnDemand = false,
                            },
                            RoslynExtensionsOptions =
                            {
                                EnableAnalyzersSupport   = false,
                                EnableImportCompletion   = false,
                                AnalyzeOpenDocumentsOnly = false,
                            },
                            Sdk =
                            {
                                IncludePrereleases = false,
                            },
                        },
                    })
                end,
            })
        end,
    }
}
