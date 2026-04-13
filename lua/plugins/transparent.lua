return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("transparent").setup({
        enable = true,
        extra_groups = {
          "NormalFloat",
          "NvimTreeNormal",
        },
        exclude = {},
      })

      vim.cmd("TransparentEnable")

      -- NOTE: controls vertical split separator (between NvimTree and editor)
      vim.api.nvim_set_hl(0, "WinSeparator", {
        fg = "#023dc7",
        bg = "NONE",
      })
    end,
  },
}