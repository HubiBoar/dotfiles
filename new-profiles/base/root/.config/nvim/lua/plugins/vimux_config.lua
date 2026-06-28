local M = {}

M.setup = function()
    require("plugins.vimux").setup({
      layout = {
        {
          name = "iac",
          windows = {
            {
              name = "term",
              command = "tcd ~/projects/bsure/iac | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/iac | Oil",
            },
          },
        },
        {
          name = "app",
          windows = {
            {
              name = "term",
              commands =
              {
                "tabnew | tcd ~/projects/bsure/app | terminal",
                "vsplit | tcd ~/projects/bsure/app/src/Frontend | terminal",
                "wincmd =",
              },
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/app | Oil",
            },
            {
              name = "nvim-backend",
              command = "tabnew | tcd ~/projects/bsure/app/src/CustomerApp | Oil",
            },
            {
              name = "nvim-frontend",
              command = "tabnew | tcd ~/projects/bsure/app/src/Frontend | Oil",
            },
          },
        },
        {
          name = "data",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/projects/bsure/data | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/data | Oil",
            },
          },
        },

        {
          name = "control",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/projects/bsure/control | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/control | Oil",
            },
          },
        },

        {
          name = "shared",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/projects/bsure/shared | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/shared | Oil",
            },
            {
              name = "nvim-new",
              command = "tabnew | tcd ~/projects/bsure/shared/src/bsure.Shared | Oil",
            },
          },
        },

        {
          name = "updater",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/projects/bsure/updater | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/updater | Oil",
            },
          },
        },

        {
          name = "etl",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/projects/bsure/etl | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/projects/bsure/etl | Oil",
            },
          },
        },

        {
          name = "konfik",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/projects/hubert/konfik | terminal",
            },
            {
              name = "clanker",
              command = "tabnew | tcd ~/projects/hubert/konfik | Clanker",
            },
            {
              name = "nvim-cli",
              command = "tabnew | tcd ~/projects/hubert/konfik/src/cli | Oil",
            },
            {
              name = "nvim-cli-2",
              command = "tabnew | tcd ~/projects/hubert/konfik/src/cli | Oil",
            },
            {
              name = "nvim-cli-3",
              command = "tabnew | tcd ~/projects/hubert/konfik/src/cli | Oil",
            },
            {
              name = "nvim-server",
              command = "tabnew | tcd ~/projects/hubert/konfik/src/server | Oil",
            },
            {
              name = "nvim-server-2",
              command = "tabnew | tcd ~/projects/hubert/konfik/src/server | Oil",
            },
            {
              name = "nvim-server-3",
              command = "tabnew | tcd ~/projects/hubert/konfik/src/server | Oil",
            },
          },
        },

        {
          name = ".config",
          windows = {
            {
              name = "term",
              command = "tabnew | tcd ~/.config | terminal",
            },
            {
              name = "nvim",
              command = "tabnew | tcd ~/.config | Oil",
            },
          },
        },
      },
    })

  require("../keys").vimux()
end

return M
