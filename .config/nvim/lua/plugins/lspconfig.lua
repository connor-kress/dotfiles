local on_attach = function(client, buffer)
    local opts = { noremap = true, silent = true, buffer = buffer }
    require("config.mappings").set_lsp_keymap(client, opts)

    -- Format on save
    -- if client.server_capabilities.documentFormattingProvider then
    --     local group = vim.api.nvim_create_augroup(
    --         "FormatOnSave",
    --         { clear = true }
    --     )
    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --         group = group,
    --         buffer = buffer,
    --         callback = function()
    --             vim.lsp.buf.format({ async = false })
    --         end,
    --     })
    -- end
end

local config = function()
    require("neoconf").setup({})
    vim.diagnostic.config({
        virtual_text = { -- turn on inline text
            -- prefix = "●",
            spacing = 2,
        },
        signs = true, -- keep the gutter signs too
        underline = true, -- underline the problem range
        update_in_insert = false,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local servers = {}

    local configure_server = function(server, opts)
        table.insert(servers, server)
        vim.lsp.config(server, opts)
    end

    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.HINT]  = "󰌵 ",
                [vim.diagnostic.severity.INFO]  = "",
            },
        },
    })

    -- lua
    configure_server("lua_ls", {
        capabilities = capabilities,
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
    configure_server("clangd", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "c", "cpp" },
    })

    -- Rust
    configure_server("rust_analyzer", {
        capabilities = capabilities,
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
    configure_server("pyright", {
        capabilities = capabilities,
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
    configure_server("jsonls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "json", "jsonc" },
    })

    -- java
    configure_server("jdtls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "java" },
    })

    -- typescript
    configure_server("ts_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx", "css" },
        root_markers = { "package.json", "tsconfig.json", ".git" },
    })

    -- css
    configure_server("cssls", {
        capabilities = capabilities,
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
    configure_server("tailwindcss", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
            "html", "css", "javascript", "javascriptreact", "typescript",
            "typescriptreact", "vue", "svelte"
        },
        root_markers = { "package.json", "tailwind.config.ts", ".git" },
    })

    -- bash
    configure_server("bashls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh" },
    })

    -- docker
    configure_server("dockerls", {
        capabilities = capabilities,
        on_attach = on_attach,
    })

    -- golang
    configure_server("gopls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "go" },
    })

    vim.lsp.enable(servers)
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    lazy = false,
    dependencies = {
        "windwp/nvim-autopairs",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
    },
}
