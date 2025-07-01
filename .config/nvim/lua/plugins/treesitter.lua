return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
        require("nvim-treesitter.configs").setup({
            highlight = {
                enabled = true,
                additional_vim_regex_highlighting = true,
            },
            indent = { enabled = true },
            autotag = { enabled = true },
            ensure_installed = {
                "lua",
                "python",
                "cpp",
                "cmake",
                "c",
                "cpp",
                "rust",
                "java",
                "bash",
                "markdown",
                "javascript",
                "typescript",
                "html",
                "css",
                "yaml",
                "toml",
                "dockerfile",
                "gitignore",
                "latex",
            },
            auto_install = true,
        })
    end,
}
