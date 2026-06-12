local M = {}

M.set_autocmd = function()
    vim.opt.laststatus = 3
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

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

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local arg = vim.fn.argv(0)

        if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
          vim.cmd("enew")
          vim.cmd("term")
          vim.cmd("startinsert")
        end
      end,
    })

    local function vimux_statusline(active)
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
        local hl = active and "%#VimuxStatusActive#" or "%#VimuxStatusInactive#"

        return table.concat({
            hl,
            " VIMUX: ",
            cwd,
            " ",
            "%*",
            "%=",
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
        vim.opt_local.statusline = vimux_statusline(true)

        vim.opt_local.winhighlight = table.concat({
            "LineNr:VimuxLineNr",
            "CursorLineNr:VimuxLineNr",
            "CursorLine:VimuxCursorLine",
            "StatusLine:VimuxStatusActive",
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
        vim.opt_local.statusline = vimux_statusline(false)

        vim.opt_local.winhighlight = table.concat({
            "StatusLine:VimuxStatusInactive",
        }, ",")
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

    local terms = {}

    local function open_term(index)
      -- Reuse existing terminal buffer if it still exists
      if terms[index] and vim.api.nvim_buf_is_valid(terms[index]) then
        vim.cmd("buffer " .. terms[index])
        vim.cmd("startinsert")
        return
      end

      -- Replace current window with a new terminal buffer
      vim.cmd("enew")
      vim.cmd("terminal")
      vim.cmd("file term://" .. index)

      terms[index] = vim.api.nvim_get_current_buf()

      vim.cmd("startinsert")
    end

    local function switch_term(index)
      local bufnr = terms[index]

      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        vim.cmd("buffer " .. bufnr)
      else
        vim.notify("No terminal " .. index, vim.log.levels.WARN)
      end
    end

    for i = 1, 9 do
      -- Ctrl+1..9 creates/reopens terminal slot i
      vim.keymap.set("n", "<C-" .. i .. ">", function()
        open_term(i)
        vim.notify("New terminal " .. i, vim.log.levels.WARN)
      end, {
        desc = "Open terminal " .. i,
      })

      -- 1..9 switches to terminal slot i in normal mode
      vim.keymap.set("n", tostring(i), function()
        switch_term(i)
        vim.notify("Open terminal " .. i, vim.log.levels.WARN)
      end, {
        desc = "Switch to terminal " .. i,
      })
    end
end;

return M;
