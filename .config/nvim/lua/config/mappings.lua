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

map_key("n", "<leader>ti", toggle_breakindent, {
    desc = "Toggle breakindent",
})


-- Latex Compile
-- This is already provided by the vimtex plugin but is less consistent
map_key("n", "<leader>l", ":!pdflatex -output-directory=build %<CR>", opts)

-- Make Compile
map_key("n", "<leader>m", ":!make<CR>", opts)

-- R Markdown Compile
map_key("n", "<leader>r", ":!Rscript -e \"rmarkdown::render('%')\"<CR>", opts)

-- Built-in commenting
nvim_map_key("n", "<C-c>", "gcc", opts_with_remap)
nvim_map_key("v", "<C-c>", "gcgv", opts_with_remap)

-- Native completion
map_key("n", "<leader>tc", function()
    require("config.completion").toggle()
end, { desc = "Toggle completion" })

map_key("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true })
map_key("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true })
map_key("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected >= 0 then
        return "<C-y>"
    end
    return "<CR>"
end, { expr = true })

-- Supermaven
map_key("n", "<leader>sm", ":SupermavenToggle<CR>", {
    desc = "Toggle Supermaven",
})

-- LSP Keymaps (used in lspconfig.lua for on_attach)
M.set_lsp_keymap = function(client, lsp_opts)
    map_key("n", "K", function()
        vim.lsp.buf.hover({ border = "single" })
    end, lsp_opts)
    map_key("n", "<leader>fd", tele_builtin.lsp_references, lsp_opts)
    map_key("n", "<leader>gd", function()
        tele_builtin.lsp_definitions({ jump_type = "never" })
    end, lsp_opts)
    map_key("n", "<leader>gD", vim.lsp.buf.definition, lsp_opts)
    map_key("n", "<leader>ca", vim.lsp.buf.code_action, lsp_opts)
    map_key("n", "<leader>rn", vim.lsp.buf.rename, lsp_opts)
    map_key("n", "<leader>D", function()
        vim.diagnostic.open_float({ scope = "line" })
    end, lsp_opts)
    map_key("n", "<leader>d", function()
        vim.diagnostic.open_float({ scope = "cursor" })
    end, lsp_opts)
    map_key("n", "<leader>pd", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, lsp_opts)
    map_key("n", "<leader>nd", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, lsp_opts)
    if client.name == "pyright" then
        map_key("n", "<Leader>oi", ":PyrightOrganizeImports<CR>", lsp_opts)
    end
end

return M
