local M = {}

M.setup = function()
    vim.filetype.add({
        extension = {
            ts = "typescript",
            tsx = "typescriptreact",
            js = "javascript",
            jsx = "javascriptreact",
        },
    })

    vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },

        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },

        root_markers = {
            "package.json",
            "tsconfig.json",
            "jsconfig.json",
            ".git",
        },

        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    })

    vim.lsp.enable("ts_ls")
end

return M
