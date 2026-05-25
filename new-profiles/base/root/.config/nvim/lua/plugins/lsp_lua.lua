local M = {}

M.setup = function()
    local overloads = require("plugins.lspoverloads")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local logpath = vim.fn.stdpath("state") .. "/lua-language-server"
    vim.fn.mkdir(logpath, "p")

    vim.lsp.config("lua_ls", {
        cmd = {
            "lua-language-server",
            "--logpath=" .. logpath,
        },

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

    vim.lsp.enable("lua_ls")
end

return M
