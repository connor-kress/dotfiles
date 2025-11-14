local M = {}

local opts = { noremap = true, silent = true }
local opts_with_remap = { silent = true }

local map_key = vim.keymap.set
local nvim_map_key = vim.api.nvim_set_keymap

-- Telescope
local tele_builtin = require("telescope.builtin")
map_key("n", "<leader>ff", tele_builtin.find_files, opts)
map_key("n", "<leader>fg", tele_builtin.live_grep, opts)

-- Oil.nvim
map_key("n", "-", "<CMD>Oil<CR>", opts)

-- Indentation
map_key("v", ">", ">gv", opts)
map_key("v", "<", "<gv", opts)

local function toggle_breakindent()
    if vim.o.breakindent then
        vim.o.breakindent = false
    else
        vim.o.breakindent = true
        vim.o.breakindentopt = "shift:2"
    end
end

map_key("n", "<leader>i", toggle_breakindent, {
    desc = "Toggle breakindent",
})


-- Latex Compile
-- This is already provided by the vimtex plugin but is less consistent
map_key("n", "<leader>l", ":!pdflatex -output-directory=build %<CR>", opts)

-- R Markdown Compile
map_key("n", "<leader>r", ":!Rscript -e \"rmarkdown::render('%')\"<CR>", opts)

-- Comments (comment.nvim)
nvim_map_key("n", "<C-c>", "gcc", opts_with_remap)
nvim_map_key("v", "<C-c>", "gcgv", opts_with_remap)

-- Supermaven
map_key("n", "<leader>sm", ":SupermavenToggle<CR>", {
    desc = "Toggle Supermaven",
})

-- LSP Keymaps (used in lspconfig.lua for on_attach)
M.set_lsp_keymap = function(client, lsp_opts)
    map_key("n", "K", ":Lspsaga hover_doc<CR>", lsp_opts)
    map_key("n", "<leader>fd", ":Lspsaga finder<CR>", lsp_opts)
    map_key("n", "<leader>gd", ":Lspsaga peek_definition<CR>", lsp_opts)
    map_key("n", "<leader>gD", ":Lspsaga goto_definition<CR>", lsp_opts)
    map_key("n", "<leader>ca", ":Lspsaga code_action<CR>", lsp_opts)
    map_key("n", "<leader>rn", ":Lspsaga rename<CR>", lsp_opts)
    map_key("n", "<leader>D", ":Lspsaga show_line_diagnostics<CR>", lsp_opts)
    map_key("n", "<leader>d", ":Lspsaga show_cursor_diagnostics<CR>", lsp_opts)
    map_key("n", "<leader>pd", ":Lspsaga diagnostic_jump_prev<CR>", lsp_opts)
    map_key("n", "<leader>nd", ":Lspsaga diagnostic_jump_next<CR>", lsp_opts)
    if client.name == "pyright" then
        map_key("n", "<Leader>oi", ":PyrightOrganizeImports<CR>", lsp_opts)
    end
end

return M
