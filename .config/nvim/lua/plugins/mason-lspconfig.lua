return {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "rust_analyzer",
                "pyright",
                "jsonls",
                "tsserver",
                "cssls",
                "tailwindcss",
                "bashls",
                "dockerls",
            },
        })
    end,
    lazy = false,
    dependencies = {
        "williamboman/mason.nvim",
    },
}
