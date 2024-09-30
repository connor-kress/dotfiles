return {
    "glepnir/lspsaga.nvim",
    lazy = false,
    config = function()
    require("lspsaga").setup({
        -- remove lightbulb symbols
        ui = {
            code_action = "",
        },
        -- keybinds for navigation in lspsaga window
        move_in_saga = { prev = "<c-k>", next = "<c-j>" },
        -- use enter to open file with finder
        finder_action_keys = {
            open = "<cr>",
        },
        -- use enter to open file with definition preview
        definition_action_keys = {
            edit = "<cr>",
        },
    })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
}
