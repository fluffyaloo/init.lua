return {

    { 
        "rcarriga/nvim-dap-ui", 
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        config = function ()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    "mfussenegger/nvim-dap",
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config  = function (_,opts)

            -- Get the Python executable path from pyenv
            -- TODO: maybe move this?
            -- local function get_python_path(workspace)
            --     -- Use activated virtualenv or fallback to pyenv
            --     local venv_path = vim.env.VIRTUAL_ENV or vim.fn.trim(vim.fn.system('pyenv which python'))
            --     return venv_path
            -- end
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            local dappython = require("dap-python")
            dappython.setup(path)
            --nvimdappython.setup({
            --    -- on_attach = function(client, bufnr)
            --    --     -- Additional setup such as keybindings can go here
            --    -- end,
            --    before_init = function(_, config)
            --        config.settings.python.pythonPath = 
            --    end,
            --})

        end
    }

}
