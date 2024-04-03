local config = function()
  require("nvim-treesitter.configs").setup({
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
    },
    auto_install = true,
    highlight = {
      enabled = true,
      additional_vim_regex_highlighting = true,
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  config = config,
}
