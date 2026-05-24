local M = {}

local state = {}

M.open_terminal_window = function()
    vim.cmd('tabnew')

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_win_set_buf(0, buf)

    vim.cmd.terminal()

    -- vim.cmd('startinsert')
end

M.create_new_tab = function(index)
    return function()
        local position = index - 1
        vim.cmd(position .. 'tabnew')

        vim.cmd.terminal()

        vim.cmd('redrawtabline')
    end
    --return function()
    --    vim.ui.input({ prompt = 'Tab Name: ' }, function(input)
    --        if not input or input == "" then return end

    --        local position = index - 1
    --        vim.cmd(position .. 'tabnew')

    --        local current_tab = vim.api.nvim_get_current_tabpage()

    --        vim.api.nvim_tabpage_set_var(current_tab, 'tab_name', input)

    --        vim.cmd.terminal()

    --        vim.cmd('redrawtabline')
    --    end)
    --end
end

return M;

