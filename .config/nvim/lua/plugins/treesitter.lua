return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        ensure_installed = {
            "lua",
            "python",
            "c",
            "cpp",
            "cmake",
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
    },
    config = function(_, opts)
    require("nvim-treesitter").setup(opts)
    end,
}
