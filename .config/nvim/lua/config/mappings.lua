-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- oil (file nav)
vim.keymap.set('n', '-', '<CMD>Oil<CR>')

-- indentation
vim.keymap.set('v', '>', '>gv', {})
vim.keymap.set('v', '<', '<gv', {})

-- latex
vim.keymap.set("n", "<leader>l", ":w<CR>:!pdflatex %<CR>")
-- (already provided by the vimtex plugin)

-- comments (uses comment.nvim)
vim.api.nvim_set_keymap('n', '<C-c>', 'gcc', {})
vim.api.nvim_set_keymap('v', '<C-c>', 'gcgv', {})

