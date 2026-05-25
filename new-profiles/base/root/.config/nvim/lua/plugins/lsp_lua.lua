local M = {}

M.setup = function()
    local overloads = require("plugins.lspoverloads")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    local logpath = vim.fn.stdpath("state") .. "/lua-language-server"
    vim.fn.mkdir(logpath, "p")

    lspconfig.lua_ls.setup({
        cmd = {
            "lua-language-server",
            "--logpath=" .. logpath,
        },

        diagnostics = { disable = { "missing-fields" } },
        capabilities = capabilities,

        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                    disable = { "missing-fields" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },

        on_attach = function(client, bufnr)
            overloads.setup("lua", client, bufnr)
        end,
    })
end

return M
