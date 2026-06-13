local M = {}

M.vimux = function ()
    vim.g.mapleader = " "

    local vimux = require("plugins.vimux");

    vimux.set_autocmd();

    -- Exit current Neovim terminal mode
    vim.keymap.set("t", "<M-c>", "<C-\\><C-n>")

    M.default();

end

M.normal = function ()
    vim.g.mapleader = " "
    vim.opt.number         = true
    vim.opt.relativenumber = true

    -- local terminal = require("plugins.float_terminal");

    -- vim.api.nvim_create_user_command("Floaterminal", terminal.toggle_terminal, {})

    -- vim.keymap.set({ "n", "t" }, "<M-t>", terminal.toggle_terminal)

    local function term_manager_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.opt_local.numberwidth = 4
        vim.opt_local.statuscolumn = ""

        -- vim.opt_local.cursorline = true
    end

    local function term_insert_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.opt_local.numberwidth = 4
        vim.opt_local.statuscolumn = "%= "

        -- vim.opt_local.cursorline = false
    end

    local term_group = vim.api.nvim_create_augroup("terminal_manager", {
        clear = true,
    })

    vim.api.nvim_create_autocmd("TermOpen", {
        group = term_group,
        pattern = "*",
        callback = function()
            vim.schedule(term_manager_mode)
        end,
    })

    vim.api.nvim_create_autocmd("TermEnter", {
        group = term_group,
        pattern = "*",
        callback = term_insert_mode,
    })

    vim.api.nvim_create_autocmd("TermLeave", {
        group = term_group,
        pattern = "*",
        callback = term_manager_mode,
    })

    M.default();

    local remap = { silent = true, remap = true}
    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], remap)
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], remap)
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], remap)
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], remap)

    --vim.keymap.set("n", "<M-t>", "<cmd>vert term<CR>", remap)
    --
    vim.keymap.set("t", "<M-i>", "<C-\\><C-n>")




    local terminals_by_dir = {}
    local previous_by_terminal = {}

    local function normalize_dir(dir)
        return vim.fn.fnamemodify(dir, ":p"):gsub("/$", "")
    end

    local function current_dir()
        if vim.bo.filetype == "oil" then
            local ok, oil = pcall(require, "oil")

            if ok then
                local dir = oil.get_current_dir()
                if dir then
                    return dir
                end
            end

            return vim.api.nvim_buf_get_name(0):gsub("^oil://", "")
        end

        local file = vim.api.nvim_buf_get_name(0)

        if file ~= "" then
            return vim.fn.fnamemodify(file, ":p:h")
        end

        return vim.fn.getcwd()
    end

    local function open_or_reuse_terminal()
        local current_buf = vim.api.nvim_get_current_buf()

        -- If already inside a managed terminal, go back to previous buffer
        if vim.b[current_buf].vimux_managed_terminal then
            local previous = previous_by_terminal[current_buf]

            if previous and vim.api.nvim_buf_is_valid(previous) then
                vim.api.nvim_win_set_buf(0, previous)
                return
            end

            vim.cmd("bprevious")
            return
        end

        local dir = normalize_dir(current_dir())
        local existing = terminals_by_dir[dir]

        if existing and vim.api.nvim_buf_is_valid(existing) then
            previous_by_terminal[existing] = current_buf
            vim.api.nvim_win_set_buf(0, existing)
            vim.cmd("startinsert")
            return
        end

        vim.cmd("enew")
        vim.cmd("lcd " .. vim.fn.fnameescape(dir))
        vim.cmd("terminal")
        vim.cmd("startinsert")

        local term_buf = vim.api.nvim_get_current_buf()

        terminals_by_dir[dir] = term_buf
        previous_by_terminal[term_buf] = current_buf

        vim.b[term_buf].vimux_managed_terminal = true
        vim.b[term_buf].vimux_terminal_dir = dir
    end

    vim.keymap.set("n", "<M-i>", open_or_reuse_terminal, {
        desc = "Open/reuse terminal or return to previous buffer",
    })




    local current_slot = 1

    local function statusline()
        local prefix = "[" .. tostring(current_slot) .. "] "
        local buftype = vim.bo.buftype
        local name = vim.api.nvim_buf_get_name(0)

        if name == "" then
            return prefix .. "[empty]"
        end

        if buftype == "terminal" then
            local cwd = name:match("^term://(.-)//%d+:")
            cwd = cwd and vim.fn.fnamemodify(cwd, ":~")

            return prefix .. "[term] " .. (cwd or name)
        end

        if vim.bo.filetype == "oil" then
            local path = vim.fn.expand("%")
            path = path:gsub("^oil://", "")
            path = vim.fn.fnamemodify(path, ":~")

            if not path:match("/$") then
                path = path .. "/"
            end

            return prefix .. "[oil] " .. path
        end

        return prefix .. vim.fn.expand("%:p:~")
    end

    _G.my_statusline = statusline
    vim.opt.statusline = "%!v:lua.my_statusline()"

    local function go_to_slot(i)
        vim.cmd("tabnext " .. i)
        current_slot = i
        vim.cmd("redrawstatus")
    end

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.schedule(function()
                -- Make sure we start from one tab

                if vim.fn.tabpagenr("$") > 1 then
                    vim.cmd("tabonly")
                end

                local cwd = vim.fn.getcwd()
                vim.cmd.edit(vim.fn.fnameescape(cwd))
                -- Create tabs 2-9
                for _ = 2, 9 do
                    vim.cmd("tabnew")
                    vim.cmd.edit(vim.fn.fnameescape(cwd))
                end

                -- Go back to tab 1
                go_to_slot(1)
            end)
        end,
    })

    for i = 1, 9 do
        vim.keymap.set("n", "" .. i, function()
            go_to_slot(i)
        end, {
            desc = "Go to slot " .. i,
        })
    end


    -- TAB
    local function tab_name(tabnr)
        local win = vim.fn.tabpagewinnr(tabnr)
        local bufs = vim.fn.tabpagebuflist(tabnr)
        local buf = bufs[win]

        local name = vim.api.nvim_buf_get_name(buf)

        if name == "" then
            return "[empty]"
        end

        name = name:gsub("^oil://", "")

        if vim.bo[buf].buftype == "terminal" then
            local cwd = name:match("^term://(.-)//%d+:")
            name = cwd or name
        end

        name = name:gsub("/$", "")

        local tail = vim.fn.fnamemodify(name, ":t")

        if tail == "" then
            return "[empty]"
        end

        return tail
    end

    function _G.my_tabline()
        local current = vim.fn.tabpagenr()
        local total = vim.fn.tabpagenr("$")
        local parts = {}

        for i = 1, total do
            local label = tab_name(i)
            local prefix = "[" .. tostring(i) .. "] "

            if i == current then
                table.insert(parts, "%#TabLineSel# " .. prefix .. label .. " ")
            else
                table.insert(parts, "%#TabLine# " .. prefix .. label .. " ")
            end
        end

        table.insert(parts, "%#TabLineFill#%=")

        return table.concat(parts, "")
    end

    --vim.opt.showtabline = 2
    --vim.opt.tabline = "%!v:lua.my_tabline()"
    vim.opt.showtabline = 0
