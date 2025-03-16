-- based on https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/oil.lua
return
{
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()

            CustomOilBar = function()
                local path = vim.fn.expand "%"
                path = path:gsub("oil://", "")

                return "  " .. vim.fn.fnamemodify(path, ":.")
            end

            local keys = require("../keys")

            require("oil").setup {
                columns = { "icon" },
                keymaps = keys.oil_keymaps,
                win_options = {
                    winbar = "%{v:lua.CustomOilBar()}",
                },
                default_file_explorer = false,
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
                        return vim.tbl_contains(folder_skip, name)
                    end,
                },
            }

            keys.oil()
            -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

            -- Open parent directory in floating window
            vim.keymap.set("n", "<space>-", require("oil").toggle_float)
        end,
    },
}
