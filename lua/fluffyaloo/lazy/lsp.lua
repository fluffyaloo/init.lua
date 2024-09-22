-- TODO: Ruff integration
-- TODO: Debugging setup
-- TODO:Nvim dap: debugpy
-- TODO: Nvim dap UI
-- TODO: Refactoring setup

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",

    },

    config = function()

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_lsp.default_capabilities()
        --local capabilities = vim.tbl_deep_extend(
        --    "force",
        --    {},
        --    vim.lsp.protocol.make_client_capabilities(),
        --    cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup({
            ensure_installed = {
                "debugpy"
            },
        })
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "ruff",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({})
                end,
                ["pyright"] = function ()
                    local lspconfig = require("lspconfig")
                    -- Get the Python executable path from pyenv
                    -- TODO: maybe move this?
                    local function get_python_path(workspace)
                        -- Use activated virtualenv or fallback to pyenv
                        local venv_path = vim.env.VIRTUAL_ENV or vim.fn.trim(vim.fn.system('pyenv which python'))
                        return venv_path
                    end
                    lspconfig.pyright.setup({
                        -- on_attach = function(client, bufnr)
                        --     -- Additional setup such as keybindings can go here
                        -- end,
                        before_init = function(_, config)
                            config.settings.python.pythonPath = get_python_path(config.root_dir)
                        end,
                    })
                end,
                --["ruff"] = function ()
                --    local lspconfig = require("lspconfig")
                --     local function get_python_path(workspace)
                --        -- Use activated virtualenv or fallback to pyenv
                --        local venv_path = vim.env.VIRTUAL_ENV or vim.fn.trim(vim.fn.system('pyenv which python'))
                --        return venv_path
                --    end
                --    lspconfig.ruff.setup({
                --        before_init = function(_, config)
                --            config.settings.python.pythonPath = get_python_path(config.root_dir)
                --        end,
                --    })
                --end

            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })


        -- vim.api.nvim_create_autocmd("LspAttach", {
        --     group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        --     callback = function(args)
        --         local client = vim.lsp.get_client_by_id(args.data.client_id)
        --         if client == nil then
        --             return
        --         end
        --         if client.name == 'ruff' then
        --             -- Disable hover in favor of Pyright
        --             client.server_capabilities.hoverProvider = false
        --         end
        --     end,
        --     desc = 'LSP: Disable hover capability from Ruff',
        -- })
    end
}

