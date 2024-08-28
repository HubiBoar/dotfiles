local M = {}

M.default = function ()
    local remap = { silent = true, remap = true}

    vim.g.mapleader = " "

    vim.keymap.set("n", "<leader>/", "<cmd>noh<cr>", remap)
    vim.keymap.set("n", "g.",        "g;",           remap)
    vim.keymap.set("n", "<M-v>",     "<c-v>",        remap)
    vim.keymap.set("n", "<M-v>",     "<c-v>",        remap)
end

M.hop = function()
    local remap = { remap = true }
    vim.keymap.set('', '<leader>h', "<cmd>HopLine<cr>", remap)
    vim.keymap.set('', '<leader>H', "<cmd>HopWord<cr>", remap)
end

M.lsp = function()
    vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,           {})
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,                   {})
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,             {})
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,              {})
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,                   {})
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,          {})
    vim.keymap.set("n", "<C-k>",      vim.lsp.buf.signature_help,          {})
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,    {})
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {})
    vim.keymap.set("n", "<leader>D",  vim.lsp.buf.type_definition,         {})
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,                  {})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,             {})
    vim.keymap.set("n", "gr",         vim.lsp.buf.references,              {})
end

M.camelCaseMotion = function ()
    local remap = { silent = true, remap = true }
    vim.keymap.set('', 'w', "<Plug>CamelCaseMotion_w",   remap)
    vim.keymap.set('', 'b', "<Plug>CamelCaseMotion_b",   remap)
    vim.keymap.set('', 'e', "<Plug>CamelCaseMotion_e",   remap)
    vim.keymap.set('', 'ge', "<Plug>CamelCaseMotion_ge", remap)
end

M.completions = function (cmp)

    return
    {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-s>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"]  = cmp.mapping.confirm({ select = true }),
    }
end

M.treesitter_keymaps = function ()

    return
    {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] =
        {
            query = "@class.inner",
            desc  = "Select inner part of class region"
        },
        ["as"] =
        {
            query       = "@scope",
            query_group = "locals",
            desc        = "Select language scope"
        },
    }
end

M.treesitter_selection_modes = function ()

    return
    {
        ['@parameter.outer'] = 'v',
        ['@function.outer']  = 'V',
        ['@class.outer']     = '<c-v>',
    }
end

M.harpoon = function (harpoon)

    vim.keymap.set("n", "<M-Up>",    function() harpoon:list():add() end)
    vim.keymap.set("n", "<M-Down>",  function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-1>",     function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-2>",     function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-3>",     function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-4>",     function() harpoon:list():select(4) end)

    vim.keymap.set("n", "<M-Left>",  function() harpoon:list():prev() end)
    vim.keymap.set("n", "<M-Right>", function() harpoon:list():next() end)
end

M.telescope = function (builtin)
    vim.keymap.set("n", "<leader>ff", function() builtin.find_files() end)
    vim.keymap.set("n", "<leader>fg", function() builtin.live_grep()  end)
    vim.keymap.set("n", "<leader>fr", function() builtin.resume()  end)
end

M.dap = function (dap)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<leader>dc", dap.continue, {})
end

return M;
