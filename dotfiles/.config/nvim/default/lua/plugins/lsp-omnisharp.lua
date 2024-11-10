local overloads = function (name, client, bufnr)
    print("LSP: " .. name);
    if client.server_capabilities.signatureHelpProvider then
        local keys = require("../keys");
        require("lsp-overloads").setup(client, {
            keymaps = keys.overloads_keymaps(),
            display_automatically = false
        })
        keys.overloads(bufnr)
    end
end

return
{
    {
        "Issafalcon/lsp-overloads.nvim",
    },
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
        dependencies = { "mason.nvim", "lsp-overloads.nvim" },
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
                        on_attach = function(client, bufnr)
                            overloads("Lua", client, bufnr);
                        end,
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
                        on_attach = function(client, bufnr)
                            overloads("Omnisharp", client, bufnr);
                        end,
                    })
                end,
            })
        end,
    }
}
