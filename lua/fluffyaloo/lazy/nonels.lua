return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "stevearc/conform.nvim"
    },
    config = function ()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
            },
        })

        local map = vim.keymap.set
        map("n", "<leader>fm", function()
            require("conform").format { lsp_fallback = true }
        end, { desc = "General Format file" })

        -- Auto-format on buffer/window close
        local augroup = vim.api.nvim_create_augroup("BlackAutoFormat", { clear = true })

        vim.api.nvim_create_autocmd({ "BufWritePre", "BufWinLeave", "BufUnload" }, {
            group = augroup,
            pattern = "*.py",
            callback = function()
                -- Ensure `black` formats the buffer before saving
                vim.lsp.buf.format({ async = true })
            end,
        })
    end
}