end

M.default = function ()
    local remap = { silent = true, remap = true}


    -- Exit current Neovim terminal mode
    -- vim.keymap.set("t", "<M-c>", "<C-\\><C-n>")

    -- Send escape sequence to nested Neovim
    -- vim.keymap.set("t", "<M-S-c>", "<C-\\><C-\\><C-n>")

    -- local terminal = require("plugins.float_terminal");

    -- vim.api.nvim_create_user_command("Floaterminal", terminal.toggle_terminal, {})
    -- vim.keymap.set({ "n" }, "<leader>tt", terminal.toggle_terminal)

    vim.opt.ttimeoutlen = 10

    vim.keymap.set("n", "d", '"_d')
    vim.keymap.set("v", "d", '"_d')
    vim.keymap.set("n", "dd", '"_dd')
    vim.keymap.set("n", "D", '"_D')
    vim.keymap.set("", "<Del>", '"_x')
    vim.keymap.set("n", "p", 'P')
    vim.keymap.set("v", "p", 'P')
    vim.keymap.set("n", "c", '"_c')
    vim.keymap.set("v", "c", '"_c')

    vim.keymap.set("n", "<leader>re", function()
        vim.cmd("source ~/.config/nvim/init.lua")
        print("Neovim config reloaded!")
    end, { desc = "Reload Neovim config" })

    vim.keymap.set("n", "<leader>/", "<cmd>noh<cr>", remap)
    vim.keymap.set("n", "g.",        "g;",           remap)
    vim.keymap.set("n", "<M-v>",     "<c-v>",        remap)
    vim.keymap.set("n", "<M-v>",     "<c-v>",        remap)

    --vim.keymap.set('', "<Up>",    "<nop>", remap)
    --vim.keymap.set('', "<Down>",  "<nop>", remap)
    --vim.keymap.set('', "<Left>",  "<nop>", remap)
    --vim.keymap.set('', "<Right>", "<nop>", remap)

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

    vim.keymap.set('', '<C-h>', '<C-w>h', remap)
    vim.keymap.set('', '<C-l>', '<C-w>l', remap)
    vim.keymap.set('', '<C-j>', '<C-w>j', remap)
    vim.keymap.set('', '<C-k>', '<C-w>k', remap)

    -- vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], remap)
    -- vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], remap)
    -- vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], remap)
    -- vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], remap)

    vim.keymap.set('n', '<C-h>', '<C-w>h', remap)
    vim.keymap.set('n', '<C-j>', '<C-w>j', remap)
    vim.keymap.set('n', '<C-k>', '<C-w>k', remap)
    vim.keymap.set('n', '<C-l>', '<C-w>l', remap)
