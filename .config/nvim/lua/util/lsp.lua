local M = {}

M.on_attach = function(client, buffer)
  local opts = { noremap = true, silent = true, buffer = buffer }

  vim.keymap.set("n", "<leader>fd", "Lspsaga finder", opts) -- go to definition
  vim.keymap.set("n", "<leader>gd", "Lspsaga peek_definition", opts) -- peak definition
  vim.keymap.set("n", "<leader>gD", "Lspsaga goto_definition", opts) -- go to definition
  vim.keymap.set("n", "<leader>ca", "Lspsaga code_action", opts) -- see available code actions
  vim.keymap.set("n", "<leader>rn", "Lspsaga rename", opts) -- smart rename
  vim.keymap.set("n", "<leader>D", "Lspsaga show_line_diagnostics", opts) -- show  diagnostics for line
  vim.keymap.set("n", "<leader>d", "Lspsaga show_cursor_diagnostics", opts) -- show diagnostics for cursor
  vim.keymap.set("n", "<leader>pd", "Lspsaga diagnostic_jump_prev", opts) -- jump to prev diagnostic in buffer
  vim.keymap.set("n", "<leader>nd", "Lspsaga diagnostic_jump_next", opts) -- jump to next diagnostic in buffer
  vim.keymap.set("n", "K", "Lspsaga hover_doc", opts) -- show documentation for what is under cursor

  if client.name == "pyright" then
      vim.keymap.set("n", "<Leader>oi", "PyrightOrganizeImports", opts)
  end
end

M.diagnostic_signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = "" }

return M
