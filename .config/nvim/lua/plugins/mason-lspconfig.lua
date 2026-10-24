local servers = {
    "lua_ls",
    "clangd",
    "rust_analyzer",
    "jdtls",
    "pyright",
    "jsonls",
    "ts_ls",
    "cssls",
    "tailwindcss",
    "bashls",
    "dockerls",
    "gopls",
}

return {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_enable = servers,
        })
    end,
    lazy = false,
    dependencies = {
        "williamboman/mason.nvim",
    },
}
