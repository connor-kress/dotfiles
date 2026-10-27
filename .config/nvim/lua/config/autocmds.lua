-- Restore buffer-word completion when the last completion server detaches.
vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        vim.schedule(function()
            require("config.completion").update(args.buf)
        end)
    end,
})

local small_indent_fts = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "html",
    "xml",
    "css",
    "json",
    "jsonc",
    "yaml",
    "toml",
    "tex",
}

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if vim.tbl_contains(small_indent_fts, vim.bo[args.buf].filetype) then
            vim.bo[args.buf].tabstop = 2
            vim.bo[args.buf].shiftwidth = 2
            vim.bo[args.buf].softtabstop = 2
        else
            vim.bo[args.buf].tabstop = 4
            vim.bo[args.buf].shiftwidth = 4
            vim.bo[args.buf].softtabstop = 4
        end
    end,
})

local document_fts = {
    "markdown",
    "rmd",
    "tex",
}

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if vim.tbl_contains(document_fts, vim.bo[args.buf].filetype) then
            vim.opt_local.spell = true
            vim.opt_local.breakindent = true
            vim.opt_local.breakindentopt = "shift:2"
        else
            vim.opt_local.spell = false
            vim.opt_local.breakindent = false
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
        if not ok or not parser then
            return
        end

        vim.treesitter.start(args.buf)
        if vim.treesitter.query.get(parser:lang(), "indents") then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
