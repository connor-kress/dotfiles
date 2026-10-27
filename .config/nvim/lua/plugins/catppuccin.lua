return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
        flavour = "mocha",
        custom_highlights = function(colors)
            local highlights = {
                Pmenu = { fg = colors.overlay2, bg = colors.base },
                PmenuSel = { fg = colors.text, bg = colors.surface0 },
                PmenuMatch = { fg = colors.text, bold = true },
                PmenuMatchSel = { fg = colors.text, bold = true },
                PmenuKind = { fg = colors.blue },
                PmenuKindSel = { fg = colors.blue, bg = colors.surface0 },
                PmenuBorder = { fg = colors.overlay0, bg = colors.base },
            }
            local kind_colors = {
                Text = colors.teal,
                Method = colors.blue,
                Function = colors.blue,
                Constructor = colors.blue,
                Field = colors.green,
                Variable = colors.flamingo,
                Class = colors.yellow,
                Interface = colors.yellow,
                Module = colors.blue,
                Property = colors.green,
                Unit = colors.green,
                Value = colors.peach,
                Enum = colors.green,
                Keyword = colors.red,
                Snippet = colors.mauve,
                Color = colors.red,
                File = colors.blue,
                Reference = colors.red,
                Folder = colors.blue,
                EnumMember = colors.red,
                Constant = colors.peach,
                Struct = colors.blue,
                Event = colors.blue,
                Operator = colors.blue,
                TypeParameter = colors.blue,
            }
            for kind, color in pairs(kind_colors) do
                highlights["CompletionKind" .. kind] = { fg = color }
            end
            return highlights
        end,
        integrations = {
            notify = false,
            mini = {
                indentscope_color = "",
            },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
