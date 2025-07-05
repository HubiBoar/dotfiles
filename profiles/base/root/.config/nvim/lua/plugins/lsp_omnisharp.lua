local M = {}

M.setup = function()

    local lsp_path = vim.fn.stdpath("data") .. "/lsp_servers/omnisharp"
    local url = "https://github.com/omnisharp/omnisharp-roslyn/releases/download/v1.39.13/omnisharp-linux-x64-net6.0.zip"
    if not (vim.uv or vim.loop).fs_stat(lsp_path) then
      vim.fn.mkdir(lsp_path, "p")
      -- Download and extract
      local zip_path = lsp_path .. "/omnisharp-linux-x64-net6.0.zip"
      vim.fn.system({ "curl", "-L", url, "-o", zip_path })
      vim.fn.system({ "unzip", "-o", zip_path, "-d", lsp_path })
    end
    -- vim.fn.system({ "chmod", "+x", omnisharp_bin .. "/omnisharp/OmniSharp." })

    local overloads = require("plugins.lspoverloads")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.omnisharp.setup(
    {
        capabilities = capabilities,
        cmd = { "dotnet", vim.fn.stdpath "data" .. "/lsp_servers/omnisharp/OmniSharp.dll" },
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
