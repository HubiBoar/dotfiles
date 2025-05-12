local M = {}

M.name = "omnisharp"

M.setup = function()

    local overloads = require("plugins.lspoverloads")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.omnisharp.setup(
    {
        capabilities = capabilities,
        cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/OmniSharp.dll" },
        --lspconfig.util.root_pattern(".gitignore", "*.sln", "*.csproj"),
        root_dir = vim.loop.cwd, 
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
            overloads.setup("omnisharp", client, bufnr);
        end,
    })
end;

M.dapname = "coreclr";

M.dap = function(config)

    config.adapters =
    {
        type    = "executable",
        command = vim.fn.stdpath "data" .. "/mason/packages/netcoredbg/netcoredbg",
        args    = { "--interpreter=vscode" },
        options =
        {
            detached = false,
        },
    }
    config.configurations =
    {
        {
            type    = "coreclr",
            name    = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
        },
    }
    require('mason-nvim-dap').default_setup(config) -- don't forget this!
end;

return M
