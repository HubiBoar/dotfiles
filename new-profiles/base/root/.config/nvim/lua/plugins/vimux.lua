local M = {}

M.set_autocmd = function()
    local term_numbers = vim.api.nvim_create_augroup("terminal_numbers", {
        clear = true,
    })

    vim.api.nvim_set_hl(0, "TerminalManagerWinbar", {
        fg = "#1e1e2e",
        bg = "#f9e2af",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "TerminalManagerLineNr", {
        fg = "#f9e2af",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "TerminalManagerCursorLine", {
        bg = "#313244",
    })

    local function term_manager_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        -- Show line numbers in manager normal-mode
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.opt_local.numberwidth = 4

        -- Use default number rendering
        vim.opt_local.statuscolumn = ""

        -- Strong visual indicator
        vim.opt_local.cursorline = true
        vim.opt_local.winbar = "%#TerminalManagerWinbar#  GLOBAL MANAGER MODE  %*"

        vim.opt_local.winhighlight = table.concat({
            "LineNr:TerminalManagerLineNr",
            "CursorLineNr:TerminalManagerLineNr",
            "CursorLine:TerminalManagerCursorLine",
            "WinBar:TerminalManagerWinbar",
        }, ",")
    end

    local function term_insert_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        -- Keep gutter padding stable, but hide numbers
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.opt_local.numberwidth = 4
        vim.opt_local.statuscolumn = "%= "

        -- Remove manager-mode indicators
        vim.opt_local.cursorline = false
        vim.opt_local.winbar = ""
        vim.opt_local.winhighlight = ""
    end

    vim.api.nvim_create_autocmd("TermOpen", {
        group = term_numbers,
        pattern = "*",
        callback = function()
            vim.schedule(term_manager_mode)
        end,
    })

    vim.api.nvim_create_autocmd("TermEnter", {
        group = term_numbers,
        pattern = "*",
        callback = term_insert_mode,
    })

    vim.api.nvim_create_autocmd("TermLeave", {
        group = term_numbers,
        pattern = "*",
        callback = term_manager_mode,
    })

end;

return M;
