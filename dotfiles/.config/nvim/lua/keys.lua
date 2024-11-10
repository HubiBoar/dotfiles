local M = {}

M.default = function ()
    local remap = { silent = true, remap = true}

    vim.g.mapleader = " "

    vim.keymap.set("n", "d", '"_d')
    vim.keymap.set("v", "d", '"_d')
    vim.keymap.set("n", "dd", '"_dd')
    vim.keymap.set("n", "D", '"_D')
    vim.keymap.set("", "<Del>", '"_x')
    vim.keymap.set("n", "p", 'P')
    vim.keymap.set("v", "p", '"_dP')

    vim.keymap.set("n", "<leader>RE", "<cmd>source /root/.config/nvim/init.lua<cr>")

    vim.keymap.set("n", "<leader>/", "<cmd>noh<cr>", remap)
    vim.keymap.set("n", "g.",        "g;",           remap)
    vim.keymap.set("n", "<M-v>",     "<c-v>",        remap)
    vim.keymap.set("n", "<M-v>",     "<c-v>",        remap)

    vim.keymap.set('', "<Up>",    "<nop>", remap)
    vim.keymap.set('', "<Down>",  "<nop>", remap)
    vim.keymap.set('', "<Left>",  "<nop>", remap)
    vim.keymap.set('', "<Right>", "<nop>", remap)

    vim.keymap.set('', "<S-Up>",    "<nop>", remap)
    vim.keymap.set('', "<S-Down>",  "<nop>", remap)
    vim.keymap.set('', "<S-Left>",  "<nop>", remap)
    vim.keymap.set('', "<S-Right>", "<nop>", remap)

    vim.keymap.set('', "<C-Up>",    "<nop>", remap)
    vim.keymap.set('', "<C-Down>",  "<nop>", remap)
    vim.keymap.set('', "<C-Left>",  "<nop>", remap)
    vim.keymap.set('', "<C-Right>", "<nop>", remap)

    vim.keymap.set('i', "<Up>",    "<nop>", remap)
    vim.keymap.set('i', "<Down>",  "<nop>", remap)
    vim.keymap.set('i', "<Left>",  "<nop>", remap)
    vim.keymap.set('i', "<Right>", "<nop>", remap)

    vim.keymap.set('i', "<S-Up>",    "<nop>", remap)
    vim.keymap.set('i', "<S-Down>",  "<nop>", remap)
    vim.keymap.set('i', "<S-Left>",  "<nop>", remap)
    vim.keymap.set('i', "<S-Right>", "<nop>", remap)

    vim.keymap.set('i', "<C-Up>",    "<nop>", remap)
    vim.keymap.set('i', "<C-Down>",  "<nop>", remap)
    vim.keymap.set('i', "<C-Left>",  "<nop>", remap)
    vim.keymap.set('i', "<C-Right>", "<nop>", remap)


    vim.keymap.set('', "<PageUp>",    "<nop>", remap)
    vim.keymap.set('', "<PageDown>",  "<nop>", remap)

    vim.keymap.set('', "<S-PageUp>",    "<nop>", remap)
    vim.keymap.set('', "<S-PageDown>",  "<nop>", remap)

    vim.keymap.set('', "<C-PageUp>",    "<nop>", remap)
    vim.keymap.set('', "<C-PageDown>",  "<nop>", remap)

    vim.keymap.set('', "<M-PageUp>",    "<nop>", remap)
    vim.keymap.set('', "<M-PageDown>",  "<nop>", remap)

    vim.keymap.set('i', "<PageUp>",    "<nop>", remap)
    vim.keymap.set('i', "<PageDown>",  "<nop>", remap)

    vim.keymap.set('i', "<S-PageUp>",    "<nop>", remap)
    vim.keymap.set('i', "<S-PageDown>",  "<nop>", remap)

    vim.keymap.set('i', "<C-PageUp>",    "<nop>", remap)
    vim.keymap.set('i', "<C-PageDown>",  "<nop>", remap)

    vim.keymap.set('i', "<M-PageUp>",    "<nop>", remap)
    vim.keymap.set('i', "<M-PageDown>",  "<nop>", remap)
end

M.tmux = function()
    local remap = { remap = true }
    vim.keymap.set('', '<C-h>', "<cmd>TmuxNavigateLeft<cr>", remap)
    vim.keymap.set('', '<C-l>', "<cmd>TmuxNavigateRight<cr>", remap)
    vim.keymap.set('', '<C-j>', "<cmd>TmuxNavigateDown<cr>", remap)
    vim.keymap.set('', '<C-k>', "<cmd>TmuxNavigateUp<cr>", remap)
end

M.hop = function()
    local remap = { remap = true }
    vim.keymap.set('', '<leader>j', "<cmd>HopLine<cr>", remap)
    vim.keymap.set('', '<leader>J', "<cmd>HopWord<cr>", remap)
end

M.lsp = function()
    vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,           {})
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,                   {})
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,             {})
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,              {})
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

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<leader>h6", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<leader>h7", function() harpoon:list():select(4) end)

    vim.keymap.set("n", "<leader>hk", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<leader>hj", function() harpoon:list():next() end)
end

M.telescope = function (builtin)
    vim.keymap.set("n", "<leader>ff", function() builtin.find_files() end)
    vim.keymap.set("n", "<leader>fb", function() builtin.buffers() end)
    vim.keymap.set("n", "<leader>fr", function() builtin.registers() end)
    vim.keymap.set("n", "<leader>fg", function() builtin.live_grep()  end)
    vim.keymap.set("n", "<leader>fd", function() builtin.resume()  end)
end

M.dap = function (dap)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<leader>dc", dap.continue, {})
end

M.overloads_keymaps = function ()
    return
    {
        next_signature = "j",
        previous_signature = "k",
        next_parameter = "l",
        previous_parameter = "h",
        close_signature = "<ESC>"
    }
end

M.overloads = function(bufnr)
    local remap = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", '<leader>s', "<cmd>LspOverloadsSignature<cr>", remap)
end

return M;
