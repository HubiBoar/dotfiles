local M = {}

local terminals = {}

local function create_floating_window(cwd)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a terminal buffer
    local buf = terminals[cwd] and terminals[cwd].buf
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        print("NEW " .. cwd);
        buf = vim.api.nvim_create_buf(false, true)
    else
        print("REUSE " .. cwd);
    end

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = "rounded",
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)
    terminals[cwd] = { buf = buf, win = win }
    return terminals[cwd]
end

M.toggle_terminal = function()
    local bufnr = vim.api.nvim_get_current_buf()

    if vim.bo[bufnr].buftype == "terminal" then
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_hide(win)
        return;
    end

    local cwd = vim.fn.expand("%:p:h")
    if not cwd or cwd == "" then
        return
    end

    if not terminals[cwd] or not vim.api.nvim_win_is_valid(terminals[cwd].win) then

        terminals[cwd] = create_floating_window(cwd)
        vim.api.nvim_set_current_win(terminals[cwd].win)

        if vim.bo[terminals[cwd].buf].buftype ~= "terminal" then
            vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(terminals[cwd].win)
    end
end

return M;
