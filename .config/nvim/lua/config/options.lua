local opt = vim.opt
local g = vim.g

-- Globals
g.mapleader = " "
g.maplocalleader = " "
g.rustfmt_autosave = 1 -- Use Neovim's bundled Rust formatting support.
g.rustfmt_emit_files = 1 -- Use modern rustfmt flags instead of --write-mode.

-- Tab / Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.linebreak = true -- wrap on word break

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Appearance
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 10
opt.completeopt = "menu,menuone,noselect,popup,fuzzy"
opt.pumborder = ""
opt.autocomplete = true
opt.complete = "." -- Words from the current buffer; LSP takes over on attach.

-- Behaviour
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-")
opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
