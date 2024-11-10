return
{
      "lmburns/lf.nvim",
      cmd = "Lf",
      dependencies = { "akinsho/toggleterm.nvim" },
      opts = {
        winblend = 0,
        highlights = { NormalFloat = { guibg = "NONE" } },
        border = "single",
        escape_quit = true,
      },
      keys = {
        { "<leader>lf", "<cmd>Lf<cr>", desc = "NeoTree" },
      },
}
