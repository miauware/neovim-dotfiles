return {
  -- INFO: telescope plugin
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- INFO: opcional, mas necessário para a extensão fzf
    'nvim-telescope/telescope-fzf-native.nvim',
  },
  config = function()
    -- INFO: setup principal do telescope
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    })

    -- INFO: carregar extensão fzf com proteção
    pcall(require('telescope').load_extension, 'fzf')
  end
}