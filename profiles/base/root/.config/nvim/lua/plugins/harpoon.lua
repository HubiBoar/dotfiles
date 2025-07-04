local path = vim.fn.stdpath("config") .. "/pack/plugins/start/harpoon"
local commit_sha = "ed1f853847ffd04b2b61c314865665e1dadf22c7" -- replace with your desired commit SHA

if not (vim.uv or vim.loop).fs_stat(path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/ThePrimeagen/harpoon.git",
    path,
  })
  vim.fn.system({ "git", "-C", path, "checkout", commit_sha })
end
vim.opt.rtp:prepend(path)

local harpoon = require("harpoon")
harpoon:setup()

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

require("../keys").harpoon(harpoon, toggle_telescope)

