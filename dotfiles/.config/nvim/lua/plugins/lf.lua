return
{
      "lmburns/lf.nvim",
      cmd = "Lf",
      dependencies = { "akinsho/toggleterm.nvim" },
      opts = {
        winblend = 0,
        direction = "float",
        highlights = { NormalFloat = { guibg = "NONE" } },
        border = "single",
        escape_quit = true,
        focus_on_open = true,
        default_action = "drop",
        default_actions = {
            ["<CR>"] = "drop",
            ["<l>"] = "drop",
        },
      },
      keys = {
        { "<leader>lf", "<cmd>Lf<cr>", desc = "NeoTree" },
      },
}
