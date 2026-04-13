return {
    -- INFO: Tree-sitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = { "lua", "python", "javascript", "vim" },
            auto_install = true,
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
    },

    -- INFO: indent-blankline 
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Configuração mais básica que funciona 100%
            require("ibl").setup({
                indent = {
                    char = "│",
                    highlight = {
                        "Function",
                        "Statement",
                        "Conditional",
                        "Repeat",
                        "Operator",
                        "Keyword",
                        "String",
                    },
                },
                scope = {
                    enabled = true,
                },
            })
            
           
            vim.api.nvim_set_hl(0, "Function", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "Statement", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "Conditional", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "Repeat", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "Operator", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "Keyword", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "String", { fg = "#56B6C2" })
        end,
    },
}