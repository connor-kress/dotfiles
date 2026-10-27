local on_attach = function(client, buffer)
    local opts = { noremap = true, silent = true, buffer = buffer }
    require("config.mappings").set_lsp_keymap(client, opts)
    require("config.completion").update(buffer)
end

local config = function()
    vim.diagnostic.config({
        virtual_text = { -- turn on inline text
            -- prefix = "●",
            spacing = 2,
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.HINT]  = "󰌵 ",
                [vim.diagnostic.severity.INFO]  = "",
            },
        },
        underline = true, -- underline the problem range
        update_in_insert = false,
    })

    -- lua
    vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    -- make language server aware of runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
            },
        },
    })

    -- C/C++
    vim.lsp.config("clangd", {
        on_attach = on_attach,
        filetypes = { "c", "cpp" },
    })

    -- Rust
    vim.lsp.config("rust_analyzer", {
        on_attach = on_attach,
        filetypes = { "rust" },
        root_markers = { "Cargo.toml" },
        settings = {
            [ "rust_analyzer" ] = {
                cargo = {
                    allFeatures = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = false,
                    },
                },
            },
        },
    })

    -- python
    vim.lsp.config("pyright", {
        on_attach = on_attach,
        settings = {
            pyright = {
                disableOrganizeImports = false,
                analysis = {
                    useLibraryCodeForTypes = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    autoImportCompletions = true,
                },
            },
        },
    })

    -- json
    vim.lsp.config("jsonls", {
        on_attach = on_attach,
        filetypes = { "json", "jsonc" },
    })

    -- java
    vim.lsp.config("jdtls", {
        on_attach = on_attach,
        filetypes = { "java" },
    })

    -- typescript
    vim.lsp.config("ts_ls", {
        on_attach = on_attach,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", ".git" },
    })

    -- css
    vim.lsp.config("cssls", {
        on_attach = on_attach,
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", "tailwind.config.ts", ".git" },
        settings = {
            css = { validate = true,
                lint = { unknownAtRules = "ignore", },
            },
        },
    })

    -- tailwind
    vim.lsp.config("tailwindcss", {
        on_attach = on_attach,
        filetypes = {
            "html", "css", "javascript", "javascriptreact", "typescript",
            "typescriptreact", "vue", "svelte"
        },
        root_markers = { "package.json", "tailwind.config.ts", ".git" },
    })

    -- bash
    vim.lsp.config("bashls", {
        on_attach = on_attach,
        filetypes = { "sh" },
    })

    -- docker
    vim.lsp.config("dockerls", {
        on_attach = on_attach,
    })

    -- golang
    vim.lsp.config("gopls", {
        on_attach = on_attach,
        filetypes = { "go" },
    })
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    lazy = false,
    dependencies = {
        "windwp/nvim-autopairs",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
}
