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

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- print("filetype = " .. vim.bo.filetype)
        if vim.tbl_contains(small_indent_fts, vim.bo.filetype) then
            vim.opt.tabstop = 2
            vim.opt.shiftwidth = 2
            vim.opt.softtabstop = 2
        else
            vim.opt.tabstop = 4
            vim.opt.shiftwidth = 4
            vim.opt.softtabstop = 4
        end
    end
})

local document_fts = {
    "markdown",
    "tex",
}

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- print("filetype = " .. vim.bo.filetype)
        if vim.tbl_contains(document_fts, vim.bo.filetype) then
            vim.o.spell = true
            vim.o.breakindent = true
            vim.o.breakindentopt = "shift:2"
        else
            vim.o.spell = false
            vim.o.breakindent = false
        end
    end
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
