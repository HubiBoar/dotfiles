local M = {}

M.pack_text_objects = {
  src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  version = "851e865342e5a4cb1ae23d31caf6e991e1c99f1e",
}

M.pack_treesitter = {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  version = "4916d6592ede8c07973490d9322f187e07dfefac",
}

M.setup = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
    })

    treesitter.install({
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "c_sharp",
        "go",
        "kotlin",
        "bicep",
        "javascript",
        "typescript"
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "cs",
            "go",
            "kotlin",
            "bicep",
            "javascript",
            "typescript"
        },
        callback = function()
            vim.treesitter.start()
        end,
    })

    require("nvim-treesitter-textobjects").setup({
        select = {
            enable = true,
            lookahead = true,
            selection_modes = require("../keys").treesitter_selection_modes(),
            include_surrounding_whitespace = true,
        },
    })

    local select = require("nvim-treesitter-textobjects.select")

    for key, capture in pairs(require("../keys").treesitter_keymaps()) do
        vim.keymap.set({ "x", "o" }, key, function()
            select.select_textobject(capture, "textobjects")
        end)
    end
end

return M
