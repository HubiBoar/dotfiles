-- based on https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/oil.lua
local M = {}

M.pack_devicons = {
  src = "https://github.com/nvim-tree/nvim-web-devicons",
  version = "1fb58cca9aebbc4fd32b086cb413548ce132c127",
}

M.pack_oil = {
      src = "https://github.com/stevearc/oil.nvim",
      version = "08c2bce8b00fd780fb7999dbffdf7cd174e896fb",
}

M.setup = function()
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
end

return M
