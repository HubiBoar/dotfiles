return
{
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
--      { fg = "#FFFFFF", bg = "#011E3B" }
--    )
--  end,

--  "revelot/kanagawa.nvim",
--  config = function()
--    vim.cmd.colorscheme("kanagawa-wave")
--  end,

  "folke/tokyonight.nvim",

  config = function()
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
