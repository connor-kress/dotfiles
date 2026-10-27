local M = {}
local enabled = true

function M.update(buffer)
    if not vim.api.nvim_buf_is_loaded(buffer) then
        return
    end

    local clients = vim.lsp.get_clients({ bufnr = buffer, method = "textDocument/completion" })
    vim.bo[buffer].autocomplete = enabled and #clients == 0
    for _, client in ipairs(clients) do
        -- Trigger while typing words as well as server-defined punctuation.
        local triggers = {}
        for i = 32, 126 do
            triggers[#triggers + 1] = string.char(i)
        end
        client.server_capabilities.completionProvider.triggerCharacters = triggers
        vim.lsp.completion.enable(enabled, client.id, buffer, {
            autotrigger = true,
            convert = function(item)
                local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Text"
                return { kind_hlgroup = "CompletionKind" .. kind }
            end,
        })
    end
end

function M.toggle()
    enabled = not enabled
    vim.o.autocomplete = enabled
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        M.update(buffer)
    end
    vim.notify("Completion " .. (enabled and "on" or "off"))
end

return M
