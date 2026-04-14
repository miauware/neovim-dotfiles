return {
    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("transparent").setup({
                enable = true,
                extra_groups = {
                    "NormalFloat", "NvimTreeNormal", "TelescopeNormal",
                    "TelescopeBorder", "TelescopePromptNormal",
                    "TelescopePromptBorder", "TelescopeResultsNormal",
                    "TelescopePreviewNormal"
                },
                exclude = {}
            })

            vim.cmd("TransparentEnable")
        end
    }
}
