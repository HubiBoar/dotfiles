local M = {}

M.set_autocmd = function()
    vim.opt.laststatus = 3

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

      -- Show line numbers in VIMUX manager mode
      vim.opt_local.number = true
      vim.opt_local.relativenumber = true
      vim.opt_local.numberwidth = 4
      vim.opt_local.statuscolumn = ""

      -- Visual manager-mode indicator
      vim.opt_local.cursorline = true
      vim.opt_local.winbar = ""
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

      -- Keep gutter width stable, but hide numbers
      vim.opt_local.number = true
      vim.opt_local.relativenumber = true
      vim.opt_local.numberwidth = 4
      vim.opt_local.statuscolumn = "%= "

      -- Default-looking terminal insert mode
      vim.opt_local.cursorline = false
      vim.opt_local.winbar = ""
      vim.opt_local.statusline = vimux_statusline(false)

      vim.opt_local.winhighlight = table.concat({
        "StatusLine:VimuxStatusInactive",
      }, ",")
    end

    local term_numbers = vim.api.nvim_create_augroup("vimux_terminal_manager", {
      clear = true,
    })

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
