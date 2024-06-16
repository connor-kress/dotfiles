return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == '..'
                end
            },
        })
    end
}
