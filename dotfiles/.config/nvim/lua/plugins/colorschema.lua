--return
--{
--    "cocopon/iceberg.vim",
--
--    config = function()
--        vim.cmd.colorscheme("iceberg")
--    end,
--}
--return
--{
--    "kvrohit/rasmus.nvim",
--    config = function()
--        vim.cmd.colorscheme("rasmus")
--    end,
--}
--return
--{
--  "askfiy/visual_studio_code",
--  config = function()
--
--    vim.cmd.colorscheme("visual_studio_code")
--
--    require("visual_studio_code").setup(
--    {
--      mode = "dark",
--      transparent,
--    })
--
--    require("visual_studio_code.utils").hl.set(
--      "Normal",
--      { fg = "#FFFFFF", bg = "#1A1B2C" }
--    )
--  end,
--}

--return
--{
--    "tyrannicaltoucan/vim-deep-space",
--    config = function()
--        vim.cmd.colorscheme("deep-space")
--    end,
--}
--return
--{
--  "revelot/kanagawa.nvim",
--  config = function()
--    vim.cmd.colorscheme("kanagawa-wave")
--  end,
--}

return
{
  "folke/tokyonight.nvim",

  config = function()
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
