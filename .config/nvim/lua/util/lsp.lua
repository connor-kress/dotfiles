local keymap = vim.keymap

local M = {}

M.on_attach = function(client, buffer)
  local opts = { noremap = true, silent = true, buffer = buffer }

  keymap("<leader>fd", "Lspsaga finder", "n", opts) -- go to definition
  keymap("<leader>gd", "Lspsaga peek_definition", "n", opts) -- peak definition
  keymap("<leader>gD", "Lspsaga goto_definition", "n", opts) -- go to definition
  keymap("<leader>ca", "Lspsaga code_action", "n", opts) -- see available code actions
  keymap("<leader>rn", "Lspsaga rename", "n", opts) -- smart rename
  keymap("<leader>D", "Lspsaga show_line_diagnostics", "n", opts) -- show  diagnostics for line
  keymap("<leader>d", "Lspsaga show_cursor_diagnostics", "n", opts) -- show diagnostics for cursor
  keymap("<leader>pd", "Lspsaga diagnostic_jump_prev", "n", opts) -- jump to prev diagnostic in buffer
  keymap("<leader>nd", "Lspsaga diagnostic_jump_next", "n", opts) -- jump to next diagnostic in buffer
  keymap("K", "Lspsaga hover_doc", "n", opts) -- show documentation for what is under cursor

  if client.name == "pyright" then
      keymap("<Leader>oi", "PyrightOrganizeImports", "n", opts)
  end
end

M.diagnostic_signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = "" }

return M
