return {
    "romgrk/barbar.nvim",
    dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    config = function ()
        local barbar = require("barbar")
        barbar.setup({})
        local map = vim.api.nvim_set_keymap
        map('n', '<tab>', '<Cmd>BufferNext<CR>', { desc = "Next Buffer/tab"})
        map('n', '<S-tab>', '<Cmd>BufferPrevious<CR>', { desc = "Previous Buffer/Tab"})
    end
}