end

M.lsp = function()
    vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,           {})
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,                   {})
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,             {})
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,              {})
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,          {})
    vim.keymap.set({"n", "i", "s"}, "<C-k>",      vim.lsp.buf.signature_help,          {})
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,    {})
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {})
    vim.keymap.set("n", "<leader>D",  vim.lsp.buf.type_definition,         {})
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,                  {})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,             {})
    vim.keymap.set("n", "gr",         vim.lsp.buf.references,              {})
    vim.keymap.set('n', 'gn', function()
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, {})
    vim.keymap.set('n', 'gN',         vim.diagnostic.goto_next,            {})
    vim.keymap.set('n', 'gp', function()
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, {})
    vim.keymap.set('n', 'gp',         vim.diagnostic.goto_prev,            {})
end

M.camelCaseMotion = function ()
    local remap = { silent = true, remap = true }
    vim.keymap.set('', 'w', "<Plug>CamelCaseMotion_w",   remap)
    vim.keymap.set('', 'b', "<Plug>CamelCaseMotion_b",   remap)
    vim.keymap.set('', 'e', "<Plug>CamelCaseMotion_e",   remap)
    vim.keymap.set('', 'ge', "<Plug>CamelCaseMotion_ge", remap)
end

M.completions = function()
  return {
    ["<C-s>"] = function()
      vim.lsp.completion.get()
    end,

    ["<CR>"] = function()
      if vim.fn.pumvisible() == 1 then
        return "<C-y>"
      end
      return "<CR>"
    end,
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


M.telescope = function (builtin)
    vim.keymap.set("n", "<leader>ff", function() builtin.find_files() end)
    vim.keymap.set("n", "<leader>fb", function() builtin.buffers() end)
    vim.keymap.set("n", "<leader>fr", function() builtin.registers() end)
    vim.keymap.set("n", "<leader>fg", function() builtin.live_grep()  end)
    vim.keymap.set("n", "<leader>fd", function() builtin.resume()  end)
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
    local remap = { noremap = false, silent = true, buffer = bufnr }
    vim.keymap.set("n", '<leader>s', "<cmd>LspOverloadsSignature<cr>", remap)
end

M.oil = function()
    local remap = { noremap = false, silent = true, }
    vim.keymap.set("n", "<leader>fe", "<CMD>Oil<CR>", remap)
end

M.oil_keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-k>"] = false,
    ["<C-j>"] = false,
    ["<M-h>"] = "actions.select_split",
}

return M;
