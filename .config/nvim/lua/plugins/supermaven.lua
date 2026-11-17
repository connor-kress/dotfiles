return {
    "supermaven-inc/supermaven-nvim",
    enabled = vim.env.NVIM_DISABLE_SUPERMAVEN ~= "1",
    config = function()
        require("supermaven-nvim").setup({})
    end,
}
