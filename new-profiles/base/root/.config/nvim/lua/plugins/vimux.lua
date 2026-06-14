local M = {}

M.set_autocmd = function()
    vim.opt.laststatus = 3
    vim.opt.showtabline = 0
    vim.opt.tabline = ""
    vim.opt.showmode = false
    vim.opt.winbar = ""

    vim.opt.number = false
    vim.opt.relativenumber = false

    local colors = {
        blue = "#7aa2f7",
        bg = "#1a1b26",
        bg_highlight = "#24283b",
        fg = "#c0caf5",
    }

    vim.api.nvim_set_hl(0, "VimuxStatusActive", {
        fg = colors.bg,
        bg = colors.blue,
        bold = true,
    })

    vim.api.nvim_set_hl(0, "VimuxStatusInactive", {
        fg = colors.fg,
        bg = colors.bg_highlight,
    })

    vim.api.nvim_set_hl(0, "VimuxLineNr", {
        fg = colors.blue,
        bold = true,
    })

    vim.api.nvim_set_hl(0, "VimuxCursorLine", {
        bg = colors.bg_highlight,
    })

    --local function vimux_statusline(active)
    --    local hl = active and "%#VimuxStatusActive#" or "%#VimuxStatusInactive#"
    --    local slot = vim.fn.tabpagenr()

    --    return hl .. " VIMUX [" .. slot .. "] "
    --end

    local function pretty_path(path, max_len)
        path = vim.fn.fnamemodify(path, ":~")

        if #path <= max_len then
            return path
        end

        -- Keep the beginning readable, e.g. ~/projects/...
        local parts = vim.split(path, "/", { plain = true })
        if #parts <= 2 then
            return path
        end

        return parts[1] .. "/" .. parts[2] .. "/..."
    end

    local function vimux_statusline(active)
        local hl = active and "%#VimuxStatusActive#" or "%#VimuxStatusInactive#"
        local slot = vim.fn.tabpagenr()

        local cwd = vim.fn.getcwd(-1, slot)
        local path = pretty_path(cwd, 32)

        return hl .. " VIMUX [" .. slot .. "] " .. path .. " "
    end

    local function term_manager_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        vim.opt.statusline = vimux_statusline(true)

        vim.opt_local.winhighlight = table.concat({
            "LineNr:VimuxLineNr",
            "CursorLineNr:VimuxLineNr",
            "CursorLine:VimuxCursorLine",
        }, ",")
    end

    local function term_insert_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        vim.opt.statusline = vimux_statusline(false)
    end

    local term_group = vim.api.nvim_create_augroup("vimux_terminal_manager", {
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

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.schedule(function()
                if vim.fn.tabpagenr("$") > 1 then
                    vim.cmd("tabonly")
                end

                -- First terminal tab
                vim.cmd("terminal")
                term_manager_mode()

                -- Other terminal tabs
                for _ = 2, 9 do
                    vim.cmd("tabnew")
                    vim.cmd("terminal")
                    term_manager_mode()
                end

                vim.cmd("tabnext 1")

                term_manager_mode()
                vim.cmd("redrawstatus")
            end)
        end,
    })

    -- Go to Vimux terminal slot with 1 through 9
    for i = 1, 9 do
        vim.keymap.set("n", "<F" .. i .. ">" , function()
            vim.cmd("tabnext " .. i)

            term_manager_mode()

            vim.cmd("redrawstatus")
        end, {
            desc = "Go to Vimux terminal " .. i,
        })

        vim.keymap.set({"t", "i"}, "<F" .. i .. ">", function()
            vim.cmd("tabnext " .. i)

            term_insert_mode()

            vim.cmd("redrawstatus")
        end, {
            desc = "Go to Vimux terminal " .. i,
        })
    end
end;

return M;
