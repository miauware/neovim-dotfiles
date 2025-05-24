return {
  -- INFO: file manager tree plugin 
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Configuração do nvim-tree
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 26,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      actions = {
        open_file = {
          quit_on_open = false,  -- Não fecha o nvim-tree ao abrir o arquivo
        },
      },
    })

    -- Função global para abrir o arquivo sob o cursor em uma nova aba
    _G.open_file_in_new_tab = function()
      local node = require("nvim-tree.api").tree.get_node_under_cursor()
      if node and node.absolute_path then
        vim.cmd("tabnew " .. vim.fn.fnameescape(node.absolute_path))
      end
    end

    -- Mapeamento para abrir arquivos em nova aba com Ctrl + Clique
    vim.api.nvim_set_keymap('n', '<C-LeftMouse>', '<cmd>lua open_file_in_new_tab()<CR>', { noremap = true, silent = true })
  end,
}