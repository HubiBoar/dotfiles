-- based on https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/oil.lua
return
{
    {
        "stevearc/oil.nvim",
        commit = "08c2bce8b00fd780fb7999dbffdf7cd174e896fb",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                commit = "1fb58cca9aebbc4fd32b086cb413548ce132c127",
            }
        },
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
                default_file_explorer = true,
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
                        return vim.tbl_contains(folder_skip, name)
                    end,
                },
            }

            keys.oil()
        end,
    },
}
