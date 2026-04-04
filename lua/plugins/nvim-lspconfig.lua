return {
  -- INFO: LSP base config plugin
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end,
    },
    {
      'williamboman/mason-lspconfig.nvim',
      opts = {
        ensure_installed = { 'pyright' },
        automatic_installation = true,
      },
    },
    {
      'williamboman/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          'black',
          'prettier',
        },
      },
    },

    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    'folke/neodev.nvim',
  },

  config = function()
    -- INFO: new API (nvim 0.11+)
    vim.lsp.config('pyright', {})
    vim.lsp.enable('pyright')
  end,
}