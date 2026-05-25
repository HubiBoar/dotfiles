local M = {}

M.install = function (opts)
    return {
        {
            "mfussenegger/nvim-dap",
            commit = "7aade9e99bef5f0735cf966e715b3ce45515d786",
            dependencies =
            {
                {
                    "nvim-neotest/nvim-nio",
                    commit = "21f5324bfac14e22ba26553caf69ec76ae8a7662"
                },
                {
                    "rcarriga/nvim-dap-ui",
                    commit = "881a69e25bd6658864fab47450025490b74be878"
                }
            },
            config = function ()
                local dap   = require("dap")
                local dapui = require("dapui")

                dapui.setup()

                dap.listeners.before.attach.dapui_config = function()
                    dapui.open()
                end
                dap.listeners.before.launch.dapui_config = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated.dapui_config = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited.dapui_config = function()
                    dapui.close()
                end


                require("../keys").dap(dap)
            end,
        },
        {
            "jay-babu/mason-nvim-dap.nvim",
            commit = "4c2cdc69d69fe00c15ae8648f7e954d99e5de3ea",
            opts = opts
        }
    }
end

return M;
