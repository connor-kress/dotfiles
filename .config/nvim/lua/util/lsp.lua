local M = {}

M.on_attach = function(client, buffer)
    local opts = { noremap = true, silent = true, buffer = buffer }

    vim.keymap.set("n", "<leader>fd", ":Lspsaga finder<CR>", opts)                 -- go to definition
    vim.keymap.set("n", "<leader>gd", ":Lspsaga peek_definition<CR>", opts)        -- peak definition
    vim.keymap.set("n", "<leader>gD", ":Lspsaga goto_definition<CR>", opts)        -- go to definition
    vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<CR>", opts)            -- see available code actions
    vim.keymap.set("n", "<leader>rn", ":Lspsaga rename<CR>", opts)                 -- smart rename
    vim.keymap.set("n", "<leader>D", ":Lspsaga show_line_diagnostics<CR>", opts)   -- show diagnostics for line
    vim.keymap.set("n", "<leader>d", ":Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
    vim.keymap.set("n", "<leader>pd", ":Lspsaga diagnostic_jump_prev<CR>", opts)   -- jump to prev diagnostic in buffer
    vim.keymap.set("n", "<leader>nd", ":Lspsaga diagnostic_jump_next<CR>", opts)   -- jump to next diagnostic in buffer
    vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opts)                       -- show documentation for what is under cursor

    if client.name == "pyright" then
        vim.keymap.set("n", "<Leader>oi", "PyrightOrganizeImports", opts)
    end

    -- Format on save
    -- if client.server_capabilities.documentFormattingProvider then
    --     local group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --         group = group,
    --         buffer = buffer,
    --         callback = function()
    --             vim.lsp.buf.format({ async = false })
    --         end,
    --     })
    -- end
end

M.diagnostic_signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = "" }

return M
