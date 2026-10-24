return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({})
        treesitter.install({
            "lua",
            "python",
            "c",
            "cpp",
            "cmake",
            "go",
            "rust",
            "java",
            "bash",
            "markdown",
            "markdown_inline",
            "javascript",
            "json",
            "typescript",
            "tsx",
            "html",
            "css",
            "yaml",
            "toml",
            "dockerfile",
            "gitignore",
            "latex",
        })

        -- Use rust highlighting for darlang files
        vim.treesitter.language.register("rust", "darlang")
    end,
}
