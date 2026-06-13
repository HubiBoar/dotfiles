local M = {}

M.pack_plenary = {
  src = "https://github.com/nvim-lua/plenary.nvim",
  version = "74b06c6c75e4eeb3108ec01852001636d85a932b",
}

M.pack_telescope = {
  src = "https://github.com/nvim-telescope/telescope.nvim",
  version = "7d324792b7943e4aa16ad007212e6acc6f9fe335",
}

M.find_files = function()
    local builtin = require("telescope.builtin")
    builtin.find_files ({
        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    })
end

M.live_grep = function()
    local builtin = require("telescope.builtin")
    builtin.live_grep({
        additional_args = { '--iglob', '!.git', '--hidden' },
    })
end

M.file_browser = function()
    local builtin = require("telescope.builtin")
    builtin.file_browser({
        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    })
end

M.buffers = function()
    local builtin = require("telescope.builtin")
    builtin.buffers()
end

M.registers = function()
    local builtin = require("telescope.builtin")
    builtin.registers()
end

M.resume = function()
    local builtin = require("telescope.builtin")
    builtin.resume()
end

M.setup = function()
    require("../keys").telescope(M)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function tab_info(tabnr)
        local win = vim.fn.tabpagewinnr(tabnr)
        local bufs = vim.fn.tabpagebuflist(tabnr)
        local buf = bufs[win]

        local name = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.bo[buf].buftype
        local filetype = vim.bo[buf].filetype

        if name == "" then
            return {
                kind = "empty",
                label = "[empty]",
                detail = "unnamed buffer",
            }
        end

        if buftype == "terminal" then
            local cwd, command = name:match("^term://(.-)//%d+:(.*)$")

            cwd = cwd and vim.fn.fnamemodify(cwd, ":~") or name
            command = command or "[terminal]"

            return {
                kind = "term",
                label = vim.fn.fnamemodify(cwd, ":t"),
                detail = cwd .. "  —  " .. command,
            }
        end

        if filetype == "oil" then
            local path = name:gsub("^oil://", "")
            path = vim.fn.fnamemodify(path, ":~")

            return {
                kind = "oil",
                label = vim.fn.fnamemodify(path:gsub("/$", ""), ":t"),
                detail = path,
            }
        end

        local path = vim.fn.fnamemodify(name, ":~")

        return {
            kind = "file",
            label = vim.fn.fnamemodify(path, ":t"),
            detail = path,
        }
    end

    local function telescope_tabs()
        local entries = {}

        for i = 1, vim.fn.tabpagenr("$") do
            local info = tab_info(i)

            table.insert(entries, {
                value = i,
                display = string.format(
                    "[%d] %-6s %-24s %s",
                    i,
                    "[" .. info.kind .. "]",
                    info.label,
                    info.detail
                ),
                ordinal = table.concat({
                    tostring(i),
                    info.kind,
                    info.label,
                    info.detail,
                }, " "),
            })
        end

        pickers.new({}, {
            prompt_title = "Tabs",
            finder = finders.new_table({
                results = entries,
                entry_maker = function(entry)
                    return entry
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)

                    vim.cmd("tabnext " .. selection.value)
                    vim.cmd("redrawstatus")
                end)

                return true
            end,
        }):find()
    end

    vim.keymap.set("n", "<leader>ft", telescope_tabs, {
        desc = "Show tabs in Telescope",
    })
end

return M
