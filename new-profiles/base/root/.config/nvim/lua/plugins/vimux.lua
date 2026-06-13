local M = {}

M.set_autocmd = function()
    local term_buffers = {}
    local current_term_index = 1

    vim.opt.laststatus = 3
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt.showmode = false

    local colors = {
        blue = "#7aa2f7", -- TokyoNight blue
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

    --vim.api.nvim_create_autocmd("VimEnter", {
    --  callback = function()
    --    local arg = vim.fn.argv(0)

    --    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
    --      vim.cmd("enew")
    --      vim.cmd("term")
    --      vim.cmd("startinsert")
    --    end
    --  end,
    --})

    local function vimux_statusline(active)
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
        local hl = active and "%#VimuxStatusActive#" or "%#VimuxStatusInactive#"

        return table.concat({
            hl,
            " VIMUX [" .. current_term_index .. "]",
            --" VIMUX: ",
            --cwd,
            --" ",
            --"%*",
            --"%=",
        })
    end

    local function term_manager_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        --vim.opt_local.number = true
        --vim.opt_local.relativenumber = true
        --vim.opt_local.numberwidth = 3
        --vim.opt_local.statuscolumn = ""

        --vim.opt_local.cursorline = true
        --vim.opt_local.winbar = ""
        vim.opt.statusline = vimux_statusline(true)

        vim.opt_local.winhighlight = table.concat({
            "LineNr:VimuxLineNr",
            "CursorLineNr:VimuxLineNr",
            "CursorLine:VimuxCursorLine",
            --"StatusLine:VimuxStatusActive",
        }, ",")
    end

    local function term_insert_mode()
        if vim.bo.buftype ~= "terminal" then
            return
        end

        -- vim.opt_local.number = true
        -- vim.opt_local.relativenumber = true
        -- vim.opt_local.numberwidth = 3
        -- vim.opt_local.statuscolumn = "%="

        -- vim.opt_local.cursorline = false
        -- vim.opt_local.winbar = ""
        vim.opt.statusline = vimux_statusline(false)

        --vim.opt_local.winhighlight = table.concat({
        --    "StatusLine:VimuxStatusInactive",
        --}, ",")
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
        -- First terminal: visible in the current full window
        vim.cmd("enew")
        vim.cmd("terminal")
        term_buffers[1] = vim.api.nvim_get_current_buf()

        -- Other terminals: hidden manager buffers
        for i = 2, 9 do
          vim.cmd("enew")
          vim.cmd("terminal")
          term_buffers[i] = vim.api.nvim_get_current_buf()
          term_manager_mode()
          vim.cmd("bprevious")
        end

        -- Show the first terminal after all are created
        vim.api.nvim_set_current_buf(term_buffers[1])
        current_term_index = 1
        term_manager_mode()
      end,
    })

    -- Open manager terminal by index: <leader>1 through <leader>9
    for i = 1, 9 do
      vim.keymap.set("n", "" .. i, function()
        local buf = term_buffers[i]

        vim.api.nvim_set_current_buf(buf)

        current_term_index = i

        term_manager_mode()

        end, {
        desc = "Go to manager terminal " .. i,
      })
    end

    -- Swap current manager terminal with manager slot using <C-1> through <C-9>
    for i = 1, 9 do
      vim.keymap.set("n", "<C-" .. i .. ">", function()
        if current_term_index == i then
          return
        end

        -- Swap only inside the original manager list
        term_buffers[current_term_index], term_buffers[i] =
          term_buffers[i], term_buffers[current_term_index]

        -- Keep the current "position" visible, now with the swapped terminal
        vim.api.nvim_set_current_buf(term_buffers[i])

        current_term_index = i

        term_manager_mode()
      end, {
        desc = "Swap current manager terminal with slot " .. i,
      })
    end
end;

return M;
