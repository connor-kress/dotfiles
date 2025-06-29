return {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "rust_analyzer",
                "jdtls",
                "pyright",
                "jsonls",
                "tsserver",
                "cssls",
                "tailwindcss",
                "bashls",
                "dockerls",
                "gopls",
            },
        })
    end,
    lazy = false,
    dependencies = {
        "williamboman/mason.nvim",
    },
}
