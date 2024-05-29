local builtin = require('telescope.builtin')
local set_vim_keymap = vim.keymap.set
local set_nvim_keymap = vim.api.nvim_set_keymap

set_vim_keymap('n', '<leader>ff', builtin.find_files, {})
set_vim_keymap('n', '<leader>fg', builtin.live_grep, {})

set_vim_keymap('v', '>', '>gv', {})
set_vim_keymap('v', '<', '<gv', {})

set_nvim_keymap('n', '<C-c>', 'gcc', {})
set_nvim_keymap('v', '<C-c>', 'gcgv', {})
