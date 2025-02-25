-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- oil (file nav)
vim.keymap.set('n', '-', '<CMD>Oil<CR>')

-- indentation
vim.keymap.set('v', '>', '>gv', {})
vim.keymap.set('v', '<', '<gv', {})

-- latex compile
vim.keymap.set("n", "<leader>l", ":w<CR>:!pdflatex -output-directory=build %<CR>")
-- (already provided by the vimtex plugin?)

-- R markdown compile
vim.keymap.set("n", "<leader>r", ":w<CR>:!Rscript -e \"rmarkdown::render('%')\"")


-- comments (uses comment.nvim)
vim.api.nvim_set_keymap('n', '<C-c>', 'gcc', {})
vim.api.nvim_set_keymap('v', '<C-c>', 'gcgv', {})

