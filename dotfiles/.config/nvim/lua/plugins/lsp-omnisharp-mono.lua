return
{
    {
        "neovim/nvim-lspconfig",
        config = function ()

            require("../keys").lsp()
            vim.diagnostic.config(
            {
                virtual_text = false
            })
        end,
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
                ensure_installed = { "lua_ls", "omnisharp", "omnisharp_mono" }
            })

            require("mason-lspconfig").setup_handlers(
            {
                ["omnisharp_mono"] = function ()

                end,

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

                    local pid = vim.fn.getpid();
                    local omnisharp_bin = vim.fn.stdpath "data" .. "/mason/packages/omnisharp/omnisharp-mono/run";

                    lspconfig.omnisharp.setup(
                    {
                        capabilities = capabilities,
                        cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };

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
