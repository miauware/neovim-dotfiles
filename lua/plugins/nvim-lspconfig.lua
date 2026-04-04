return {
  'neovim/nvim-lspconfig',

  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = {},
    },

    {
      'williamboman/mason-lspconfig.nvim',
      opts = {
        ensure_installed = {
          'lua_ls',
          'pyright',
        },
      },
    },

    {

      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          'lua_ls',
          'pyright',
          'black',
          'prettier',
        },
        run_on_start = true, -- INFO: force install on startup
        start_delay = 0,     -- INFO: no delay
      },
    },

    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
  },
}