local opts = {
  ensure_installed = {
    "efm",
    "lua_ls",
    "clangd",
    "rust_analyzer",
    "emmet_ls",
  },
  automatic_installation = true,
}

return {
  "williamboman/mason-lspconfig.nvim",
  event = "BufReadPre",
  opts = opts,
  dependencies = "williamboman/mason.nvim",
}
