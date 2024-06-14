local function contains(list, x)
    for _, v in ipairs(list) do
        if v == x then return true end
    end
    return false
end

local small_indent_fts = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "html",
    "css",
    "json",
}

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- print("filetype = " .. vim.bo.filetype)
        if contains(small_indent_fts, vim.bo.filetype) then
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
