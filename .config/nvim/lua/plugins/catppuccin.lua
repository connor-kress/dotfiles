return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        -- flavour = "auto" -- will respect terminal's background
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false, -- dims background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage shade for inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
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
        default_integrations = true,
        integrations = {
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = false,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
              -- For more plugins integrations please scroll down
              -- (https://github.com/catppuccin/nvim#integrations)
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
