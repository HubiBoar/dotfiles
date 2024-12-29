return
{
    {
        "mfussenegger/nvim-dap",
        dependencies =
        {
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui"
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
        dependencies =
        {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts =
        {
            ensure_installed = { "coreclr" },
            handlers =
            {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
                coreclr = function(config)
                    config.adapters =
                    {
                        type    = "executable",
                        command = vim.fn.stdpath "data" .. "/mason/packages/netcoredbg/netcoredbg",
                        args    = { "--interpreter=vscode" },
                        options =
                        {
                            detached = false,
                        },
                    }
                    config.configurations =
                    {
                        {
                            type    = "coreclr",
                            name    = "launch - netcoredbg",
                            request = "launch",
                            program = function()
                                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                            end,
                        },
                    }
                    require('mason-nvim-dap').default_setup(config) -- don't forget this!
                end,
            },
        }
    }
}
